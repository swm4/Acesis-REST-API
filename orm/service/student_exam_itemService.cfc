component extends="lib.remoteProxy"
{
  remote any function updateStudentExamItemScore(numeric studentExamItemId, any score)
  {
  	//be sure to only allow this on exams where the score has not been verified yet
    //update the ORM object
    transaction {
      //Create a new API response object.
      var response = this.NewAPIResponse();
      var theItem = EntityLoad("student_exam_item", {studentExamItemId = arguments.studentExamItemId}, True);
      var theExam = EntityLoad("student_exam", {studentExamId = theItem.getStudentExamId()}, True);
      if (theExam.getExamScoreVerifiedBy() != "")
      {
        this.returnErrorResponse("You cannot modify a verified exam");
      }
      else if (arguments.score > theItem.getPossibleScore()) 
      {
      	this.returnErrorResponse(theItem.getPossibleScore());
      	this.returnErrorResponse("Submitted points cannot be higher than points possible");
      }
      else 
      {
        theItem.setScore(arguments.score != "" ? arguments.score : javacast("null", ""));
        response.data = this.updateStudentExamItem(theItem);
      }
    }
    return response;
  }

	/* Save student_exam_item */
	orm.student_exam_item function updateStudentExamItem(orm.student_exam_item item)
	{
    transaction {
      entitySave(item);
    }
		return item;
	}

}
