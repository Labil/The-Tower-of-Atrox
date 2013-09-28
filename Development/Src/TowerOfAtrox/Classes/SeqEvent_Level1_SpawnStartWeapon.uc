class SeqEvent_Level1_SpawnStartWeapon extends SequenceEvent;

event Activated()
{
	local ToA_Pawn p;
	p = ToA_Pawn(ToA_GameInfo(class'WorldInfo'.static.GetWorldInfo().Game).controllerWorld.Pawn);
	if(p.mainhand == none)
	{
		p.pawnInventory.SpawnStartingInventory('ToA_InventorySword');
		p.AttachInventory('ToA_InventorySword');
	}

}

DefaultProperties
{
	ObjName="Spawn Starting Weapon"

	OutputLinks[0]=(LinkDesc="Deactivated")
	OutputLinks[1]=(LinkDesc="Activated")


	bPlayerOnly=false
	MaxTriggerCount=1
}
