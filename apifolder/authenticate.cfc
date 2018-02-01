component restpath="/auth" produces="application/json"
{
  remote void function login(String username restargsource="form",
                             String password restargsource="form") httpmethod="POST" restPath="login/"
  {
    //Check that the required arguments are there
    try {
      if ((StructKeyExists(arguments, "username") == False) or
          (StructKeyExists(arguments, "password") == False) or
          (arguments.username == "") or
          (arguments.password == ""))
      {
        throw(message = "Username and password are required",
              detail = "",
              errorcode = application.RESTCodes.status_401_UNAUTHORIZED );
      }

      StructDelete(Session, "User"); //An extra layer of protection. This clears out the Session.User object to gain a fresh start
      //Verify the credentials are correct
      var personSvc = new orm.service.personService();
      var user = personSvc.getPersonByUsername(arguments.username, arguments.password);
      Session.User = user;
      payload = session.user;
      payload.exp = DateAdd("minute", 20, Now());
      payload.iat = Now(); //iat = issues at
      payload.type = "JWT";


      var jwt = new lib.jwt.lib.JsonWebTokens();
      var authtoken = jwt.encode(payload, "HS512", "mykey");

      //Here is the meat. Decode the token. Look at expiration time in the session object. This needs to be done on
      //some application-level event like OnnRequest, OnCfcRequest, or onRestRequest
//      msg.message = SerializeJSON(jwt.decode(authtoken, "HS512", "mykey"));


      var msg = {};
      msg.status = 204;
      msg.message = SerializeJSON(payson);

      var customResponse = structNew();
      customResponse.status = msg.status;
      customResponse.content = msg;
      customResponse.headers = structNew();
      customResponse.headers.authorization = authtoken;
//      customResponse.headers.location = "http://foo";
      restSetResponse(customresponse);
    }
    catch (any e) {
      var msg = {};
      msg.errorMessage = e.message;
      msg.detail = e.detail != "" ? e.detail : e.stacktrace;
      msg.status = e.errorcode != "" ? e.errorcode : Application.RESTCodes.status_400_BAD_REQUEST;

      var customResponse = structNew();
      customResponse.status = msg.status;
      customResponse.content = msg;
      restSetResponse(customresponse);
    }
  }

  remote void function sayHello(String thename restargsource="Path",
                                String yourage restargsource="Path") httpmethod="GET" restPath="parenthello/{thename}/{yourage}"
  {
    try {
      var msg = {};
      msg.body = "Parent Hello there " & arguments.thename & " " & arguments.yourage;
      msg.status = 200;

      var customResponse = structNew();
      customResponse.status = msg.status;
      customResponse.content = msg;
      customResponse.headers = structNew();
      customResponse.headers.location = "http://foo";
      throw(message = "random error message2",
            detail = "",
            errorcode = 400);
      restSetResponse(customresponse);
//    return SerializeJson(rest);
    }
    catch (any e) {
      var msg = {};
      msg.errorMessage = e.message;
      msg.detail = e.detail;
      msg.status = e.errorcode;

      var customResponse = structNew();
      customResponse.status = msg.status;
      customResponse.content = msg;
      restSetResponse(customresponse);
    }
  }
}


//restargsource
//path,query,matrix,form,cookie and header

//However, if you specify the produces attribute at both the component and function level, the produces attribute specified at the function level takes precedence.

//You must set the returntype attribute of the function to void when a custom response is returned using the function restSetResponse. The code snippet sets the status code, response body (content) and header information in a response object (struct) and sends it to the client using the restSetResponse function.
//You can use the cfthrow tag to specify the status code by providing a value to the errorcode attribute.You can include the exception detail, message, and type in the response body when returning the data to the client.

//200 OK
//204 No Content

//User own resource ID should be avoided. Use /me/orders instead of /user/654321/orders.

