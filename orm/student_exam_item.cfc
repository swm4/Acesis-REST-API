component persistent="true" table="student_exam_item" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
  property name="studentExamItemId" column="student_exam_item_id" type="numeric" ormtype="int" fieldtype="id" generator="identity";
  property name="studentExamId" column="student_exam_id" type="numeric" ormtype="int" notnull="true";
  property name="itemDescription" column="item_description" type="string" ormtype="string" notnull="true" length="256";
  property name="possibleScore" column="possible_score" type="numeric" ormtype="int" notnull="true";
  property name="displayOrder" column="display_order" type="numeric" ormtype="int" notnull="true";
  property name="score" column="score" type="numeric" ormtype="int" notnull="false";
  property name="comments" column="comments" type="string" ormtype="string" notnull="false";
  property name="itemType" column="item_type" type="string" ormtype="string" length="64" notnull="false" default="";
  property name="createdOn" column="created_on" type="date" ormtype="timestamp" notnull="true" setter="false";
  property name="createdBy" column="created_by" type="numeric" ormtype="int" notnull="true" setter="false"; 
  property name="updatedOn" column="updated_on" type="date" ormtype="timestamp" notnull="true" setter="false";
  property name="updatedBy" column="updated_by" type="numeric" ormtype="int" notnull="true" setter="false";
	
  public void function preLoad() {
  }

  public void function postLoad() {
  }

  /* These events will only occur inside an ORM transaction. Outside a transaction, they aren't called until the session is flushed. */
  public void function preInsert() {
    variables.createdBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
    variables.updatedBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
  }

  public void function postInsert() {
  }
 
  remote void function preUpdate(Struct oldData) {
    variables.updatedBy = StructKeyExists(Session, "User") ? Session.user.getPersonId() : Application.System.SystemUserId;
  }
  
  public void function postUpdate() {
    transaction {
      var studentExam = EntityLoad("student_exam", {studentExamId = this.getstudentExamId()}, True);
      studentExam.calculatePassOrFail();
      EntitySave(studentExam);
    }
  }

  public void function preDelete() {
    throw(message="preDelete");
  }

  public void function postDelete() {
    throw(message="postDelete");
  }
	
}
