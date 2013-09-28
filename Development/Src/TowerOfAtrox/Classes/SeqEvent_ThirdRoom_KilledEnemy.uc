class SeqEvent_ThirdRoom_KilledEnemy extends SequenceEvent;

event Activated()
{
	`Log("Killed an enemy!");
	ToA_GameInfo(class'WorldInfo'.static.GetWorldInfo().Game).magicBlockingCube.AddEnemyKilled();

}

DefaultProperties
{
	ObjName="Enemy killed room 3"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")


	bPlayerOnly=false
	MaxTriggerCount=1
}
