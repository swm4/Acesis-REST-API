component extends="lib.remoteProxy"
{

	remote orm.pay_period[] function getAllPayPeriods()
	{
		return entityLoad("pay_period");
	}

	orm.pay_period function getpay_period( pay_period_id )
	{		
		var primaryKeysMap = { payPeriodId = pay_period_id };
		return entityLoad("pay_period", primaryKeysMap, true);
	}

} 
