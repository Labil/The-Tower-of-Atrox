class ToA_Level1_ThirdRoom_MagicBlockingCube extends ToA_InteractableItem
	placeable;

var int numEnemiesKilled;
var() int requiredNumberOfEnemiesKilled;

var() ParticleSystemComponent sparkleParticles1;
var() ParticleSystemComponent sparkleParticles2;
var() ParticleSystemComponent sparkleParticles3;
var() ParticleSystemComponent sparkleParticles4;

function PostBeginPlay()
{
	super.PostBeginPlay();
    ToA_GameInfo(WorldInfo.Game).magicBlockingCube = self;

	sparkleParticles1.ActivateSystem();
	sparkleParticles2.ActivateSystem();
	sparkleParticles3.ActivateSystem();
	sparkleParticles4.ActivateSystem();
}

function InteractWithActor(ToA_Pawn hero)
{
	ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("A mysterious cube indeed...");
}

function AddEnemyKilled()
{
	numEnemiesKilled += 1;
	CheckOpenConditions();
}

function CheckOpenConditions()
{
	if(numEnemiesKilled >= requiredNumberOfEnemiesKilled)
	{
		ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("...???");
		OpenCube();
	}
}

function OpenCube()
{
	`Log("THE MAGIC CUBE OPENS UP!");
	if(bPlayedAnimation)
		return;
	if(animNodeCrossfader != none)
	{
		bIsDestroyed = true;
		animNodeCrossfader.PlayOneShotAnim('animation', ,,true); //true sørger for at animasjonen stopper på siste frame
		bPlayedAnimation = true;
		sparkleParticles1.DeactivateSystem();
		sparkleParticles2.DeactivateSystem();
		sparkleParticles3.DeactivateSystem();
		sparkleParticles4.DeactivateSystem();
		SetCollision(false, false);
		
	}
	else
		`Log("Didn't find the animation node...");

}

DefaultProperties
{

	bBlockActors=true
	bCollideActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	Begin Object Class=ParticleSystemComponent Name=Particles1
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=0.25f
		Template=ParticleSystem'erik_particle.MagicField'
	End Object
	sparkleParticles1=Particles1
	Components.Add(Particles1)

	Begin Object Class=ParticleSystemComponent Name=Particles2
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=0.25f
		Template=ParticleSystem'erik_particle.MagicField'
	End Object
	sparkleParticles2=Particles2
	Components.Add(Particles2)

	Begin Object Class=ParticleSystemComponent Name=Particles3
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=0.25f
		Template=ParticleSystem'erik_particle.MagicField'
	End Object
	sparkleParticles3=Particles3
	Components.Add(Particles3)

	Begin Object Class=ParticleSystemComponent Name=Particles4
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=0.25f
		Template=ParticleSystem'erik_particle.MagicField'
	End Object
	sparkleParticles4=Particles4
	Components.Add(Particles4)

	begin object Class=SkeletalMeshComponent Name=SkelMesh
		SkeletalMesh=SkeletalMesh'ToA_Assets.SkeletalMeshes.MagicField_SkelMesh'
		AnimSets(0)=AnimSet'ToA_Assets.AnimSets.MagicField_AnimSet'
		AnimTreeTemplate=AnimTree'ToA_Assets.AnimTrees.MagicField_AnimTree'
		PhysicsAsset=PhysicsAsset'ToA_Assets.PhysicsAsset.MagicField_Physics'
		Materials(0)=Material'ToA_Assets.Materials.MagicField_Material'
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	skelMesh=SkelMesh
	//CollisionComponent=SkelMesh
	Components.Add(SkelMesh)

	begin object class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=80.0
		CollisionHeight=70.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	distanceToUse=80.0f

	numEnemiesKilled=0
	requiredNumberOfEnemiesKilled=4

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.MagicCube_ToolTip'
}
