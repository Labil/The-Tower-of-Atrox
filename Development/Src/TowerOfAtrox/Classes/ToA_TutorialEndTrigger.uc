class ToA_TutorialEndTrigger extends DynamicTriggerVolume
	placeable;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	
	if(ToA_Pawn(Other) != none)
	{
		ToA_GameInfo(WorldInfo.Game).ShowMainMenu();
	}
}

DefaultProperties
{
}
