component extends="lib.remoteProxy"
{
  private String function getDefaultCourseType()
  {
    return "Psychomotor";
  }
  
  orm.exam[] function getAllUpcomingPublicExams()
  {
    return ORMExecuteQuery("FROM exam WHERE showToPublic = 1 AND examDate > Now() AND courseType = 'Psychomotor'");
  }

  remote any function getUpcomingPublicExams() method="GET" {
    //Create a new API response object.
    var response = this.NewAPIResponse();
    response.data = this.getallUpcomingPublicExams();
    return response;    
  }

  remote any function getExams() method="GET"
  {
    var response = this.NewAPIResponse();
    response.data = this.getAllExams();
    return response;
    //return this.getAllExams();
  }


  orm.exam[] function getAllExams(string SortColumn = "EXAMDATE DESC")
	{
//		writedump(entityLoad("exam", {}, arguments.sortcolumn));
//		abort;
		return entityLoad("exam", {}, arguments.sortcolumn);
	}

  /* Get exam */
  remote any function getTheExam( numeric examId ) httpmethod="GET"  
  {
    var response = this.NewAPIResponse();
    response.data = this.getExam(arguments.examId);
    return response;      
  }

  orm.exam function getExam( examId )  
  {
    if (IsNumeric(arguments.examId)) 
    {
      var primaryKeysMap = { examId = arguments.examId };
      var exam = entityLoad("exam", primaryKeysMap, true);
      if (IsNull(exam) == False)
      {
        if (exam.getExamType() != getDefaultCourseType())
          throw(arguments.examId + " is not an exam record");
        return exam;
      }  
      else 
        return new orm.exam();
    } 
    else 
      return new orm.exam();
  }
  
 
  /* Save exam record */
  orm.exam function updateExam(orm.exam item) 
  {
    transaction 
    {
      entitySave(arguments.item);
      entityReload(arguments.item);
    }   
    return arguments.item;
  }  

  /* Allows calling from AJAX or Angular, anything that needs to pass it via JSON */
  remote orm.exam function updateExamFromJSON(string item) httpmethod="POST"
  {
    var examJSON = deserializeJSON(Arguments.item);
    
    if ((StructKeyExists(examJSON, "examId") == True) &&
        (examJSON.examId != ""))
    {
      exam = this.getExam(examJSON.examId);
      if (exam.getExamType() != getDefaultCourseType())
        throw(exam.getExamId() + ' is not an exam record');
    }
    else {
      exam = EntityNew("exam");
    }
    transaction {    
      exam.setExamIdent(examJSON.examIdent);
      exam.setExamLevel(examJSON.examLevel);
      exam.setExamType(getDefaultCourseType());
      exam.setLocation(StructKeyExists(examJSON, "location") ? examJSON.location : javacast("null", ""));
      exam.setAddress1(StructKeyExists(examJSON, "address1") ? examJSON.address1 : javacast("null", ""));
      exam.setCity(StructKeyExists(examJSON, "city") ? examJSON.city : javacast("null", ""));
      exam.setState(StructKeyExists(examJSON, "state") ? examJSON.state : javacast("null", ""));
      exam.setZip(StructKeyExists(examJSON, "zip") ? examJSON.zip : javacast("null", ""));
      exam.setAgency(StructKeyExists(examJSON, "agency") ? examJSON.agency : javacast("null", ""));
      exam.setCapacity(StructKeyExists(examJSON, "capacity") ? examJSON.capacity : javacast("null", ""));
      exam.setStateCourseNumber(StructKeyExists(examJSON, "stateCourseNumber") ? examJSON.stateCourseNumber : javacast("null", ""));

      if ((StructKeyExists(examJSON, "startDate") == True) &&
          (examJSON.startDate != "")) {
        exam.setExamDate(ParseDateTime(examJSON.startDate));
      }
      
      if ((StructKeyExists(examJSON, "endDate") == True) &&
          (examJSON.endDate != "")) {
        exam.setEndDate(ParseDateTime(examJSON.endDate));
      }
        
      if ((StructKeyExists(examJSON, "startTimeAsJson") == True) &&
          (examJSON.startTimeAsJson != ""))
      {
        var parsedStartTime = ParseDateTime(examJSON.startTimeAsJson); 
        var startTime = CreateTime(DatePart("h", parsedStartTime), DatePart("n", parsedStartTime), 0);
        exam.setStartTime(startTime);
      }
      if ((StructKeyExists(examJSON, "endTime") == True) &&
          (examJSON.endTime != ""))
      {
        var parsedEndTime = ParseDateTime(examJSON.endTime); 
        var endTime = CreateTime(DatePart("h", parsedEndTime), DatePart("n", parsedEndTime), 0);
        exam.setEndTime(endTime);
      }
      exam.setShowToPublic(StructKeyExists(examJSON, "showToPublic") == True);
    }    
    return this.updateExam(exam);
  }

}