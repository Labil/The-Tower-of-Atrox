class ToA_TutorialTrigger extends DynamicTriggerVolume
	placeable;

var bool bUsedTrigger;
var() string tutorialLabelName;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	if(!bUsedTrigger)
	{
		if(ToA_Pawn(Other) != none)
		{
			ToA_GameInfo(WorldInfo.Game).DisplayHudPopup(tutorialLabelName);
			//SetTimer(0.1f, false, 'ShowTipPopup');
		}
	}
}

simulated event UnTouch(Actor Other)
{
	if(ToA_Pawn(Other) != none)
	{
		ToA_GameInfo(WorldInfo.Game).HideHudPopup();
		//SetTimer(1.0f, false, 'CloseTipPopup');
		bUsedTrigger = true;
	}
}

DefaultProperties
{
}
