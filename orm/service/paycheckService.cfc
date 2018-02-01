component extends="lib.remoteProxy"
{
	orm.paycheck function createpaycheck(orm.paycheck item)
	{
		entitySave(item);

		return item;
	}


	paycheck[] function getAllpaycheck()
	{
		return entityLoad("paycheck");
	}

	remote orm.paycheck function getpaycheck( numeric personId, numeric payPeriodId )
	{
		var primaryKeysMap = { personId = arguments.personId , payPeriodId = arguments.payPeriodId };
		return entityLoad("paycheck", primaryKeysMap, true);
	}

	orm.paycheck function updatepaycheck(orm.paycheck item)
	{
		entitySave(arguments.item);
		return item;
	}

} 
