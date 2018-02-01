component persistent="true" accessors="true" table="web_analytics" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database column default value.
   If a default property is set, ORM tries to update the record to the default. For string fields, this may violate
   violate a unique index or overwrite a database NULL.
*/
{
  property name="requestId" column="request_id" type="numeric" ormtype="int" fieldtype="id" generator="identity" notnull="true";
  property name="target" column="target_url" type="string" ormtype="string" notnull="true" length="300";
  property name="startTime" column="timestamp_begin" type="date" ormtype="java.sql.Timestamp" notnull="true" setter="false" update="false";
  property name="endTime" column="timestamp_end" type="date" ormtype="java.sql.Timestamp" notnull="true" setter="true" update="false";

  public void function preLoad() {
  }

  public void function postLoad() {
  }

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
