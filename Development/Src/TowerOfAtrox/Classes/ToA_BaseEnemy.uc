class ToA_BaseEnemy extends Pawn implements(ITargetInterface)
	abstract;

struct Enemy_SaveData
{
	var bool bDead;
	var Vector location;
	var Rotator rotation;
};

var Enemy_SaveData data;

var() SkeletalMeshComponent EnemyMesh;
var() StaticMeshComponent targetMarker;
var const SoundCue attackSound;

var() int numKillXp, enemyHealth, enemyMaxHealth;
var bool bIsTargeted, bIsHoveredOver, bIsDestroyed, bReceivingDmg;
var() int DmgMin, DmgMax, DamageAmount;
//var float timeBeforeInflictDamage; //Liten delay satt med timer før hero mottar skaden han får av angrep, for å få animasjonene til å synce bedre
var() float attackSpeed;

var float DistanceRemaining, attackDistance;

var AnimNodeSlot animNodeSlot;
var const Texture2D tooltipTexture;

var ToA_Pawn Target;

var AudioComponent splatSound;

function UpdateStruct()
{
	//data.HP = enemyHealth;
	data.bDead = bIsDestroyed;
	data.location = Location;
	data.rotation = Rotation;
}

simulated event Destroyed()
{
	super.Destroyed();
	//Viktig å sette den til none, den blir ikke garbage collected!
	animNodeSlot = none;
	bIsDestroyed = true;
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	animNodeSlot = AnimNodeSlot(SkelComp.FindAnimNode('EnemyAnimSlot'));
}

function SetMovementPhysics()
{
	super.SetMovementPhysics();
}

function Attack(ToA_Pawn victim)
{
	Target = victim;
	PlayAnimation('Attacking');
	DamageAmount = GenerateDamageForCurrentAttack();
	Target.ReceiveDamage(DamageAmount);
	PlaySound(AttackSound);
}

function PlayAnimation(Name animName)
{
}
function StopAnimation()
{
	animNodeSlot.StopCustomAnim(0.2f);
}

function float GetAttackSpeed()
{
	return attackSpeed;
}

function int GenerateRandomInt(int min, int max)
{
	local int diff;
	local int val;
	diff = max - min;
	val = Rand(diff) + min;

	return val;
}

function int GenerateDamageForCurrentAttack()
{
	local int dieRollDmg;

	dieRollDmg = GenerateRandomInt(DmgMin, DmgMax);

	return dieRollDmg;
}

function ReceiveDamage(int dmg, Vector hitLocation, Vector hitNormal, TraceHitInfo hitInfo)
{
	local Vector decalSpawnPos;

	enemyHealth -= dmg;
	splatSound.Play();
	ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("Hero hits enemy for"@Dmg@"points of damage!");
	bReceivingDmg = true;

	decalSpawnPos = hitLocation;
	decalSpawnPos.X += 30.0f;
	decalSpawnPos.Y += 30.0f;

	SquirtBlood(hitLocation, rotator(-hitNormal));
	WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial'ToA_Decals.Decals.BloodSquirt', decalSpawnPos, rotator(-hitNormal),128.0f,128.0f,1000.0f,true, FRand() * 360,,false, true);
	WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial'ToA_Decals.Decals.BloodSquirt', decalSpawnPos, rotator(vect(-1,-1,-1)),128.0f,128.0f,500.0f,true, FRand() * 360,,false, true);

	if(enemyHealth <= 0)
	{
		TriggerEventClass(class'SeqEvent_ThirdRoom_KilledEnemy', self, 1);
		bIsDestroyed = true;
		ToA_Pawn(ToA_EnemyController(Owner).Enemy).HeroAddXP(numKillXp);
		ToA_GameInfo(WorldInfo.Game).AddKilledEnemy();
		animNodeSlot.StopCustomAnim(0);
		EndReceiveDmg();
		ToA_EnemyController(Owner).GotoState('Death');
		targetMarker.SetHidden(true);
		SetCollision(false, false);
		SetTimer(9.f, false, 'DestroySelf');
		
	}
	else
	{
		if(!ToA_EnemyController(Owner).IsInState('ReceiveDamage'))
			ToA_EnemyController(Owner).PushState('ReceiveDamage');
		SetTimer(0.5f, false, 'EndReceiveDmg');
	}
}

function EndReceiveDmg()
{
	bReceivingDmg = false;
}

function SquirtBlood(vector HitLocation, rotator HitRot)
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ToA_Particles.ParticleSystems.BloodSpurtParticles', HitLocation, HitRot, self,,,true);
}

function DestroySelf()
{
	Destroy();
}

function InteractWithActor(ToA_Pawn hero)
{
}

function MakeMaterialBrighter()
{
}

function MakeMaterialNormal()
{
}

function Texture2D GetTooltipTexture()
{
	//Fiender skal ikke ha tooltips (?) Kan evt legges inn.
	//return none;
	return tooltipTexture;
}

function OnMouseOver()
{
	if(bIsDestroyed)
		return;
	bIsHoveredOver = true;
	if(targetMarker != none)
		targetMarker.SetHidden(false);
}

function OnMouseAway()
{
	bIsHoveredOver = false;
	if(bIsDestroyed)
		return;
	if(!bIsTargeted)
	{
		if(targetMarker != none)
			targetMarker.SetHidden(true);
	}
}

function OnMouseClick()
{
	if(bIsDestroyed)
		return;
	bIsTargeted = true;
	if(targetMarker != none)
		targetMarker.SetHidden(false);
}

function OnMouseClickAway()
{
	bIsTargeted = false;
	if(bIsDestroyed)
		return;
	if(targetMarker != none)
		targetMarker.SetHidden(true);

}

function bool IsActorTargeted()
{
	return bIsTargeted;
}

function bool IsActorHoveredOver()
{
	return bIsHoveredOver;
}

function float GetInteractDistance()
{
	return attackDistance;
}

function bool CheckActorDestroyed()
{
	return bIsDestroyed;
}

DefaultProperties
{
	bBlockActors=true
	bCollideActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		ModShadowFadeoutTime=0.25
		MinTimeBetweenFullUpdates=0.2
		AmbientGlow=(R=.01,G=.01,B=.01,A=1)
		AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
		bSynthesizeSHLight=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=AudioComponent Name=AudioComp
		SoundCue=SoundCue'ToA_Lyder.WAV.Enemy_Splat_Cue'
		bAutoPlay=false
	end object
	splatSound=AudioComp
	Components.Add(AudioComp)

	enemyHealth=60
	enemyMaxHealth=60
	attackDistance=60.0f

	bIsTargeted=false
	bIsHoveredOver=false

	ControllerClass=class'ToA_EnemyController'

	SupportedEvents.Add(class'SeqEvent_ThirdRoom_KilledEnemy')

}
