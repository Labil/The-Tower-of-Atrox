class ToA_EnergyPotion extends ToA_BaseItem
	placeable;

var ToA_InventoryEnergyPotion inventoryPotion;
var() ParticleSystemComponent mysticParticles;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	inventoryPotion = Spawn(class'ToA_InventoryEnergyPotion', self);
	mysticParticles.ActivateSystem();
	
}

/*function InteractWithActor(ToA_Pawn hero)
{
	PickUpPotion(hero);
}*/

function PickUpPotion(ToA_Pawn hero)
{
	local bool bPickedUp;

	if(inventoryPotion != none)
	{
		bPickedUp = hero.pawnInventory.PickUpInventory(inventoryPotion);
		if(bPickedUp)
		{
			mysticParticles.DeactivateSystem();
			Destroy();
		}
	}
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local ToA_Pawn localPawn;
	localPawn = ToA_Pawn(Other); 

	if(localPawn != none)
	{
		PickUpPotion(localPawn);
	}
}

DefaultProperties
{
	bBlockActors=false
	bCollideActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=StaticMeshComponent Name=StaticMeshComp
		StaticMesh=StaticMesh'ToA_Assets.StaticMeshes.Potion_Energi_mesh'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=1,Y=1,Z=1)
	end object
	Mesh=StaticMeshComp
	Components.Add(StaticMeshComp)

	Begin Object Class=ParticleSystemComponent Name=Particles
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=1.0f
		Template=ParticleSystem'erik_particle.Potion_Particle'
	End Object
	mysticParticles=Particles
	Components.Add(Particles)

	begin object class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=20.0
		CollisionHeight=50.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=false
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Potion_ToolTip'
}
