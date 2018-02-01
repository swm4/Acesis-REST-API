component extends="lib.remoteProxy"
{
	orm.bems_course function createbems_course(orm.bems_course item)
	{
		entitySave(item);

		return item;
	}

	void function deletebems_courses( bems_training_id	)
	{
		var primaryKeysMap = { bems_training_id = bems_training_id };
		var item = entityLoad("bems_course",primaryKeysMap,true);
		if(isNull(item) eq false)
			entityDelete(item);
		
		return;
	}

	orm.bems_course[] function getAllbems_courses()
	{
		return entityLoad("bems_course");
	}

	orm.bems_course function getbems_course( bems_training_id )
	{
		var primaryKeysMap = { bems_training_id = bems_training_id };
		var bemsCourse = entityLoad("bems_course", primaryKeysMap, true);
		return (IsNull(bemsCourse) == False) ? bemsCourse : EntityNew("bems_course");
	}

	public orm.bems_course function updatebems_course(orm.bems_course item)
	{
		transaction {
		  entitySave(arguments.item);
		}
		return item;
	}
} 