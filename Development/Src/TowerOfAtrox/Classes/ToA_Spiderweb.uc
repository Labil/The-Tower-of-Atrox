class ToA_Spiderweb extends ToA_Burnable
	placeable;

var ParticleSystemComponent particleEffect;


function InteractWithActor(ToA_Pawn hero)
{
	if(hero.GetMainhand().IsA('ToA_InventoryTorch'))
	{
		super.InteractWithActor(hero);
		if(ToA_InventoryTorch(hero.GetMainhand()).IsTorchLit() && !particleEffect.bIsActive)
			SetTimer(1.0f, false, 'LightWeb');
	}
	
}

function LightWeb()
{
	particleEffect.ActivateSystem();
	SetTimer(3.0f, false, 'DestroySelf');
}

function DestroySelf()
{
	particleEffect.DeactivateSystem();
	Destroy();
}


DefaultProperties
{
	bCollideActors=true
	bBlockActors = true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=StaticMeshComponent Name=StaticMeshComp
		StaticMesh=StaticMesh'ToA_Assets.StaticMeshes.SpiderWeb'
		Materials(0)=Material'ToA_Assets.Materials.SpiderWeb_Material'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=4,Y=4,Z=4)
		BlockNonZeroExtent=false
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	Mesh=StaticMeshComp
	CollisionComponent=StaticMeshComp
	Components.Add(StaticMeshComp)

	Begin Object class=ParticleSystemComponent Name=Particles
		bAutoActivate=false 
		Scale=0.3f
		Template=ParticleSystem'ToA_Particles.Particles.ToA_TorchFlame_Particle'
		SecondsBeforeInactive=0.5f
		Translation=(X=0,Y=0,Z=35)
		End Object
	particleEffect=Particles
	Components.Add(Particles)

	normalMaterial=Material'ToA_Assets.Materials.SpiderWeb_Material'
	selectedMaterial=Material'ToA_Assets.Materials.SpiderWeb_Selected_Material'

	distanceToUse=120.0f


}
