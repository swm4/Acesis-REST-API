component name="MyFileLayout" extends="logbox.system.logging.Layout"
{
	public string function format(logbox.system.logging.LogEvent logEvent)
  {
    var message = logEvent.getMessage();

    // Cleanup main message
    message = replace(message,'"','""',"all");
    message = replace(message,"#chr(13)##chr(10)#",'  ',"all");
    message = replace(message,chr(13),'  ',"all");
//    if( len(loge.getExtraInfoAsString()) ){
//      message = message & " " & loge.getExtraInfoAsString();
//    }
    
    // Entry string
    var entry = '"#severityToString(logEvent.getSeverity())#","#getname()#","#dateformat(timestamp,"MM/DD/YYYY")#","#timeformat(timestamp,"HH:MM:SS")#","#loge.getCategory()#","#message#", "#loge.getExtraInfoAsString()#"';
    return entry;
  }

}