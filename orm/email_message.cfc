component persistent="true" table="email_message" schema="ees" datasource="ees"
{
  property name="emailMessageId" column="email_message_id" type="numeric" ormtype="double" fieldtype="id"; 
  property name="subject" column="subject" type="string" ormtype="string" notnull="true"; 
  property name="message" column="message" type="string" ormtype="string" notnull="true"; 
  property name="description" column="description" type="string" ormtype="string" notnull="true"; 
  property name="recipients" column="recipients" type="string" ormtype="string";
  property name="fromAddress" column="from_email" type="string" ormtype="string" notnull="true";
  property name="contentType" column="content_type" type="string" ormtype="string" notnull="true";
  property name="importance" column="importance" type="string" ormtype="string" notnull="true";
} 
