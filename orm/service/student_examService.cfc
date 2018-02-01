component extends="lib.remoteProxy"
{
  //This one builds a full EMT or AEMT exam for an entire course
  remote void function createFullExamForCourse(numeric courseId, numeric randomSkillExamTemplateId)
  {
    transaction { //Look for all contexts, create exams for them
      var contexts = EntityLoad("context", {courseId = arguments.courseId, contextType = 'Candidate'}, False);
      for (var i=1; i<=ArrayLen(contexts); i++) {
        this.createFullExamFromTemplate(contexts[i].getContextId(), arguments.randomSkillExamTemplateId);
      }
    }
  }
  
  //This one builds a full EMT or AEMT exam for an entire course
  remote void function foo(numeric courseId, numeric randomSkillExamTemplateId)
  {
    transaction { //Look for all contexts, create exams for them
      var contexts = EntityLoad("context", {courseId = arguments.courseId, contextType = 'Candidate'}, False);
      for (var i=1; i<=ArrayLen(contexts); i++) {
      	this.createStudentExamFromTemplate(22, contexts[i].getContextId());
      }
    }
  }


	//This one builds a full EMT or AEMT exam for a student
	remote void function createFullExamFromTemplate(numeric contextId, numeric randomSkillExamTemplateId)
	{
    transaction {
      var context = EntityLoad("context", {contextId = arguments.contextId}, True);
      var certificationLevel = context.getCourse().getCourseLevel();
      var examTemplates = EntityLoad("exam_template", {certificationLevel = context.getCourse().getCourseLevel(),
                                                       active = 1 }, False);
      for (var i=1; i<=ArrayLen(examTemplates); i++) {
        if ((examTemplates[i].getRandomGroup() == False) or
            ( (examTemplates[i].getRandomGroup() == True) and (examTemplates[i].getExamTemplateId() == arguments.randomSkillExamTemplateId)))
          this.createStudentExamFromTemplate(examTemplates[i].getExamTemplateId(), arguments.contextId);
      }
  	}
	}
	
	remote orm.student_exam function updateExam(string item) {
	    var theExamJSON = deserializeJSON(arguments.item);
      if ((StructKeyExists(theExamJSON, "studentExamId") == True) &&
          (theExamJSON.studentExamId != ""))
        theExam = this.getStudentExam(theExamJSON.studentExamId);
      else {
        theExam = EntityNew("student_exam");
      }
    transaction {
      theExam.setExaminer(theExamJSON.examiner);
    }
    return this.updateStudentExam(theExam);
	}

  orm.student_exam function createStudentExamFromTemplate(numeric examTemplateId, numeric contextId)
	{
		transaction {
			var svc = new orm.service.exam_templateService();
			var examTemplate = svc.getExamTemplate(arguments.examTemplateId);
  		var stdExam = EntityNew("student_exam");
	  	stdExam.setContextId(arguments.contextId);
	  	stdExam.setCertificationLevel(examTemplate.getCertificationLevel());
	  	stdExam.setSkillStation(examTemplate.getSkillStation());
	  	stdExam.setTimeLimit(examTemplate.getTimeLimit());
	  	stdExam.setPointsNeededToPass(examTemplate.getPointsNeededToPass());
	  	stdExam.setPossibleScore(examTemplate.getPossibleScore());
	  	stdExam.setExamTemplateId(examTemplate.getExamTemplateId());
	  	stdExam = this.createStudentExam(stdExam);
	  	
	  	for (var i=1; i<=ArrayLen(examTemplate.getExamTemplateItems()); i++){
	  		var stdExamItem = EntityNew("student_exam_item");
	  		stdExamItem.setStudentExamId(stdExam.getStudentExamId());
	  		stdExamItem.setItemDescription(examTemplate.getExamTemplateItems()[i].getItemDescription());
	  		stdExamItem.setPossibleScore(examTemplate.getExamTemplateItems()[i].getPossibleScore());
	  		stdExamItem.setDisplayOrder(examTemplate.getExamTemplateItems()[i].getDisplayOrder());
	  		stdExamItem.setItemType(examtemplate.getExamTemplateItems()[i].getItemType());
	  		EntitySave(stdExamItem);
	    }
		}
		return stdExam;
	}
	
	orm.student_exam function createStudentExam(orm.student_exam item)
	{
    transaction {
		  entitySave(item);
    }
		return item;
	}

	void function deleteStudentExam( numeric studentExamId	)
	{
    transaction {
  		var primaryKeysMap = { studentExamId = arguments.studentExamId };
  		var item = entityLoad("student_exam", primaryKeysMap, true);
  		if (isNull(item) == false)
  			entityDelete(item);
    }
		return;
	}

  remote any function getTheStudentExam(numeric studentExamId) {
    //Create a new API response object.
    var response = this.NewAPIResponse();
    response.data = this.getStudentExam(arguments.studentExamId);
    return response;    

  }

	orm.student_exam function getStudentExam( numeric studentExamId )
	{
		var primaryKeysMap = { studentExamId = arguments.studentExamId };
		return entityLoad("student_exam", primaryKeysMap, true);
	}

	orm.student_exam function updateStudentExam(orm.student_exam item)
	{
		transaction {
      entitySave(arguments.item);
      entityReload(arguments.item);
  	}
		return item;
	}

}
