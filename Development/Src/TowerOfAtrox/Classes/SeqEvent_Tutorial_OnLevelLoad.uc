class SeqEvent_Tutorial_OnLevelLoad extends SequenceEvent;

event Activated()
{
	`Log("ACTIVATING LevelLoadedPopup in Tutorial!");
	ToA_GameInfo(class'WorldInfo'.static.GetWorldInfo().Game).DisplayHudPopup("TutorialMove");

}

DefaultProperties
{
	ObjName="Level Load display Popup"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")


	bPlayerOnly=false
	MaxTriggerCount=1
}
