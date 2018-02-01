component persistent="true" table="course" schema="ees" datasource="ees" accessors="true"  
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
//	property name="key" type="string" ormtype="string" persistent="false";
	property name="courseId" column="course_id" generator="identity" fieldtype="id" notnull="true"; 
	property name="courseIdent" column="course_ident" type="string" ormtype="string" notnull="true"; 
	property name="courseLevel" column="course_level" type="string" ormtype="string" notnull="true"; 
	property name="courseType" column="course_type" type="string" ormtype="string" notnull="true"; 
	property name="startDate" column="start_date" type="date" ormtype="date" notnull="true"; 
  property name="endDate" column="end_date" type="date" ormtype="date" notnull="true";
	property name="startTime" column="start_time" type="date" ormtype="timestamp" notnull="false";
	property name="endTime" column="end_time" type="date" ormtype="timestamp" notnull="false";
	property name="createdOn" column="created_on" type="date" ormtype="java.sql.Time" setter="false" notnull="true";
	property name="createdBy" column="created_by" type="numeric" ormtype="int" setter="false" notnull="true";
	property name="updatedOn" column="updated_on" type="date" ormtype="java.sql.Time" setter="false" notnull="true";
	property name="updatedBy" column="updated_by" type="numeric" ormtype="int" notnull="true" setter="false";
	property name="location" column="location" type="string" ormtype="string" notnull="false" length="64" default=""; 
  property name="address1" column="address_1" type="string" ormtype="string" notnull="false" default="";
  property name="city" column="city" type="string" ormtype="string" notnull="false" default="";
  property name="state" column="state" type="string" ormtype="string" notnull="false" length="2" default="";
  property name="zip" column="zip" type="string" ormtype="string" notnull="false" length="5" default="";
	property name="agency" column="agency" type="string" ormtype="string" notnull="false" length="64";
  property name="capacity" column="capacity" type="numeric" ormtype="int" notnull="true";
//  property name="registrationOpens" column="registration_opens" type="date" ormtype="timestamp" notnull="false";
//  property name="registrationCloses" column="registration_closes" type="date" ormtype="timestamp" notnull="false";
  property name="showToPublic" column="show_to_public" type="numeric" ormtype="byte" notnull="true";
  property name="price" column="price" type="numeric" ormtype="double" notnull="true";
  property name="stateCourseNumber" column="state_course_number" type="string" ormtype="string" notnull="false";
  property name="studentCount" type="numeric" ormtype="int" persistent="false";
	property name="startTimeAsJson" type="string" persistent="false";
	property name="endTimeAsJson" type="string" persistent="false";
	property name="spaceAvailable" type="int" persistent="false";
  property name="courseDateAsJson" type="string" persistent="false";

  property name="contexts" fieldtype="one-to-many" cfc="context" fkcolumn="course_id"
           type="array" cascade="refresh" lazy="false" fetch="select" remotingFetch="false";

  public string function getCourseDateAsJson() { 
    if (StructKeyExists(variables, "startDate"))
      return DateFormat( variables.startDate, "yyyy/mm/dd" );
    else
      return;
  }

  public String function getStartTimeAsJson() {
    if (StructKeyExists(variables, "startTime"))
      return TimeFormat( variables.startTime, "HH:mm" );
    else
      return;  	
  }

  public String function getEndTimeAsJson() {
    if (StructKeyExists(variables, "endTime"))
      return TimeFormat( variables.endTime, "HH:mm" );
    else
      return;   
  }

  public String function getKey()
  {
    if (StructKeyExists(Variables, "courseId"))
      return getCourseId();
    else
      return;
  }	
  
  public Numeric function getStudentCount() {
  	return StructKeyExists(variables, "contexts") ? ArrayLen(variables.contexts) : 0;
  }  	

  public Numeric function getSpaceAvailable() {
  	return StructKeyExists(variables, "contexts") ? this.getCapacity()-ArrayLen(variables.contexts) : this.getCapacity();
  }   

  public String function getCreatedOn() {
  	if (StructKeyExists(variables, "createdOn")) {
  		var localTimeCreatedOn = variables.createdOn;
      return DateFormat( localTimeCreatedOn, "yyyy-MM-dd" ) & "T" & TimeFormat(localTimeCreatedOn, "HH:mm:ss" ) & "Z";
    }
    else
      return;
  }
  
  public String function getUpdatedOn() {
  	if (StructKeyExists(variables, "updatedOn")) {
  	  var localTimeUpdatedOn = variables.updatedOn;
      return DateFormat(localTimeUpdatedOn, "yyyy-MM-dd" ) & "T" & TimeFormat(localTimeUpdatedOn, "HH:mm:ss" ) & "Z";
    }
    else
    	return;
  }
  
  public String function getStartDate() {
  	if (StructKeyExists(variables, "startDate"))
      return DateFormat( variables.startDate, "yyyy-MM-dd" );
    else
      return;
  }  

  public String function getEndDate() {
    if (StructKeyExists(variables, "endDate")) {
      return DateFormat( variables.endDate, "yyyy-MM-dd" );
    }
    else
      return;
  }  

   public String function getStartTime() {
  	if (StructKeyExists(variables, "startTime"))
      return TimeFormat( variables.startTime, "HH:mm" );
    else
      return;
  }  

  public String function getEndTime() {
    if (StructKeyExists(variables, "endTime"))
      return TimeFormat( variables.endTime, "HH:mm" );
    else
      return;
  } 
 
  /* These events will only occur inside an ORM transaction. Outside a transaction, they aren't called until the session is flushed. */
  public void function preInsert() {
    variables.createdBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
    variables.updatedBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
    variables.capacity = StructKeyExists(variables, "capacity") ? variables.capacity : 0;
  }

  public void function postInsert() {
  }
 
  public void function preUpdate(Struct oldData) {
    variables.updatedBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
  }
  
  public void function postUpdate() {
  }

  public void function preDelete() {
    throw(message="preDelete");
  }

  public void function postDelete() {
    throw(message="postDelete");
  }
  
} 
