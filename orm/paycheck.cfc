component persistent="true" table="paycheck" schema="ees" datasource="ees"
/* The default="" attribute only means that there is a blank value when calling getxxx(), even if the underlying variable hasn't been set
   very helpful to avoid lots of if statements when calling the implicit getter.
   IT DOES NOT affect a database default value. */
{
	property name="paycheckId" column="paycheck_id" type="numeric" ormtype="int" generator="identity";
  property name="personId" column="person_id" type="numeric" ormtype="int"; 
  property name="payPeriodId" column="pay_period_id" type="numeric" ormtype="int"; 
	property name="regularHours" column="regular_hours" type="numeric" ormtype="double"; 
	property name="regularHourlyRate" column="regular_hourly_rate" type="numeric" ormtype="double"; 
	property name="overtimeHours" column="overtime_hours" type="numeric" ormtype="double"; 
	property name="overtimeHourlyRate" column="overtime_hourly_rate" type="numeric" ormtype="double"; 
	property name="grossPay" column="gross_pay" type="numeric" ormtype="double"; 
	property name="filingStatus" column="filing_status" type="string" ormtype="string"; 
	property name="exemptions" column="exemptions" type="numeric" ormtype="byte"; 
	property name="federalIncomeTaxWithheld" column="federal_income_tax_wth" type="numeric" ormtype="double"; 
	property name="stateIncomeTaxWithheld" column="state_income_tax_wth" type="numeric" ormtype="double"; 
	property name="socialSecurityWithholding" column="empl_social_security_wth" type="numeric" ormtype="double"; 
	property name="medicareWithholding" column="empl_medicare_wth" type="numeric" ormtype="double"; 
	property name="federalUnemploymentAmt" column="federal_unemployment_amt" type="numeric" ormtype="double"; 
	property name="stateUnemploymentAmt" column="state_unemployment_amt" type="numeric" ormtype="double"; 
	property name="workerCompensationAmt" column="worker_compensation_amt" type="numeric" ormtype="double"; 
	property name="payrollApprovedOn" column="payroll_approved_on" type="date" ormtype="timestamp"; 
	property name="checkNumber" column="check_number" type="numeric" ormtype="int"; 
	property name="checkIssuedDate" column="check_issued_date" type="date" ormtype="date"; 	
} 
