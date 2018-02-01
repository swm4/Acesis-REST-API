component output="true" extends="ApplicationProxy"
{
  this.restsettings    = {
    cfclocation        = ".",
    skipcfcwitherror   = false
  };

/* 1/6/2018: You absolutely cannot have a CF folder mapping called API. CF11 already has a mapping called api for a servlet,
             Don't believe me? Create an api folder and you will get HTTP 500 errors  https://forums.adobe.com/thread/1667380*/
  public boolean function OnRequestStart(required string TargetPage) {
    if (super.onRequestStart(TargetPage))
    {
      return true;
    }
    else return false;
  }

  //public boolean function OnRequestStart(required string TargetPage)
  //{
    //// This attempts to prevent calls to a CFC from pages other than on the server.
    //
    //if (UCase(Right(cgi.cf_TEMPLATE_PATH,3)) == '.cfc') {
    	//if (cgi.REMOTE_HOST == "127.0.0.1") //For development purposes, skip requests from 127.0.0.1
    	  //return True;
    	//else
      	//return (cgi.REMOTE_HOST != Application.Server.ServerIPAddress);
    //}
    //else if (FindNoCase("/app/register/registerFromWebsite.cfm", arguments.targetPage) > 0)
      //return True;
    //else if (IsUserLoggedIn() == False)
    //{
    	//Session.IntendedTargetPage = Arguments.TargetPage;
    	//location (URL = "/site-auth/loginForm.cfm", addtoken="no" );
    	//return False;
    //}
    //else
      //return True;
  //}

}
