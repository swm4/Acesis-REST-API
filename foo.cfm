<cfscript>

  foo = new apifolder.authenticate();
  foo.login("sam", "samspw");
  //writedump(Application.restcodes.status_401_UNAUTHORIZED);
</cfscript>
