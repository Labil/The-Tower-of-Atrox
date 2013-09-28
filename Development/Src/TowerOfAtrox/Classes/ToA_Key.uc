class ToA_Key extends ToA_PickupItem
	placeable;

var ParticleSystemComponent sparkleParticles;
var AudioComponent sparkleSound;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	inventoryItem = Spawn(class'ToA_InventoryKey', self);
	sparkleParticles.ActivateSystem();
	sparkleSound.Play();
}

function InteractWithActor(ToA_Pawn hero)
{
	super.InteractWithActor(hero);
	sparkleParticles.DeactivateSystem();
	ToA_GameInfo(WorldInfo.Game).door3.UnlockDoor();
	// + Spill av en lyd?
}

DefaultProperties
{
	bCollideActors=true
	bBlockActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	Begin Object Class=ParticleSystemComponent Name=Particles
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=1.0f
		Template=ParticleSystem'erik_particle.Material.Key_Sparkle'
	End Object
	sparkleParticles=Particles
	Components.Add(Particles)

	begin object class=SkeletalMeshComponent Name=TorchMesh
		SkeletalMesh=SkeletalMesh'ToA_Assets.SkeletalMeshes.Key_SK'
		PhysicsAsset=PhysicsAsset'ToA_Assets.PhysicsAsset.Key_Physics'
		CastShadow=true
		bCastDynamicShadow=true
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	skelMesh=TorchMesh
	CollisionComponent=TorchMesh
	Components.Add(TorchMesh)

	begin object class=AudioComponent Name=AudioComp
		SoundCue=SoundCue'ToA_Lyder.WAV.Key_Sound2_Cue'
		bAutoPlay=false
	end object
	sparkleSound=AudioComp
	Components.Add(AudioComp)


	//selectedMaterial=Material'ToA_Hero.Materials.Torch_Selected_Material'
	//normalMaterial=Material'ToA_Hero.Materials.Torch_Material'

	distanceToUse=100.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Key_ToolTip'
	PopupLabelName="Key"

}
