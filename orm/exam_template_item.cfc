component persistent="true" table="exam_template_item" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
  property name="examTemplateItemId" column="exam_template_item_id" type="numeric" ormtype="int" fieldtype="id" generator="identity";
  property name="examTemplateId" column="exam_template_id" type="numeric" ormtype="int" notnull="true";
  property name="itemDescription" column="item_description" type="string" ormtype="string" notnull="true" length="256";
  property name="possibleScore" column="possible_score" type="numeric" ormtype="int" notnull="true";
  property name="displayOrder" column="display_order" type="numeric" ormtype="int" notnull="true";
  property name="itemType" column="item_type" type="string" ormtype="string" length="64" notnull="false";
}
