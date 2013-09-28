/*
 * Twice the size of a "normal" spider!
 * 
 */
class ToA_GiantSpider extends ToA_BaseEnemy
	placeable;

var ToA_SpiderSpawnlings spawnling1;
var ToA_SpiderSpawnlings spawnling2;

var bool bImmuneWhileSpawnlingsAreAlive, bSpawnlingsCooldown;
var int SpawnlingsAlive;

var Material immuneMat; //The material she has when she is the immune state
var Material normalMat;

var int attackMode;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

}

function PlayAnimation(Name animName)
{
	super.PlayAnimation(animName);

		switch(animName)
		{
			case 'Looking': animNodeSlot.PlayCustomAnim('Spider_Normal',  1.f, 0.3f, 0.3f, false, true);
			break;
			case 'Idling': animNodeSlot.PlayCustomAnim('Spider_Normal',  1.f, 0.3f, 0.3f, true, true);
			break;
			case 'Walking': animNodeSlot.PlayCustomAnim('Walking',  1.f, 0.3f, 0.3f, true, true);
			break;
			case 'Attacking': animNodeSlot.PlayCustomAnim('Spider_Attack',  1.f, 0.3f, 0.3f, false, true);
			break;
			case 'ReceiveDamage': animNodeSlot.PlayCustomAnim('Spider_Damage', 1.f, 0.3f, 0.3f, false, true);
			break;
			case 'Fleeing': animNodeSlot.PlayCustomAnim('',  1.f, 0.3f, 0.3f, true, true);
			break;
			case 'Death': animNodeSlot.PlayCustomAnim('Spider_Death', 1.0f, 0.3f, 0.2f, false, true);
			break;
			case 'Died': animNodeSlot.PlayCustomAnim('Spider_Died', 1.0f, 0.2f, 0.2f, true, true);
			break;
			default: break;
	
		}
}

function ReceiveDamage(int dmg, Vector hitLocation, Vector hitNormal, TraceHitInfo hitInfo)
{
	local Vector decalSpawnPos;

	if(!bImmuneWhileSpawnlingsAreAlive)
	{
		enemyHealth -= dmg;
		ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("Hero hits Boss for"@Dmg@"points of damage!");
		bReceivingDmg = true;

		decalSpawnPos = hitLocation;
		decalSpawnPos.X += 30.0f;
		decalSpawnPos.Y += 30.0f;

		SquirtBlood(hitLocation, rotator(-hitNormal));
		WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial'ToA_Decals.Decals.BloodSquirt', decalSpawnPos, rotator(-hitNormal),128.0f,128.0f,1000.0f,true, FRand() * 360,,false, true);
		WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial'ToA_Decals.Decals.BloodSquirt', decalSpawnPos, rotator(vect(-1,-1,-1)),128.0f,128.0f,500.0f,true, FRand() * 360,,false, true);

		if(enemyHealth <= 0)
		{
			bIsDestroyed = true;
			ToA_Pawn(ToA_EnemyController(Owner).Enemy).HeroAddXP(numKillXp);
			ToA_GameInfo(WorldInfo.Game).AddKilledEnemy();
			animNodeSlot.StopCustomAnim(0);
			EndReceiveDmg();
			ToA_EnemyController(Owner).GotoState('Death');
			targetMarker.SetHidden(true);
			SpawnKey();
			SetTimer(20.f, false, 'DestroySelf');
		}
		else
		{
			if(!ToA_EnemyController(Owner).IsInState('ReceiveDamage'))
				ToA_EnemyController(Owner).PushState('ReceiveDamage');
			SetTimer(0.5f, false, 'EndReceiveDmg');
		}
	}
}

function SpawnSpawnlings()
{
	local Vector spawnLoc1, spawnLoc2;

	spawnLoc1 = EnemyMesh.GetBoneLocation('CATRig_Spider_Front_LLegAnkle');
	spawnLoc1.X += 80;
	spawnLoc1.Z += 20;
	spawnLoc2 = EnemyMesh.GetBoneLocation('CATRig_Spider_Front_RLegAnkle');
	spawnLoc2.X -= 70;
	spawnLoc2.Z += 20;

	ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("The spawnlings are loose!!");
	ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("KILL THE SPAWNLINGS!");
	spawnling1 = Spawn(class'ToA_SpiderSpawnlings',,,spawnLoc1,,,true);
	if(spawnling1 != none)
	{
		spawnling2.SetSpawnlingMother(self);
		spawnling1.SpawnDefaultController();
	}
	spawnling2 = Spawn(class'ToA_SpiderSpawnlings',,,spawnLoc2,,,true);
	if(spawnling2 != none)
	{
		spawnling2.SetSpawnlingMother(self);
		spawnling2.SpawnDefaultController();
	}

	bImmuneWhileSpawnlingsAreAlive = true;
	SetCollision(false, false);
	SetImmuneMaterial();
	SpawnlingsAlive = 2;

}

