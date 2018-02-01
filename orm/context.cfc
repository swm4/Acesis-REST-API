component persistent="true" accessors="true" table="context" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
  property name="key" type="string" ormtype="string" persistent="false";
  property name="contextId" column="context_id" type="numeric" ormtype="int" fieldtype="id" generator="identity" insert="false" notnull="true";
  property name="personId" column="person_id" type="numeric" ormtype="int" notnull="true" insert="false" update="false";
  property name="courseId" column="course_id" type="numeric" ormtype="int" notnull="true" insert="false" update="false";
  property name="contextType" column="context_type" type="string" ormtype="string" notnull="true";
  property name="registrationEmailSent" column="registration_email_sent" type="date" ormtype="timestamp" notnull="false";
  property name="price" column="price" type="numeric" ormtype="double" notnull="true";
  property name="stateCourseNumber" column="state_course_number" type="string" ormtype="string" notnull="false" length="20";
  property name="PATT" column="PATT" type="string" ormtype="string" notnull="false" length="20";
  property name="createdOn" column="created_on" type="date" ormtype="java.sql.Time" setter="false" notnull="true";
  property name="createdBy" column="created_by" type="numeric" ormtype="int" setter="false" notnull="true";
  property name="updatedOn" column="updated_on" type="date" ormtype="java.sql.Time" setter="false" notnull="true";
  property name="updatedBy" column="updated_by" type="numeric" ormtype="int" notnull="true" setter="false";

  property name="person" fieldtype="one-to-one" cfc="person" fkcolumn="person_id"
           type="struct" lazy="false" fetch="select" remotingfetch="true";

  property name="course" fieldtype="one-to-one" cfc="course" fkcolumn="course_id" 
           type="struct" lazy="false" fetch="select" remotingfetch="true";

  
  public String function getKey()
  {
    if (StructKeyExists(Variables, "contextId"))
      return getContextId();
    else
      return "";
  } 
    

  /* These events will only occur inside an ORM transaction. Outside a transaction, they aren't called until the session is flushed. */
  public void function preInsert() {
    throw(message="preInsert");
  }

  public void function postInsert() {
    throw(message="postInsert");
  }
 
  remote void function preUpdate(Struct oldData) {
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
