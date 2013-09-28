class ToA_Tutorial_LevelLoadedEventHolder extends ToA_ActorBase
	placeable;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(1.0f, false, 'DisplayPopupOnHud');

}

function DisplayPopupOnHud()
{
	`Log("About to call seqEvent_tutorial_levelloaded!");
	TriggerEventClass(class'SeqEvent_Tutorial_OnLevelLoad', self, 1);
}

DefaultProperties
{
	begin object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	end object
	Components.Add(Sprite)

	SupportedEvents.Add(class'SeqEvent_Tutorial_OnLevelLoad')
}
