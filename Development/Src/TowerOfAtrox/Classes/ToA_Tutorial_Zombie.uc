class ToA_Tutorial_Zombie extends ToA_BaseEnemy
	placeable;


function PlayAnimation(Name animName)
{
	super.PlayAnimation(animName);

		switch(animName)
		{
			case 'Looking': animNodeSlot.PlayCustomAnim('Animation_Zombie_Idle01',  1.f, 0.3f, 0.3f, false, true);
			break;
			case 'Idling': animNodeSlot.PlayCustomAnim('Animation_Zombie_Normal01',  1.f, 0.3f, 0.3f, true, true);
			break;
			case 'Walking': animNodeSlot.PlayCustomAnim('Walking',  1.f, 0.3f, 0.3f, true, true);
			break;
			case 'Attacking': animNodeSlot.PlayCustomAnim('Animation_Zombie_Attack01',  2.f, 0.3f, 0.3f, false, true);
			break;
			case 'ReceiveDamage': animNodeSlot.PlayCustomAnim('Animation_Zombie_Damage01', 2.f, 0.3f, 0.3f, false, true);
			break;
			case 'Fleeing': animNodeSlot.PlayCustomAnim('Animation_Zombie_Run01',  1.f, 0.3f, 0.3f, true, true);
			break;
			case 'Death': animNodeSlot.PlayCustomAnim('Animation_Zombie_Death01', 1.0f, 0.3f, 0.2f, false, true);
			break;
			case 'Died': animNodeSlot.PlayCustomAnim('Animation_Zombie_Died', 1.0f, 0.2f, 0.2f, true, true);
			break;
			default: break;

	
		}
}

function ReceiveDamage(int dmg, Vector hitLocation, Vector hitNormal, TraceHitInfo hitInfo)
{
	local Vector decalSpawnPos;

	enemyHealth -= dmg;
	splatSound.Play();
	ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("Hero hits tutorial zombie for"@Dmg@"points of damage!");
	bReceivingDmg = true;

	decalSpawnPos = hitLocation;
	decalSpawnPos.X += 30.0f;
	decalSpawnPos.Y += 30.0f;

	SquirtBlood(hitLocation, rotator(-hitNormal));
	WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial'ToA_Decals.Decals.BloodSquirt', decalSpawnPos, rotator(-hitNormal),128.0f,128.0f,1000.0f,true, FRand() * 360,,false, true);
	WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial'ToA_Decals.Decals.BloodSquirt', decalSpawnPos, rotator(vect(-1,-1,-1)),128.0f,128.0f,500.0f,true, FRand() * 360,,false, true);

	if(enemyHealth <= 0)
	{
		TriggerEventClass(class'SeqEvent_Tutorial_KillEnemy', self, 1);
		bIsDestroyed = true;
		ToA_Pawn(ToA_EnemyController(Owner).Enemy).HeroAddXP(numKillXp);
		ToA_GameInfo(WorldInfo.Game).AddKilledEnemy();
		animNodeSlot.StopCustomAnim(0);
		EndReceiveDmg();
		ToA_EnemyController(Owner).GotoState('Death');
		targetMarker.SetHidden(true);
		SetTimer(9.f, false, 'DestroySelf');
		
	}
	else
	{
		if(!ToA_EnemyController(Owner).IsInState('ReceiveDamage'))
			ToA_EnemyController(Owner).PushState('ReceiveDamage');
		SetTimer(0.5f, false, 'EndReceiveDmg');
	}
}

function Attack(ToA_Pawn victim)
{
	super.Attack(victim);
}

DefaultProperties
{
	bBlockActors=true
	begin object  Name=CollisionCylinder
		CollisionRadius=20.0
		CollisionHeight=40.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	begin object class=StaticMeshComponent Name=targetMesh
		StaticMesh=StaticMesh'ToA_SelectionMarkers.Meshes.ToA_Target_mesh'
		LightEnvironment=MyLightEnvironment
		Translation=(X=40,Y=2,Z=-49)
		Scale3D=(X=2,Y=2,Z=2)
		bAcceptsDecals=false
		bAcceptsDynamicDecals=false
		bAcceptsStaticDecals=false
		HiddenGame=true
	end object
	targetMarker=targetMesh
	Components.Add(targetMesh)

	begin object Class=SkeletalMeshComponent Name=ZombieSkelMesh
		CastShadow=true
		bCastDynamicShadow=true
		bCacheAnimSequenceNodes=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=false
		LightEnvironment=MyLightEnvironment
		BlockRigidBody=true
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=false
		BlockNonZeroExtent=true
		bAcceptsDecals=true
		bAcceptsDynamicDecals=true
		bAcceptsStaticDecals=true
		Scale3D=(X=1,Y=1,Z=1)
		AnimSets(0)=AnimSet'ToA_Enemies.AnimSets.Zombie_Animset'
		AnimTreeTemplate=AnimTree'ToA_Enemies.AnimTrees.Zombie_AnimTree'
		SkeletalMesh=SkeletalMesh'ToA_Enemies.SkeletalMeshes.Zombie_SkelMesh'
		//PhysicsAsset=PhysicsAsset'ToA_Enemies.SkeletalMeshes.Zombie_SkelMesh_Physics'
	end object
	EnemyMesh=ZombieSkelMesh
	Components.Add(ZombieSkelMesh)
	//CollisionComponent=ZombieSkelMesh

	enemyHealth=30
	enemyMaxHealth=30

	numKillXp=0
	//Denne modifiserer AIControllerens speed, så zombien går sakte også under pathfinding movement
	//MovementSpeedModifier=0.05f
	GroundSpeed = 24.0f;

	DmgMin=2
	DmgMax=6
	attackDistance=70.0
//	timeBeforeInflictDamage=0.5f

	attackSpeed=1.5f

	AttackSound=SoundCue'ToA_Lyder.SoundCues.Zombie_Growling_SoundCue'

	SupportedEvents.Add(class'SeqEvent_Tutorial_KillEnemy')
}
