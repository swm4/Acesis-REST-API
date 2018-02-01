component output="true"
{
  ShowDebug = (Find(".localhost", CGI.SERVER_NAME) > 0);
  ShowDebug=True;

  /*Set up the application. */
  /* this.Name cannot have spaces or non letter/number characters. Otherwise cflogin and cflogout break.
     See http://www.bennadel.com/blog/1534-note-about-cflogin-application-name-and-applicationtoken.htm */
  this.Name = "AcesisREST";

  this.clientManagement = False;
  this.loginStorage = "Session";
  this.sessionTimeout = CreateTimeSpan(0, 0, 20, 0); //Session times out after 20 minutes of inactivity
  this.sessionManagement = True;
  this.requestTimeout = 20;
  this.showDebug = ShowDebug;
  this.setClientCookies = False;
  this.dataSource = "ees";
  this.mappings["/coldbox"] = getDirectoryFromPath(getCurrentTemplatePath()) & "lib\coldbox\";
  this.mappings["/logbox"] = getDirectoryFromPath(getCurrentTemplatePath()) & "lib\coldbox\";

  /* ORM settings */
  this.ormenabled = true;
  this.ormSettings      = {
      cfclocation       = expandPath("/orm"),
      dbcreate          = "none",  //Tells the ORM system to not create any tables that do not exist or to update any existing tables with new columns or properties.
      namingstrategy    = "default",
      dialect           = "MySQLwithInnoDB",
      autorebuild       = true,
      logSQL            = showDebug==True ? "true" : "false",
      flushAtRequestEnd = true,
      autoManageSession = false,
      showDebug         = showDebug==True ? "true" : "false",
      eventHandling     = true //Turn on event handling. Allows use of xLoad(), xInsert(), xUpdate(), xDelete()
  };

  public boolean function OnApplicationStart(){
  	Application.datasource = this.dataSource;
    Application.EmailAppenderAddress = "sam.mcknight@byu.edu";
    Application.webAnalyticsSvc = new orm.service.web_AnalyticsService();

    Application.Server.ServerIPAddress = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostAddress();
    Application.System.SystemUserId = 0; //This is so that records can have created_by and updated_by values that meet the FK restraints.

    Application.RESTCodes = new lib.RESTStatusCodes();

    setUpLogBox();
    setupTimeConverter();
    /* 1/6/2018: The RestInitApplication function must be called from the root Application.cfc. It must map to /
                 so that REST services in ColdBox (which aren't under /api2) can be called too by the system. */
    /* 1/7/2018: Service mapping is an alternate string to be used for application
       name while calling REST service.
       The first parameter is an absolute path to the base folder that contains
       the REST cfc files.
       Example: http://localhost/rest/{service mapping}/test (Optional)
    */
    RestInitApplication( GetDirectoryFromPath(getBaseTemplatePath()) & "apifolder\", "api");
    return true;
  }

  public void function OnApplicationEnd(struct ApplicationScope = structNew()){
  }

  public void function OnSessionStart(){
    Application.EmailAppenderAddress = "sam.mcknight@byu.edu";
    Application.debugLogger.debug("Session started");
    /* Makes the cookies browser session dependent so the session is killed when the browser is closed */
    if (StructKeyExists(Session, "CFID") == True)
    {
      myCookie = structNew();
      myCookie.value = Session.CFID;
      cookie.cfid = myCookie;
    }

    if (StructKeyExists(Session, "CFToken") == True)
    {
      myCookie = structNew();
      myCookie.value = Session.CFToken;
      cookie.cftoken = myCookie;
    }
  }

  public void function OnSessionEnd(required struct SessionScope, struct ApplicationScope=structNew())
  {
    StructClear(Arguments.sessionScope);
  }

  public void function onCfcRequest(string cfcname, string method, string args)
  {
  }

  public boolean function OnRequestStart(required string TargetPage)
  {
    Application.RESTCodes = new lib.RESTStatusCodes();
    Application.datasource = this.dataSource;
    Application.log.info(message = "Request",
                         extraInfo = Arguments.targetpage);

    requestWebAnalytics = new orm.web_analytics();
    requestWebAnalytics.setTarget(Arguments.TargetPage);
    requestWebAnalytics = Application.webAnalyticsSvc.createWebAnalytics(requestWebAnalytics);
    request.requestWebAnalytics = requestWebAnalytics;

    //if (directoryExists( GetDirectoryFromPath(getBaseTemplatePath()) & "apifolder\" ))
      //RestInitApplication( GetDirectoryFromPath(getBaseTemplatePath()) & "apifolder\", "api");

    if(structKeyExists(url,'reload')){
    	ormFlush();
      ormReload();
      reloadVariables();
      setUpLogBox();
      setupTimeConverter();
    }


    // This attempts to prevent calls to a CFC from pages other than on the server.
    if (UCase(Right(cgi.cf_TEMPLATE_PATH,3)) == '.cfc') {
    	if (cgi.REMOTE_HOST == "127.0.0.1") //For development purposes, skip requests from 127.0.0.1
    	  return True;
    	else
      	return (cgi.REMOTE_HOST != Application.Server.ServerIPAddress);
    }
    else
      return True;
  }

  public void function OnRequestEnd(){
  	//Prevent Clickjack attacks
  	GetPageContext().getResponse().addHeader("X-Frame-Options", "SAMEORIGIN");

    request.requestWebAnalytics.setEndTime(Now());
    Application.webAnalyticsSvc.updateAnalytics(request.requestWebAnalytics);
  }

  public void function OnError(required any Exception, required string EventName){
//    if (REFindNoCase( "\.cdc$", CGI.script_name ))
//      CreateObject( "component", "lib.RemoteProxy" ).ReturnErrorResponse( arguments.Exception.Message );
    Application.datasource = this.dataSource;

    if (StructKeyExists(Application, "debugLogger") == False)
    {
      setUpLogBox();
    }
    Application.log.error(message = Arguments.EventName,
                          extraInfo = SerializeJSON(Arguments.Exception));

    writedump(Arguments.Exception);
  }

  public boolean function OnMissingTemplate(required string TargetPage)
  {
//  	if (StructKeyExists(Application, "log") == False)
  //	{
  	  setUpLogBox();
  	//}
    Application.log.error(message = "Missing template " & Arguments.TargetPage,
                          extraInfo = Arguments.TargetPage);
    return False;
  }

  public void function reloadVariables()
  {
    var item = ORMExecuteQuery("FROM variable WHERE name = :thename", {thename = "Bootstrap CDN"}, True, {datasource="ees"});
    Application.CDNUrl.Bootstrap = item.getValue();

    var item = ORMExecuteQuery("FROM variable WHERE name = :thename", {thename = "AngularJS CDN"}, True, {datasource="ees"});
    Application.CDNUrl.AngularJs= item.getValue();

    var item = ORMExecuteQuery("FROM variable WHERE name = :thename", {thename = "AngularUI CDN"}, True, {datasource="ees"});
    Application.CDNUrl.AngularUI= item.getValue();

    var item = ORMExecuteQuery("FROM variable WHERE name = :thename", {thename = "JQuery CDN"}, True, {datasource="ees"});
    Application.CDNUrl.Jquery = item.getValue();

    var item = ORMExecuteQuery("FROM variable WHERE name = :thename", {thename = "Visual Theme CDN"}, True, {datasource="ees"});
    Application.CDNUrl.VisualTheme = item.getValue();

    var item = ORMExecuteQuery("FROM variable WHERE name = :thename", {thename = "Font Awesome CDN"}, True, {datasource="ees"});
    Application.CDNUrl.FontAwesome = item.getValue();

    Application.EmailAppenderAddress = "sam.mcknight@byu.edu";
  }

  private void function setUpLogBox()
  {
    props = { filePath = "/logs", fileName = "Test2", layout="coldbox.system.logging.MyFileLayout" };
    logBoxConfig = new logbox.system.logging.config.LogBoxConfig();
    logBoxConfig.appender (
      name = 'FileAppender',
      class = "coldbox.system.logging.appenders.FileAppender",
      properties = props
            );

    logBoxConfig.appender (
      name = 'DBAppender',
      class = "logbox.system.logging.appenders.DBAppender",
      properties = {
        dsn = Application.dataSource,
        table = "logger",
        schema = "ees",
        autocreate = True,
        ensureChecks = true
      }
            );

    //logBoxConfig.appender (
      //name = "emailAppender",
      //class = 'logbox.system.logging.appenders.EmailAppender',
      //properties = {
        //from = Application.EmailAppenderAddress,
        //to = Application.EmailAppenderAddress,
        //subject = "error"
      //}
            //);

    logBoxConfig.categories = {
      "debugger" =  {levelmin="DEBUG", levelmax="DEBUG", appenders="FileAppender, DBAppender" },
      "info" =  {levelmin="INFO", levelmax="INFO", appenders = "DBAppender" },
      "error" =  {levelmin="ERROR", levelmax="ERROR", appenders = "EmailAppender, DBAppender" }
    };

    Application.logBox = new logbox.system.logging.LogBox( logBoxConfig );
    Application.log = Application.logBox.getRootLogger();

    Application.debugLogger = Application.LogBox.getLogger("debugger");
    Application.debugLogger.setCategory("debug");
    Application.debugLogger.setLevelMin(Application.LogBox.LogLevels.DEBUG);
    Application.debugLogger.setLevelMax(Application.LogBox.LogLevels.DEBUG);
    Application.debugLogger.debug("debugLogger logBox object created");
  }

  private void function setupTimeConverter() {
    Application.TimeConverter = new lib.ees.timeConverter();
  }
}
