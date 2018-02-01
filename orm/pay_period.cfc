component persistent="true" table="pay_period" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
	property name="payPeriodId" column="pay_period_id" type="numeric" ormtype="int" fieldtype="id"; 
	property name="payPeriod" column="pay_period" type="string" ormtype="string"; 
	property name="payFrequency" column="pay_frequency" type="string" ormtype="string"; 
	property name="payPeriodStart" column="pay_period_start" type="date" ormtype="date"; 
	property name="payPeriodEnd" column="pay_period_end" type="date" ormtype="date"; 	
} 
