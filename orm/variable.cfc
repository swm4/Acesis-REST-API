component persistent="true" table="variable" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
	property name="variableId" column="variable_id" type="numeric" ormtype="int" fieldtype="id" generator="identity" ;
	property name="variableGroup" column="variable_group" type="string" ormtype="string" notnull="no"; 
	property name="name" column="name" type="string" ormtype="string" notnull="true"; 
	property name="value" column="value" type="string" ormtype="string" notnull="true"; 	
} 
