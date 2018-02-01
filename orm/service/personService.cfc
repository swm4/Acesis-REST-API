component //extends="lib.remoteProxy"
{

	orm.person function createPerson(orm.person item)
	{
		//At time of creation, attempt to also create a Quickbooks Customer. Get qb customer id, add it to the person object in the database.
		transaction {
	  	entitySave(item);
    }
		return item;
	}

  remote orm.person[] function getAllEmployees()
  {
  	return ORMExecuteQuery("FROM person WHERE emplid IS NOT NULL");
  }


	remote orm.person[] function getAllPersons()
	{
		return ORMExecuteQuery("FROM person WHERE id > 0");
	}

  
	/* Get person */
	remote orm.person function getPerson( personId )
	{
		if ((Arguments.personId != "undefined") AND (IsNumeric(Arguments.personId)))
		{
		  var primaryKeysMap = { personId = Arguments.personId };
  		var person = entityLoad("person", primaryKeysMap, true);
  		
      return (IsNull(person) == False) ? person : EntityNew("person");
		}
		else {
      return EntityNew("person");
		}
	}

  public orm.person function getPersonByUsername( string username, string password )
  {
    if ((arguments.username == "") or (arguments.password == ""))
      throw(message = "Username and/or the password are not correct",
            detail = "",
            errorcode = application.RESTCodes.status_401_UNAUTHORIZED );

    var primaryKeysMap = { email = arguments.username };
    var person = entityLoad("person", primaryKeysMap, True);
    if (IsNull(person))
      throw(message = "Username and/or the password are not correct",
            detail = "",
            errorcode = application.RESTCodes.status_401_UNAUTHORIZED );
    else
    {
      if (Hash(arguments.password & person.getSaltValue(), "SHA-512") == person.getThePassword())
        return person;
      else
        throw(message = "Username and/or the password are not correct",
              detail = "",
              errorcode = application.RESTCodes.status_401_UNAUTHORIZED );
    }

  }

	
  /* Get person. Return an array instead of a single object. That's because a null value returned causes errors in the calling code' */
  remote any function getPersonByEmailAddress( string emailAddress, Boolean returnNewObjectIfNotFound )
  {
    if ((Arguments.emailAddress != ""))
    {
      var primaryKeysMap = { email = Arguments.emailAddress };
      var person = entityLoad("person", primaryKeysMap, True);
      if (IsNull(person))
        if (Arguments.returnNewObjectIfNotFound == True)
          return EntityNew("person");
        else
          return;
      else
        return person;
    }
  }

  /* Get person. Return an array instead of a single object. That's because a null value returned causes errors in the calling code' */
  remote any function getPersonByNREMTAccountNumber( string nremtAccountNumber, Boolean returnNewObjectIfNotFound )
  {
    if ((Arguments.nremtAccountNumber != ""))
    {
      var primaryKeysMap = { nremtAccountNumber = Arguments.nremtAccountNumber };
      var person = entityLoad("person", primaryKeysMap, True);
      if (IsNull(person))
        if (Arguments.returnNewObjectIfNotFound == True)
          return new orm.person();
        else
          return;
      else
        return person;
    }
  }

	/* Save person */
	orm.person function updatePerson(orm.person item)
	{
    transaction 
    {
      //Need to check that required fields are here, constraints are met, etc.
      var errorList = ArrayNew(1);
      var ormProperties = getMetaData(arguments.item).properties;
      for (var i=1; i<=ArrayLen(ormProperties);i++) {
      	//This is a db column property
      	if ((StructKeyExists(ormProperties[i], "column") == True) and 
      	    (StructKeyExists(ormProperties[i], "generator") == False)) {
      	  try { //Sometimes the getter doesn't exist'
        	  var methodResult = invoke(arguments.item, "get" & ormProperties[i].name); //.name is the property name, trying to invoking it dynamically here  	
            if (StructKeyExists(ormProperties[i], "notnull") and (ormProperties[i].notnull == "true")) {
              if ((IsDefined("methodResult") == False) or (methodResult == ""))
                ArrayAppend(errorList, ormProperties[i].name & " cannot be blank");
            }
            if (StructKeyExists(ormProperties[i], "length")) {
              if ((IsDefined("methodResult") == True) and (Len(methodResult)) > ormProperties[i].length)
                ArrayAppend(errorList, ormProperties[i].name & " cannot be longer than " & ormProperties.length & " characters");;  
            }
          }
          catch (Expression e) { 
          	//Fail silently here if a getter does not exist
          }
      		
      	}
      }
      
      if (ArrayLen(errorList) > 0) {
      	returnErrorMessages(errorList); 
      }
      
      /* Need to update the audit fields and set the password salt */
      if (arguments.item.getPersonId() == "")
      {
        throw(message="here1");this.createPerson(arguments.item);
      }
      else {
        entitySave(arguments.item);
        
      }
    }    
    return arguments.item;

	}
	
  /* Allows calling from AJAX or Angular, anything that needs to pass it via JSON */
  remote any function updatePersonFromJSON(String item) httpmethod="POST"
  {
    var personJSON = deserializeJSON(item);
    
    if ((StructKeyExists(personJSON.person, "personId") == True) &&
        (personJSON.person.personId != ""))
      var person = this.getPerson(personJSON.person.personId);
    else if (StructKeyExists(personJSON.person, "nremtAccountNumber"))
      var person = this.getPersonByNREMTAccountNumber(personJSON.person.nremtAccountNumber, true);
    else
      var person = EntityNew("person");
    
    transaction {    
      person.setFirstName(StructKeyExists(personJSON.person, "firstName") ? personJSON.person.firstName : javacast("null", ""));
      person.setLastName(StructKeyExists(personJSON.person, "lastName") ? personJSON.person.lastName : javacast("null", ""));
      person.setEmail(StructKeyExists(personJSON.person, "email") ? personJSON.person.email : javacast("null", ""));
      person.setPhoneNumber(StructKeyExists(personJSON.person, "phoneNumber") ? personJSON.person.phoneNumber : javacast("null", ""));
      person.setStateCertNumber(StructKeyExists(personJSON.person, "stateCertNumber") ? personJSON.person.stateCertNumber : javacast("null", ""));
      person.setInstructorCertExpiration(StructKeyExists(personJSON.person, "instructorCertExpiration") ? personJSON.person.instructorCertExpiration : javacast("null", ""));
      person.setStateCertLevel(StructKeyExists(personJSON.person, "stateCertLevel") ? personJSON.person.stateCertLevel : javacast("null", ""));
      person.setAddress(StructKeyExists(personJSON.person, "address") ? personJSON.person.address : javacast("null", ""));
      person.setCity(StructKeyExists(personJSON.person, "city") ? personJSON.person.city : javacast("null", ""));
      person.setState(StructKeyExists(personJSON.person, "state") ? personJSON.person.state : javacast("null", ""));
      person.setZip(StructKeyExists(personJSON.person, "zip") ? personJSON.person.zip : javacast("null", ""));
      person.setNremtAccountNumber(StructKeyExists(personJSON.person, "nremtAccountNumber") ? personJSON.person.nremtAccountNumber : javacast("null", ""));
      person.setIsNREMTRep(StructKeyExists(personJSON.person, "isNREMTRep"));
      person.setActive(1); 
    
      //Create a new API response object.
      var response = this.NewAPIResponse();
      response.data = this.updatePerson(person);
    }
    return response;
  }	

}