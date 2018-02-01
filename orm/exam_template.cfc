component persistent="true" table="exam_template" schema="ees" datasource="ees"
{
	property name="examTemplateId" column="exam_template_id" type="numeric" ormtype="int" fieldtype="id" generator="identity";
	property name="certificationLevel" column="certification_level" type="string" ormtype="string" length="16" notnull="true";
	property name="skillStation" column="skill_station" type="string" ormtype="string" length="128" notnull="true";
	property name="timeLimit" column="time_limit" type="numeric" ormtype="int" notnull="false";
	property name="active" column="active" type="numeric" ormtype="byte" notnull="true" dbdefault="1";
	property name="pointsNeededToPass" column="points_needed_to_pass" type="numeric" ormtype="int" notnull="true";
	property name="possibleScore" column="possible_score" type="numeric" ormtype="int" notnull="true";
	property name="randomGroup" column="random_group" type="numeric" ormtype="int" notnull="true";
	property name="skillSheetURL" column="skill_sheet_url" type="string" ormtype="string" length="255" notnull="false";

  property name="examTemplateItems" fieldtype="one-to-many" cfc="orm.exam_template_item" fkcolumn="exam_template_id"
           type="array" cascade="refresh" lazy="false" fetch="select" inverse="true" remotingfetch="true" orderby="display_order";

  /* These events will only occur inside an ORM transaction. Outside a transaction, they aren't called until the session is flushed. */
  public void function preInsert() {
  }

  public void function postInsert() {
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
