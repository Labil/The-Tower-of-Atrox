class SeqEvent_KillEnemy extends SequenceEvent;


event Activated()
{
	`Log("Activating a torch!");
	ToA_GameInfo(class'WorldInfo'.static.GetWorldInfo().Game).door1Opener.AddEnemyKilled();

}

DefaultProperties
{
	ObjName="Torch Lit"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")


	bPlayerOnly=false
	MaxTriggerCount=1
}
