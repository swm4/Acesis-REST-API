component persistent="true" table="bems_course" schema="ees" datasource="ees" 
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
	property name="bems_training_id" column="bems_training_id" type="string" ormtype="string" fieldtype="id"; 
	property name="courseName" column="course_name" type="string" ormtype="string"; 
	property name="courseNumber" column="course_number" type="string" ormtype="string"; 
	property name="courseType" column="course_type" type="string" ormtype="string"; 
	property name="levels" column="levels" type="string" ormtype="string"; 
	property name="description" column="description" type="string" ormtype="string"; 
	property name="courseFee" column="course_fee" type="numeric" ormtype="double"; 
	property name="location" column="location" type="string" ormtype="string"; 
	property name="city" column="actual_location_city" type="string" ormtype="string";
	property name="startDate" column="course_start_date" type="date" ormtype="date"; 
	property name="endDate" column="course_end_date" type="date" ormtype="date"; 
  property name="signupStartDate" column="signup_start_date" type="date" ormtype="date"; 
  property name="signupEndDate" column="signup_end_date" type="date" ormtype="date"; 
	property name="days_and_times_of_course" column="days_and_times_of_course" type="string" ormtype="string"; 
	property name="notes" column="notes" type="string" ormtype="string"; 
	property name="courseCoordinator" column="course_coordinator" type="string" ormtype="string"; 
	property name="course_coordinator_phone" column="course_coordinator_phone" type="string" ormtype="string"; 
	property name="courseCoordinatorEmail" column="course_coordinator_email" type="string" ormtype="string";
	property name="etlUpdatedOn" column="etl_updated_on" type="date" ormtype="timestamp"; 	
} 
