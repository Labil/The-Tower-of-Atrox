class ToA_Book extends ToA_InteractableItem
	placeable;

//statType er enten 'Strength' eller 'Health' og statIncreaseNum er et passende tall boka skal buffe deg med
var() string statType;
var() int statIncreaseNum;

var() ParticleSystemComponent sparkleParticles;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	sparkleParticles.ActivateSystem();
}

function InteractWithActor(ToA_Pawn hero)
{
	super.InteractWithActor(hero);

	hero.AddStatPoint(statType, statIncreaseNum);
	if(statType == "Strength")
		ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.ShowPopupDisplay("Strength");
	else if(statType == "Health")
		ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.ShowPopupDisplay("HP");
	sparkleParticles.DeactivateSystem();
}

DefaultProperties
{
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

	begin object Class=SkeletalMeshComponent Name=SkelMesh
		SkeletalMesh=SkeletalMesh'ToA_Assets.SkeletalMeshes.Book_SK'
		AnimSets(0)=AnimSet'ToA_Assets.AnimSets.Book_AnimSet'
		AnimTreeTemplate=AnimTree'ToA_Assets.AnimTrees.Book_AnimTree'
		PhysicsAsset=PhysicsAsset'ToA_Assets.PhysicsAsset.Book_Physics'
		Materials(0)=Material'ToA_Assets.Materials.Book_Material'
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	skelMesh=SkelMesh
	CollisionComponent=SkelMesh
	Components.Add(SkelMesh)

	normalMaterial=Material'ToA_Assets.Materials.Book_Material'
	selectedMaterial=Material'ToA_Assets.Materials.Book_Selected_Material'

	distanceToUse=100.0f

	statType="Health"
	statIncreaseNum=10

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Book_ToolTip'
}
