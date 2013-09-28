class SeqEvent_SpawnBoss extends SequenceEvent;

event Activated()
{
	`Log("Boss should spawn now");
	ToA_GameInfo(class'WorldInfo'.static.GetWorldInfo().Game).bossSpawner.SpawnBoss();

}

DefaultProperties
{
	ObjName="Chest Opened Spawn Boss Event"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")


	bPlayerOnly=false
	MaxTriggerCount=1
}
