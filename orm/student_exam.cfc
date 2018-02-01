component persistent="true" table="student_exam" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
	property name="studentExamId" column="student_exam_id" type="numeric" ormtype="int" fieldtype="id" generator="identity";
	property name="contextId" column="context_id" type="numeric" ormtype="int" insert="false" update="false";
	property name="certificationLevel" column="certification_level" type="string" ormtype="string" notnull="true";
	property name="skillStation" column="skill_station" type="string" ormtype="string" notnull="true";
	property name="timeLimit" column="time_limit" type="numeric" ormtype="int" notnull="false";
	property name="pointsNeededToPass" column="points_needed_to_pass" type="numeric" ormtype="int" notnull="true";
	property name="possibleScore" column="possible_score" type="numeric" ormtype="int" notnull="true";
  property name="examScore" column="exam_score" type="numeric" ormtype="int" notnull="false";
	property name="examScoreVerifiedOn" column="exam_score_verified_on" type="date" ormtype="java.sql.Time" notnull="false";
	property name="examScoreVerifiedBy" column="exam_score_verified_by" type="numeric" ormtype="int" notnull="false";
	property name="examiner" column="examiner" type="numeric" ormtype="int" notnull="false";
	property name="examSubmittedOn" column="exam_submitted_on" type="date" ormtype="java.sql.Time" notnull="false";
	property name="startTime" column="actual_start_time" type="date" ormtype="java.sql.Time" notnull="false";
	property name="endTime" column="actual_end_time" type="date" ormtype="java.sql.Time" notnull="false";
	property name="minutesTakenToComplete" column="minutes_taken_to_complete" type="numeric" ormtype="double" notnull="false";
  property name="createdOn" column="created_on" type="date" ormtype="timestamp" notnull="true" setter="false";
  property name="createdBy" column="created_by" type="numeric" ormtype="int" notnull="true" setter="false"; 
  property name="updatedOn" column="updated_on" type="date" ormtype="timestamp" notnull="true" setter="false";
  property name="updatedBy" column="updated_by" type="numeric" ormtype="int" notnull="true" setter="false";
  property name="leftToStationTime" column="left_to_station_time" type="date" ormtype="java.sql.Time" notnull="false";
  property name="backFromStationTime" column="back_from_station_time" type="date" ormtype="java.sql.Time" notnull="false";
  property name="examTemplateId" column="exam_template_id" type="numeric" ormtype="int" notnull="true";
  property name="totalPointsPossible" type="numeric" ormtype="int" persistent="false";
  property name="actualStartTimeAsHHMM" type="string" ormtype="string" persistent="false";
  property name="actualEndTimeAsHHMM" type="string" ormtype="string" persistent="false";
  property name="passOrFail" column="pass_fail" type="string" ormtype="string" notnull="false";

  property name="studentExamItems" fieldtype="one-to-many" cfc="orm.student_exam_item" fkcolumn="student_exam_id"
           type="array" cascade="refresh" lazy="false" fetch="select" inverse="true" remotingfetch="true" orderby="display_order";

  property name="context" fieldtype="many-to-one" cfc="orm.context" fkcolumn="context_id"
           type="array" cascade="refresh" lazy="false" fetch="select" inverse="true" remotingfetch="true";


  public void function setContextId(numeric contextId) {
  	var context = EntityLoad("context", {contextId = arguments.contextId}, True);
  	variables.context = context;
  }
  
  public string function getActualStartTimeAsHHMM() {
  	return TimeFormat(this.getStartTime(), "HH:nn");
  }
  
  public string function getActualEndTimeAsHHMM() {
    return TimeFormat(this.getEndTime(), "HH:nn");
  }

  public string function getTotalPointsPossible() {
  	var tmp = 0;
  	for (var i=1; i<=ArrayLen(studentExamItems);i++) {
  		if (studentExamItems[i].getItemType() != 'CRITICAL CRITERIA')
  		  tmp += studentExamItems[i].getPossibleScore();
  	}
    return tmp;
  }
  
  public void function calculatePassOrFail() {
    var criticalCriteria = EntityLoad("student_exam_item", {studentExamId = this.getStudentExamid(),
                                                            itemType = "CRITICAL CRITERIA",
                                                            score = 1}, False);
    if (ArrayLen(criticalCriteria) > 0)
      this.setPassOrFail("Fail");
  }

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
  }

  public void function preDelete() {
    for (var i=1; i<=ArrayLen(variables.studentExamItems); i++) {
      var item = variables.studentExamItems[i];
      EntityDelete(item);    	
    }
  }

  public void function postDelete() {
  }

}
