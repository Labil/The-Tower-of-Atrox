class ToA_Level1_StartingWeaponSpawnHolder extends ToA_ActorBase
	placeable;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(0.4f, false, 'SpawnStartingWeapon');

}

function SpawnStartingWeapon()
{
	`Log("About to call seqEvent_tspawn weapon!!");
	TriggerEventClass(class'SeqEvent_Level1_SpawnStartWeapon', self, 1);
}

DefaultProperties
{
	begin object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	end object
	Components.Add(Sprite)

	SupportedEvents.Add(class'SeqEvent_Level1_SpawnStartWeapon')
}
