component extends="lib.remoteProxy"
{
	
	variable function createVariable(variable item)
	{
		entitySave(item);

		return item;
	}

	variable[] function getAllVariable()
	{
		return entityLoad("variable");
	}

	variable function getVariable( numeric variableId )
	{
		var primaryKeysMap = { variableId = arguments.variableId};
		return entityLoad("variable", primaryKeysMap, true);
	}

	variable function updateVariable(variable item)
	{
		entitySave(item);
		return item;
	}

} 
