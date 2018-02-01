<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

Author 	    :	Luis Majano
Description :
	The logging configuration object for WireBox Standalone version.
	You can make changes here to determine how WireBox logs information.  For more
	information about logBox visit: http://wiki.coldbox.org/wiki/LogBox.cfm

----------------------------------------------------------------------->
<cfcomponent output="false" hint="A LogBox Configuration Data Object for standalone version of WireBox">
<cfscript>
	/**
	*  Configure logBox
	*/
	function configure(){
		logBox = {
			// Define Appenders
			appenders = {
        }
			},
      // Root Logger. Assign all appenders
      root = { levelmin="FATAL", levelmax="WARN", appenders="myEmail,MyDB" },

      categories = {
        "debugger" =  {levelmin="DEBUG", levelmax="DEBUG", appenders="debugFileLog,MyDB" },
        "info" =  {levelmin="INFO", levelmax="INFO", appenders="MyDB" },
        "error" =  {levelmin="ERROR", levelmax="ERROR", appenders="myEmail,MyDB" }
      }
		};
	}
</cfscript>
</cfcomponent>
