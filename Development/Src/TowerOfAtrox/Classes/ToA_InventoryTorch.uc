class ToA_InventoryTorch extends ToA_InventoryWeapon;

var ParticleSystemComponent torchFireEffect;
var ToA_PointLight torchLight;
var const name TorchTipSocketName;
var bool bIsLit;
var AudioComponent torchSound;

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(Owner == none)
	{
		`Log("Torch owner is NONE!");
		FindOwner();
	}
	else
		Move(Owner.Location - self.Location);

	if(bIsLit)
	{
		if(!torchSound.IsPlaying())
			torchSound.Play();
	}
}

simulated function PostBeginPlay()
{
	SetUpLight();
	AttachParticleSystemToTorch(attachMesh, TorchTipSocketName);
}

function FindOwner()
{
	local ToA_InventoryManager invMgr;
	invMgr = ToA_Pawn(ToA_GameInfo(WorldInfo.Game).controllerWorld.Pawn).pawnInventory;
	if(invMgr != none)
		SetOwner(invMgr);
}

//Overkjører damage amount som sendes ved. Torchen skal alltid slå for 1.
function SwingSword(int dmg)
{
	dmg = 1;

	super.SwingSword(dmg);
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

function EquipItemToOwner(ToA_Pawn hero)
{
	super.EquipItemToOwner(hero);

	if(bIsLit)
		LightTorch();
}

function PutAwayItem(ToA_Pawn hero)
{
	super.PutAwayItem(hero);
	if(bIsLit)
		TurnOffTorch();
}

function LightTorch()
{
	bIsLit = true;
	ToA_GameInfo(WorldInfo.Game).SetTorchBoolTrue();
	if(torchLight != none)
		torchLight.turnOn();
	torchSound.Play();
	torchFireEffect.ActivateSystem();
}
function TurnOffTorch()
{
	if(torchLight != none)
		torchLight.turnOff();
	torchFireEffect.DeactivateSystem();
	torchSound.Stop();
}

function bool IsTorchLit()
{
	return bIsLit;
}

function AttachParticleSystemToTorch(SkeletalMeshComponent SM, name socket)
{
	SM.AttachComponentToSocket(torchFireEffect, socket);
}

function DetachParticleSystem(SkeletalMeshComponent SM)
{
	SM.DetachComponent(torchFireEffect);
}

DefaultProperties
{
	begin object Class=SkeletalMeshComponent name=Skelly
		SkeletalMesh=SkeletalMesh'ToA_Hero.Weapons.Torch_USE'
	end object
	attachMesh=Skelly

	Begin Object Class=ParticleSystemComponent Name=Particles
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=0.2f
		Template=ParticleSystem'ToA_Particles.Particles.ToA_TorchFlame_Particle'
		Rotation=(Pitch=0,Roll=90,Yaw=0)
		End Object
	torchFireEffect=Particles

	begin object class=AudioComponent Name=AudioComp2
		SoundCue=SoundCue'ToA_Lyder.WAV.Torch_ambient_Sound_Cue'
		bAutoPlay=false
		//VolumeMultiplier=1
		//SourceInteriorVolume=1
	end object
	torchSound=AudioComp2
	Components.Add(AudioComp2)

	TorchTipSocketName="FireSocket"
	HiltSocketName="TorchHilt"
	TipSocketName="TorchTip"
	BackSocketName="TorchBackSocket"
	HandSocketName="TorchSlot"
	HudDisplayName="Torch"
}
