component
{

	orm.web_analytics function createWebAnalytics(orm.web_analytics item)
	{
    transaction {
	  	entitySave(item);
    }
	  return item;
	}

  orm.web_analytics function updateAnalytics(orm.web_analytics item)
	{
    transaction 
    {
      entitySave(arguments.item);
    }
    return arguments.item;
	}

}