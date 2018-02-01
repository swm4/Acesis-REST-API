component extends="lib.remoteProxy"
{
  
  orm.email_message function getEmailMessage( numeric emailMessageId )  
  {
    var primaryKeysMap = { emailMessageId = arguments.emailMessageId };
    var message = entityLoad("email_message", primaryKeysMap, true);
    return message;
  }
  
}
