component persistent="true" accessors="true" table="person" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database column default value.
   If a default property is set, ORM tries to update the record to the default. For string fields, this may violate
   violate a unique index or overwrite a database NULL.
*/
{
//  property name="key" type="string" ormtype="string" persistent="false";
	property name="personId" column="person_id" type="numeric" ormtype="int" fieldtype="id" generator="identity" notnull="true";
	property name="lastName" column="last_name" type="string" ormtype="string" notnull="true" length="128" default="";
	property name="firstName" column="first_name" type="string" ormtype="string" notnull="true" length="128" default="";
	property name="fullName" type="string" persistent="false" getter="true" default="";
	property name="email" column="email" type="string" ormtype="string" notnull="true" length="128" unique="yes";
	property name="phoneNumber" column="phone_number" type="string" ormtype="string" notnull="false" length="10" default="";
	property name="stateCertNumber" column="state_cert_number" type="string" ormtype="string" length="10" unique="yes"; //12/25/2017: Do not set a default value; if one is set, ORM tries to update the record to the default. And for this field, that would violate a unique index.
	property name="stateCertLevel" column="state_cert_level" type="string" ormtype="string" length="16" default="";
	property name="instructorCertExpiration" column="instructor_cert_expiration" type="date" ormtype="date";
	property name="isNREMTRep" column="is_an_nremt_rep" type="numeric" ormtype="byte" notnull="true" default="0" dbdefault="0";
	property name="hireDate" column="hire_date" type="date" ormtype="date" notnull="false";
	property name="active" column="active" type="numeric" ormtype="byte" notnull="true" default="1" dbdefault="1";
	property name="password" column="password" type="string" ormtype="string" notnull="false" getter="false" default=""; //don't allow this to be out in the wild for web services to see
	property name="salt" column="salt" type="string" ormtype="string" notnull="false" getter="false" default=""; //don't allow this to be out in the wild for web services to see
  property name="address" column="address" type="string" ormtype="string" notnull="true" default="";
  property name="city" column="city" type="string" ormtype="string" notnull="true" default="";
  property name="state" column="state" type="string" ormtype="string" notnull="true" length="2" default="";
  property name="zip" column="zip" type="string" ormtype="string" notnull="true" length="5" default="";
  property name="emplId" column="emplid" type="string" ormtype="string" notnull="false" length="5" default="";
  property name="quickbooksCustomerId" column="quickbooks_customer_id" type="numeric" ormtype="int" notnull="false";
  property name="createdOn" column="created_on" type="date" ormtype="java.sql.Timestamp" notnull="true" setter="false" update="false";
  property name="createdBy" column="created_by" type="numeric" ormtype="int" notnull="true" setter="false";
  property name="updatedOn" column="updated_on" type="date" ormtype="java.sql.Timestamp" notnull="true" setter="false";
  property name="updatedBy" column="updated_by" type="numeric" ormtype="int" notnull="true" setter="false";
//  property name="accountCreationConfirmed" column="account_creation_confirmed" type="numeric" ormtype="byte" notnull="true" dbdefault="0" default="0";
//  property name="accountCreatedTimeAsJson" type="string" persistent="false";

//  property name="contexts" fieldtype="one-to-many" cfc="context" fkcolumn="person_id"
//           type="array" cascade="refresh" lazy="false" fetch="select" inverse="true" remotingfetch="true";

  public String function getAccountCreatedTimeAsJson() {
    if (StructKeyExists(variables, "createdOn"))
      return DateFormat( Application.TimeConverter.convertUTCToLocal(variables.createdOn), "yyyy/mm/dd" );
    else
      return;
  }

	public String function getKey()
	{
		return StructKeyExists(Variables, "personId") ? getPersonId() : "";
	}


	public String function getFullName()
	{
	  return getfirstName() & " " & getlastName();
	}

	public String function getPhoneNumber()
	{
		if (StructKeyExists(Variables, "phoneNumber"))
	    return "(" & left(variables.phoneNumber,3) & ") " & mid(variables.phoneNumber,4,3) & "-" & right(variables.phoneNumber,4);
	  else
	    return "";
	}

	public void function setPhoneNumber(String phoneNumber)
	{
	  cleanNumber = REReplace(Arguments.phoneNumber, "[^0-9]", "", "ALL");
	  if (Len(cleanNumber) != 10)
	  {
	    throw("A phone number must have 10 digits. You have " & Len(cleanNumber) & " digits.", "", "Phone number provided: " & arguments.phoneNumber);
	  }
    variables.phoneNumber = cleanNumber;
	}

  public String function getCreatedOn() {
    if (StructKeyExists(variables, "createdOn")) {
      var localtimecreatedon = variables.createdOn;
      return DateFormat( localTimeCreatedOn, "yyyy-MM-dd" ) & "T" & TimeFormat(localTimeCreatedOn, "HH:nn:ss" ) & "Z";
    }
    else
      return;
  }

  public String function getUpdatedOn() {
    if (StructKeyExists(variables, "updatedOn")) {
      var localTimeUpdatedOn = variables.updatedOn;
      return DateFormat(localTimeUpdatedOn, "yyyy-MM-dd" ) & "T" & TimeFormat(localTimeUpdatedOn, "HH:nn:ss" ) & "Z";
    }
    else
      return;
  }

  public String function getSaltValue() {
  	return variables.salt;
  }

  public String function getThePassword() {
  	return variables.password;
  }

  //returns a hash that can be used for account creation link in an email
  public String function getHashForAccountCreation() {
  	return Hash(getSaltValue(), "MD5");
  }

  public void function setState(string state) {
  	variables.state = UCase(arguments.state);
  }

  public void function preLoad() {
  }

  public void function postLoad() {
  }

  /* These events will only occur inside an ORM transaction. Outside a transaction, they aren't called until the session is flushed. */
  public void function preInsert() {
    variables.salt = CreateUUId();
    variables.createdBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
    variables.updatedBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
  }

  public void function postInsert() {
  	throw(message="postInsert");
  }

  remote void function preUpdate(Struct oldData) {
    variables.updatedBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
  }

  public void function postUpdate() {
    throw(message="postUpdate");
  }

  public void function preDelete() {
  	throw(message="preDelete");
  }

  public void function postDelete() {
  	throw(message="postDelete");
  }

}
