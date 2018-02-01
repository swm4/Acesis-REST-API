component extends="lib.remoteProxy"
{
  
	orm.course function createCourse(orm.course item)
	{
		return this.updateCourse(arguments.item);
	}

  orm.course[] function getAllUpcomingPublicExams()
  {
    return ORMExecuteQuery("FROM course WHERE showToPublic = 1 AND startDate > Now() AND courseType = 'Psychomotor' AND courseLevel IN ('EMT', 'Advanced EMT')");
  }

  remote any function getUpcomingPublicExams() method="GET" {
    //Create a new API response object.
    var response = this.NewAPIResponse();
    response.data = this.getallUpcomingPublicExams();
    return response;    
  }

  remote any function getCourses() method="GET"
  {
    var response = this.NewAPIResponse();
    response.data = this.getAllCourses();
    return response;     	
  }


  orm.course[] function getAllCourses(string SortColumn = "STARTDATE DESC") method="GET"
	{
		return entityLoad("course", {}, arguments.sortcolumn);
	}

  /* Get course */
  remote any function getTheCourse( numeric courseId ) httpmethod="GET"  
  {
    var response = this.NewAPIResponse();
    response.data = this.getCourse(arguments.courseId);
    return response;      
  }

  orm.course function getCourse( courseId )  
  {
    if (IsNumeric(courseId)) 
    {
      var primaryKeysMap = { courseId = arguments.courseId };
      var course = entityLoad("course", primaryKeysMap, true);
      if (IsNull(course) == False)
      {
        return course;
      }  
      else 
        return new orm.course();
    } 
    else 
      return new orm.course();
  }
  
  remote void function deleteCourse(numeric courseId) httpMethod="DELETE"
  {
    var primaryKeysMap = { courseId = arguments.courseId };
    var item = entityLoad("course", primaryKeysMap, true);
    if (isNull(item) == false)
      entityDelete(item);

    return;  	
  }
  
  /* Save course */
  orm.course function updateCourse(orm.course item) 
  {
    transaction 
    {
      entitySave(arguments.item);
      entityReload(arguments.item);
    }   
    return arguments.item;
  }  

  /* Allows calling from AJAX or Angular, anything that needs to pass it via JSON */
  remote orm.course function updateCourseFromJSON(string item) httpmethod="POST"
  {
    var courseJSON = deserializeJSON(Arguments.item);
    
    if ((StructKeyExists(courseJSON, "courseId") == True) &&
        (courseJSON.courseId != ""))
      course = this.getCourse(courseJSON.courseId);
    else {
      course = EntityNew("course");
    }
    transaction {    
      course.setCourseIdent(courseJSON.courseIdent);
      course.setCourseLevel(courseJSON.courseLevel);
      course.setCourseType(courseJSON.courseType);
      course.setLocation(StructKeyExists(courseJSON, "location") ? courseJSON.location : javacast("null", ""));
      course.setAddress1(StructKeyExists(courseJSON, "address1") ? courseJSON.address1 : javacast("null", ""));
      course.setCity(StructKeyExists(courseJSON, "city") ? courseJSON.city : javacast("null", ""));
      course.setState(StructKeyExists(courseJSON, "state") ? courseJSON.state : javacast("null", ""));
      course.setZip(StructKeyExists(courseJSON, "zip") ? courseJSON.zip : javacast("null", ""));
      course.setAgency(StructKeyExists(courseJSON, "agency") ? courseJSON.agency : javacast("null", ""));

      if ((StructKeyExists(courseJSON, "startDate") == True) &&
          (courseJSON.startDate != "")) {
        course.setStartDate(ParseDateTime(courseJSON.startDate));
      }
      
      if ((StructKeyExists(courseJSON, "endDate") == True) &&
          (courseJSON.endDate != "")) {
        course.setEndDate(ParseDateTime(courseJSON.endDate));
      }
        
      if ((StructKeyExists(courseJSON, "startTimeAsJson") == True) &&
          (courseJSON.startTimeAsJson != ""))
      {
        var parsedStartTime = ParseDateTime(courseJSON.startTimeAsJson); 
        var startTime = CreateTime(DatePart("h", parsedStartTime), DatePart("n", parsedStartTime), 0);
        course.setStartTime(startTime);
      }
      if ((StructKeyExists(courseJSON, "endTime") == True) &&
          (courseJSON.endTime != ""))
      {
        var parsedEndTime = ParseDateTime(courseJSON.endTime); 
        var endTime = CreateTime(DatePart("h", parsedEndTime), DatePart("n", parsedEndTime), 0);
        course.setEndTime(endTime);
      }
      course.setShowToPublic(StructKeyExists(courseJSON, "showToPublic") == True);
    }    
    return this.updateCourse(course);
  }

}