function SetImmuneMaterial()
{
	EnemyMesh.SetMaterial(0, immuneMat);
}
function SetNormalMaterial()
{
	EnemyMesh.SetMaterial(0, normalMat);
}

function SpawnlingKilled()
{
	SpawnlingsAlive -= 1;
	CheckSpawnlingsAlive();
}

function CheckSpawnlingsAlive()
{
	if(SpawnlingsAlive <= 0)
	{
		ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("Attack the boss!");
		bImmuneWhileSpawnlingsAreAlive = false;
		SetCollision(true, true);
		SetNormalMaterial();
		SetTimer(5.0f, false, 'EndSpawnlingsCooldown');
	}
}

function EndSpawnlingsCooldown()
{
	bSpawnlingsCooldown=false;
}

function SpawnKey()
{
	local Vector spawnLoc;
	spawnLoc = Location;
	spawnLoc.Z -= 40;
	Spawn(class'ToA_Key',,,spawnLoc,,,true);
}

function SquirtBlood(vector HitLocation, rotator HitRot)
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ToA_Particles.ParticleSystems.BloodSpurtParticles', HitLocation, HitRot, self);
}

function bool CheckIfSpawnlings()
{
	switch(attackMode)
	{
		case 0: attackMode++; return false;
		case 1: attackMode++; return true;
		case 2: attackMode=0; return false;
		default:break;
	}

	/*local int min;
	local int ran;
	min = 50;
	ran = Rand(100);

	if(ran > min)
		return true;
	else
		return false;*/
}

function Attack(ToA_Pawn victim)
{
	if(!bImmuneWhileSpawnlingsAreAlive && !bSpawnlingsCooldown)
	{

		if(CheckIfSpawnlings())
		{
			SpawnSpawnlings();
			bSpawnlingsCooldown = true;
			return;
		}
	}

	Target = victim;
	PlayAnimation('Attacking');
	DamageAmount = GenerateDamageForCurrentAttack();
	Target.ReceiveDamage(DamageAmount);
	PlaySound(AttackSound);
}

function AttackAcidSpray(ToA_Pawn victim)
{
	local ToA_Fireball fireball;
	local Vector spawnLoc;

	spawnLoc = EnemyMesh.GetBoneLocation('CATRig_Spider_Head_LYaw02');
	
	fireball = Spawn(class'ToA_Fireball', self,, spawnLoc,,,true); //På location skal settes in slot i hånda feks

	DamageAmount = GenerateDamageForCurrentAttack();

	fireball.Attack(victim, DamageAmount);
	PlaySound(AttackSound);

}

DefaultProperties
{
	bBlockActors=true
	
	begin object class=StaticMeshComponent Name=targetMesh
		StaticMesh=StaticMesh'ToA_SelectionMarkers.Meshes.ToA_Target_mesh'
		LightEnvironment=MyLightEnvironment
		Translation=(X=120,Y=6,Z=-130)
		Scale3D=(X=8,Y=8,Z=8)
		HiddenGame=true
		bAcceptsDecals=false
		bAcceptsDynamicDecals=false
		bAcceptsDecalsDuringGameplay=false
	end object
	targetMarker=targetMesh
	Components.Add(targetMesh)

	begin object  Name=CollisionCylinder
		CollisionRadius=60.0
		CollisionHeight=140.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	begin object Class=SkeletalMeshComponent Name=SpiderSkelMesh
		AnimSets(0)=AnimSet'ToA_Enemies.AnimSets.Spider_Animset'
		AnimTreeTemplate=AnimTree'ToA_Enemies.AnimTrees.Spider_AnimTree'
		SkeletalMesh=SkeletalMesh'ToA_Enemies.SkeletalMeshes.Spider_SkelMesh'
		Materials(0)=Material'ToA_Enemies.Materials.SpiderBoss_Normal_Mat'
		CastShadow=true
		bCastDynamicShadow=true
		bCacheAnimSequenceNodes=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=false
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=true
		bAcceptsStaticDecals=true
		BlockRigidBody=true
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		bAcceptsDecals=true
		Scale3D=(X=4.5,Y=4.5,Z=4.5)
	end object
	EnemyMesh=SpiderSkelMesh
	Components.Add(SpiderSkelMesh)

	enemyHealth=300
	enemyMaxHealth=300
	numKillXp=600

	GroundSpeed = 0.0f

	DmgMin=20
	DmgMax=40

	
	//immuneToDamageTime=1.0f
	//bImmuneToDamage=false

	attackDistance=160.0f

	attackSpeed=4.0f
	attackMode=0

	AttackSound=SoundCue'ToA_Lyder.SoundCues.Zombie_Growling_SoundCue'

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Boss_ToolTip'

	SpawnlingsAlive=0

	immuneMat=Material'ToA_Enemies.Materials.Enemy_Spider_Immune_Mat'
	normalMat=Material'ToA_Enemies.Materials.SpiderBoss_Normal_Mat'


}

