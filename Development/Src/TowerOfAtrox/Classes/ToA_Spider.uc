class ToA_Spider extends ToA_BaseEnemy
	placeable;



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
	super.ReceiveDamage(dmg, hitLocation, hitNormal, hitInfo);
}

function SquirtBlood(vector HitLocation, rotator HitRot)
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ToA_Particles.ParticleSystems.BloodSpurtParticles', HitLocation, HitRot, self);
}


function Attack(ToA_Pawn victim)
{
	super.Attack(victim);
}

DefaultProperties
{
	bBlockActors=true
	
	begin object class=StaticMeshComponent Name=targetMesh
		StaticMesh=StaticMesh'ToA_SelectionMarkers.Meshes.ToA_Target_mesh'
		LightEnvironment=MyLightEnvironment
		Translation=(X=55,Y=6,Z=-40)
		Scale3D=(X=3,Y=3,Z=3)
		HiddenGame=true
		bAcceptsDecals=false
		bAcceptsDynamicDecals=false
		bAcceptsDecalsDuringGameplay=false
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

	begin object Class=SkeletalMeshComponent Name=SpiderSkelMesh
		AnimSets(0)=AnimSet'ToA_Enemies.AnimSets.Spider_Animset'
		AnimTreeTemplate=AnimTree'ToA_Enemies.AnimTrees.Spider_AnimTree'
		SkeletalMesh=SkeletalMesh'ToA_Enemies.SkeletalMeshes.Spider_SkelMesh'
		//PhysicsAsset=PhysicsAsset'ToA_Enemies.PhysicsAssets.Spider_Walk_Physics'
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
	//CollisionComponent=SpiderSkelMesh
	EnemyMesh=SpiderSkelMesh
	Components.Add(SpiderSkelMesh)

	enemyHealth=40
	enemyMaxHealth=40
	numKillXp=50
	//Denne modifiserer AIControllerens speed, så zombien går sakte også under pathfinding movement
	//MovementSpeedModifier=0.05f
	GroundSpeed = 100.0f

	DmgMin=2
	DmgMax=8

	attackDistance=70.0f
//	timeBeforeInflictDamage=0.3f

	attackSpeed=1.8f

	AttackSound=SoundCue'ToA_Lyder.SoundCues.Zombie_Growling_SoundCue'

}
