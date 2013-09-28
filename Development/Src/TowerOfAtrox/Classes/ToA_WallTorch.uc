class ToA_WallTorch extends ToA_Burnable
	placeable;

var() ParticleSystemComponent particleEffect;
var ToA_InventoryTorch inventoryTorch;
var ToA_PointLight torchLight;
var bool bIsLit;
var() bool bIsLitFromStart;
var() bool bIsDeactivatedFromStart;

simulated function PostBeginPlay()
{
	SetUpLight();
	if(bIsLitFromStart)
		LightTorch();
	if(bIsDeactivatedFromStart)
		DeactivateObject();
		
}

function SetUpLight()
{
	torchLight = Spawn(class'ToA_PointLight',self,,self.Location,rot(0,0,0),,true);//Siste booleanen sørger for at lyset spawner selv inni actors som har collison
	torchLight.setBrightness(4);
	torchLight.setColor(255, 255, 122, 255);
	torchLight.setRadius(400.0f);
	torchLight.setShadowFalloffExponent(60);
	torchLight.turnOff();

}

function InteractWithActor(ToA_Pawn hero)
{
	inventoryTorch = ToA_InventoryTorch(hero.GetMainhand());
	//Trenger ikke funksjonaliteten i superklassen, vil styre selv når objektet skal deaktiveres fra å kunne trykkes på
	//super.InteractWithActor(hero);

	if(inventoryTorch != none)
	{
		if(inventoryTorch.IsTorchLit() && !particleEffect.bIsActive)
		{
			SetTimer(1.0f, false, 'LightTorch');
			DeactivateObject();
		}
		else if(!inventoryTorch.IsTorchLit() && particleEffect.bIsActive)
		{
			SetTimer(1.0f, false, 'LightInventoryTorch');
			DeactivateObject();
		}

	}
	
}

function DeactivateObject()
{
	SetTimer(0.5f, false, 'MakeMaterialNormal');
	bIsDestroyed = true;
}

function LightInventoryTorch()
{
	inventoryTorch.LightTorch();
}

function bool IsTorchLit()
{
	return bIsLit;
}

function LightTorch()
{
	TriggerEventClass(class'SeqEvent_KillEnemy', self, 1);
	bIsLit = true;
	torchLight.turnOn();
	particleEffect.ActivateSystem();

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
		StaticMesh=StaticMesh'ToA_Assets.StaticMeshes.Torch_Wall_new'
		Materials(0)=Material'ToA_Assets.Materials.Torch_Wall_material'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=2,Y=2,Z=2)
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
		Translation=(X=0,Y=-15,Z=26)
		End Object
	particleEffect=Particles
	Components.Add(Particles)

	normalMaterial=Material'ToA_Assets.Materials.Torch_Wall_material'
	selectedMaterial=Material'ToA_Assets.Materials.Torch_Wall_Selected_Material'

	bIsLitFromStart=false

	SupportedEvents.Add(class'SeqEvent_KillEnemy')

	distanceToUse=80.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Torch_ToolTip'

}
