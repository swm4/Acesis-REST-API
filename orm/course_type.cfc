component persistent="true" table="course_type"  output="false"
{
	/* properties */
	
	property name="courseTypeId" column="course_type_id" type="numeric" ormtype="int" fieldtype="id"; 
	property name="courseType" column="course_type" type="string" ormtype="string" notnull="true" ; 
	property name="course_type_description" column="course_type_description" type="string" ormtype="string" notnull="true" ; 
	property name="effectiveDate" column="effective_date" type="date" ormtype="date" notnull="true" ; 
	property name="expirationDate" column="expiration_date" type="date" ormtype="date" notnull="true";
} 
