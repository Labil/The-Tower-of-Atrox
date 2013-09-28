class SeqEvent_Tutorial_KillEnemy extends SequenceEvent;

event Activated()
{
	`Log("ACTIVATING KILLED ENEMY in Tutorial!");
	ToA_GameInfo(class'WorldInfo'.static.GetWorldInfo().Game).tutorialDoorOpener.AddEnemyKilled();

}

DefaultProperties
{
	ObjName="Killed Enemy Event"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")


	bPlayerOnly=false
	MaxTriggerCount=1
}
