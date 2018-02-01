component extends="lib.remoteProxy"
{
	
	remote Array function getValidContextTypes()
	{
		var values = ArrayNew(1);
		values.append("ENROLLMENT");
		values.append("PRIMARY INSTRUCTOR");
		values.append("Candidate");
		values.append("Examiner");
		return values;
	}
	
	
	remote orm.context function createExamEnrollmentFromJSON(String item) method="POST"
	{
    var formData = deserializeJSON(Arguments.item);
    
    var personSvc = new orm.service.personService();
    var courseSvc = new orm.service.courseService();
    var person = personSvc.getPerson(formData.personId);	
    var course = courseSvc.getCourse(formData.courseId);
    transaction {
      var context = new orm.context();
      context.setPerson(person);    
      context.setCourse(course);
      context.setContextType("Candidate");
  //    context.setConfirmed(False);
    }      
		return this.createContext(context);
	}
	
	orm.context function createContext(orm.context item)
	{
    transaction 
    {
      arguments.item.setUpdatedBy(Session.User.getPersonId());;
	  	entitySave(arguments.item);
		}
		return item;		
	}

	void function deleteContext( context_id	)
	{
		transaction {
  		var primaryKeysMap = { context_id = context_id };
  		var item = entityLoad("context",primaryKeysMap,true);
  		if(isNull(item) eq false)
  			entityDelete(item);
    }		
		return;
	}

  remote any function getAllContexts( numeric courseId )
  {
    var response = this.NewAPIResponse();
    response.data = this.getAllContext(arguments.courseId);
    return response;      
  }

  remote any function getAllContextsByType( numeric courseId, string contextType )
  {
    var response = this.NewAPIResponse();
    var contexts = this.getAllContextByType(arguments.courseId, arguments.contextType);
    return response;
  }

  orm.context[] function getAllContextByType( numeric courseId, string contextType )
  {
    var contexts = ORMExecuteQuery("FROM context WHERE courseId = :id AND contextType = :contexttype", 
                                   {id : arguments.courseId, contexttype : arguments.contextType}, False);
    return contexts;  
  }

	orm.context[] function getAllContext( numeric courseId )
	{
    var contexts = ORMExecuteQuery("FROM context WHERE course.courseId = :id", {id : arguments.courseId}, False);
		return contexts;
	}

	orm.context function getContext( context_id )
	{
		var primaryKeysMap = { contextId = Arguments.context_id };
		return entityLoad("context", primaryKeysMap, true);
	}

} 
