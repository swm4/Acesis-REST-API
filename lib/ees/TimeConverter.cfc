component {
	  
  public Date function convertUTCToLocal(any utcDateTime) {
    var tzObj = createObject("java","java.util.TimeZone");   
    var timezone = tzObj.getTimeZone("US/Mountain");
    var tYear = javacast("int", Year(arguments.utcDateTime));
    var tMonth = javacast("int", Month(arguments.utcDateTime)-1); //java months are 0 based
    var tDay = javacast("int", Day(arguments.utcDateTime));
    var tDOW = javacast("int", DayOfWeek(arguments.utcDateTime)); //day of week
    var thisOffset = timezone.getOffset(1, tYear, tMonth, tDay, tDOW, 0)/1000;
    return dateAdd("s", thisOffset, arguments.utcDateTime);        
  }

}