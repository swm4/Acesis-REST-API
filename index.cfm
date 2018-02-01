<cfset Variables.PageSettings.PageTitle = "Utah EMS Course Services">

<cfoutput>
  <cfinclude template="/templates/html_head.cfm" />
    
    <body>
      <cfinclude template="/templates/navigation.cfm">
      <div class="container main-container">
        <div class="page-header" id="banner">
          <div class="row">
            <div class="col-lg-8 col-md-7 col-sm-6">
              <h1>
                What do you want to do?
              </h1>

  <div class="col-sm-12 col-md-4">
    <div class="thumbnail">
      <img src="..." alt="...">
      <div class="caption">
        <h3>Thumbnail label</h3>
        <p>See a list of upcoming exams</p>
        <a href="##" class="btn btn-primary" role="button">View upcoming exams</a>
      </div>
    </div>
  </div>


  <div class="col-sm-12 col-md-4">
    <div class="thumbnail">
      <img src="..." alt="...">
      <div class="caption">
        <h3>Thumbnail label</h3>
        <p>Register for an exam</p>
        <p><a href="/site-auth/loginform.cfm" class="btn btn-primary" role="button">Register for exam</a></p>
      </div>
    </div>
  </div>
  
  <div class="col-sm-12 col-md-4">
    <div class="thumbnail">
      <img src="..." alt="...">
      <div class="caption">
        <h3>Thumbnail label</h3>
        <p>View or change my registration</p>
        <p><a href="##" class="btn btn-primary" role="button">Manage my registration</a></p>
      </div>
    </div>
  </div>
  
  
            </div>
          </div>
        </div>
        
        
        <cfinclude template="/templates/footer.cfm">
      </div><!--- End of container div --->
      <cfinclude template="/templates/html_foot.cfm">
</cfoutput>