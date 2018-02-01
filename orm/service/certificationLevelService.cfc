component extends="lib.remoteProxy"
{
	
	remote any function getCertificationLevels()
	{
    Levels = ArrayNew(1);
 
    Level = new Orm.certificationLevel();
    Level.certificationName = "EMT"; 
    Levels[1] = Level;
    
    Level = new Orm.certificationLevel();
    Level.certificationName = "ADVANCED EMT"; 
    Levels[2] = Level;

    Level = new Orm.certificationLevel();
    Level.certificationName = "PARAMEDIC"; 
    Levels[3] = Level;

    SerializeJSON(Levels);
    return Levels;		
	}


}
