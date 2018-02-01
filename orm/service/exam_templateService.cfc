component extends="lib.remoteProxy"
{

  remote orm.exam_template[] function getAllExamTemplates(string SortColumn = "CERTIFICATIONLEVEL, SKILLSTATION, DISPLAYORDER", string CertificationLevel, boolean OnlyActiveTemplates = True)
  {
    return entityLoad("exam_template", {Active = Arguments.OnlyActiveTemplates, CertificationLevel = arguments.CertificationLevel}, arguments.sortcolumn);
  }

	orm.exam_template[] function getAllexam_template(string SortColumn = "CERTIFICATIONLEVEL, SKILLSTATION", boolean OnlyActiveTemplates = True)
	{
		return entityLoad("exam_template", {Active = Arguments.OnlyActiveTemplates}, arguments.sortcolumn);
	}

	orm.exam_template[] function getexam_template_paged(numeric startIndex,numeric numItems)
	{
		return entityLoad("exam_template",{},"",{offset=startIndex,maxresults=numItems});
	}

	remote orm.exam_template function getExamTemplate(numeric examTemplateId )
	{
		var primaryKeysMap = { examTemplateId = Arguments.examTemplateId };
		return entityLoad("exam_template",primaryKeysMap,true);
	}

}
