class ToA_SpiderSpawnlings extends ToA_Spider;

var ToA_GiantSpider mother;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(mother == none)
	{
		GetMother();
	}
}

function GetMother()
{
	local ToA_GiantSpider mom;
	foreach DynamicActors(class'ToA_GiantSpider', mom)
	{
		mother = mom;
	}
}

function ReceiveDamage(int dmg, Vector hitLocation, Vector hitNormal, TraceHitInfo hitInfo)
{
	enemyHealth -= dmg;
	ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("Hero hits spawnling for"@Dmg@"points of damage!");
	bReceivingDmg = true;

	if(enemyHealth <= 0)
	{
		bIsDestroyed = true;
		animNodeSlot.StopCustomAnim(0);
		EndReceiveDmg();
		ToA_EnemyController(Owner).GotoState('Death');
		targetMarker.SetHidden(true);

		if(mother != none)
			mother.SpawnlingKilled();
		else
			`Log("SPAWNLING HAS NO OWNER UPON DEATH");

		SetTimer(1.f, false, 'DestroySelf');
	}
	else
	{
		if(!ToA_EnemyController(Owner).IsInState('ReceiveDamage'))
			ToA_EnemyController(Owner).PushState('ReceiveDamage');
		SetTimer(0.5f, false, 'EndReceiveDmg');
	}

}

function SetSpawnlingMother(ToA_GiantSpider mom)
{
	mother = mom;
	if(mother != none)
		`Log("Mother is"@mother);
	else
		`Log("Spawnling has no mom......");
}

DefaultProperties
{
	bBlockActors=true
	
	begin object Name=targetMesh
		StaticMesh=StaticMesh'ToA_SelectionMarkers.Meshes.ToA_Target_mesh'
		LightEnvironment=MyLightEnvironment
		Translation=(X=55,Y=6,Z=-40)
		Scale3D=(X=3,Y=3,Z=3)
		HiddenGame=true
	end object
	targetMarker=targetMesh
	Components.Add(targetMesh)

	begin object  Name=CollisionCylinder
		//Gjort radius litt større enn selve meshen for at den skal være enklere å trykke på
		CollisionRadius=25.0
		CollisionHeight=40.0
		BlockNonZeroExtent=true
		//Må blocke zero extent, er det musa tracer med
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	begin object  Name=SpiderSkelMesh
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
		Scale3D=(X=1.5,Y=1.5,Z=1.5)
	end object
	EnemyMesh=SpiderSkelMesh
	Components.Add(SpiderSkelMesh)

	enemyHealth=20
	enemyMaxHealth=20
	numKillXp=0
	GroundSpeed = 100.0f

	DmgMin=5
	DmgMax=10

	attackDistance=50.0f

	attackSpeed=3.0f

	AttackSound=SoundCue'ToA_Lyder.SoundCues.Zombie_Growling_SoundCue'

}
