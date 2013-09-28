class SeqEvent_ActivateOpenDoor extends SequenceEvent;

event Activated()
{
}

DefaultProperties
{
	ObjName="Open Door Event"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")

	bPlayerOnly=false
	MaxTriggerCount=1
}
