class ToA_InventoryWeapon extends ToA_InventoryItem;

var const name HiltSocketName, TipSocketName;

var bool bAttacking;
var array<Actor> actorsHitBySword;
var int DamageAmount;
var AudioComponent weaponSwoosh;
//var() const SoundCue weaponSwoosh;
var Name currentAnim;
//var ParticleSystemComponent swordParticleSwoosh;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	//attachMesh.AttachComponentToSocket(swordParticleSwoosh, SwordTipSocketName);
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	
	if(bAttacking)
	{
		TraceSwing();

		if(heroRef.animNodeSlot.GetPlayedAnimation() != heroRef.currentAnim)
		{
			bAttacking = false;
			//swordParticleSwoosh.DeactivateSystem();
		}
	}
}

function PutAwayItem(ToA_Pawn hero)
{
	super.PutAwayItem(hero);

	hero.Mesh.AttachComponentToSocket(attachMesh, BackSocketName);
}

function SwingSword(int dmg)
{
	if(!bAttacking)
	{
		actorsHitBySword.Remove(0, actorsHitBySword.Length);
		SetTimer(0.2f, false, 'SetAttackingTrue');
		SetTimer(0.3f, false, 'PlaySwordSound');
		bAttacking = true;
		DamageAmount = dmg;
		//swordParticleSwoosh.ActivateSystem();
		//SetTimer(1.0f, false, 'EndAttack');
		
	}

}

function PlaySwordSound()
{
	weaponSwoosh.Play();
	//PlaySound(weaponSwoosh);
}

function SetAttackingTrue()
{
	bAttacking = true;
}

function TraceSwing()
{
   local ToA_BaseEnemy HitActor;
   local Vector HitLoc, HitNorm, WeaponTip, WeaponHilt;
   local TraceHitInfo HitInfo;
   local ToA_Destructible DestructibleActor;
   local Vector momentum;

    WeaponTip = GetSwordSocketLocation(TipSocketName);
    WeaponHilt = GetSwordSocketLocation(HiltSocketName);

   foreach TraceActors(class'ToA_BaseEnemy', HitActor, HitLoc, HitNorm, WeaponTip, WeaponHilt,vect(1,1,1),hitInfo)
   {
      if(AddToAlreadyHitArray(HitActor))
      {
         HitActor.ReceiveDamage(DamageAmount, HitLoc, HitNorm, HitInfo);
		 
		 //DrawDebugSphere( HitLoc, 1, 16, 0, 255, 0, true );
		 //DrawDebugLine( HitLoc, HitLoc + HitNorm * 10.0, 0, 255, 0, true );
      }
   }
   foreach TraceActors(class'ToA_Destructible', DestructibleActor, HitLoc, HitNorm, WeaponTip, WeaponHilt)
   {
		momentum = normal(WeaponHilt - WeaponTip) * 2000;
		DestructibleActor.TakeDamage(5,ToA_GameInfo(WorldInfo.Game).controllerWorld, HitLoc, momentum, class'DamageType');
   }
}

function bool CheckIsAttacking()
{
	return bAttacking;
}

function Vector GetSwordSocketLocation(Name socketName)
{
   local Vector socketLocation;
   local Rotator socketRotation;

   if (attachMesh.GetSocketByName(socketName) != none)
   {
      attachMesh.GetSocketWorldLocationAndRotation(socketName, socketLocation, socketRotation);
   }
   else
	`Log("WEAPONMESH == NONE!");

   return socketLocation;
}

function bool AddToAlreadyHitArray(ToA_BaseEnemy HitActor)
{
   if (actorsHitBySword.find(HitActor) != -1 ) return false;

   actorsHitBySword.AddItem(HitActor);
   return true;
}


DefaultProperties
{
	//weaponSwoosh=SoundCue'ToA_Lyder.WAV.Sword_Sound_Cue'

	begin object class=AudioComponent Name=AudioComp
		SoundCue=SoundCue'ToA_Lyder.WAV.Sword_Sound_Cue'
		bAutoPlay=false
		//VolumeMultiplier=2
		//SourceInteriorVolume=0.2
	end object
	weaponSwoosh=AudioComp
	Components.Add(AudioComp)
}
