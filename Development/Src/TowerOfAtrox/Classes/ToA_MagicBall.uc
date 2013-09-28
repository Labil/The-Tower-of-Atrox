/*
 * Baseklasse for magic spells, default er fireball
 * Bytt ut partikkel-komponenten i klasser som arver
 */

class ToA_MagicBall extends ToA_ActorBase;

var StaticMeshComponent sphere;
var ParticleSystemComponent particleEffect;
var ToA_Pawn target;

var const float speed;

var bool bReachedTarget;
var bool bDestroyed;

var float DamageAmount;

event Tick(float DeltaTime)
{
	if(!bReachedTarget)
	{
		if(target != none)
		{
			MoveTowardsTarget(DeltaTime);
			RotateTowardsTarget(DeltaTime);
		}
	}
	else if(bReachedTarget && !bDestroyed)
	{
	//	target.ReceiveDamage(DamageAmount, target.Location, target.Location);
		`Log("Inflicting"@DamageAmount@"amount of damage on target!");
		target.ReceiveDamage(DamageAmount);
		target = none;
		SetTimer(1.0f, false, 'KillSelf');
		bDestroyed = true;
	}
}

//Snur Pawn-en mot destinasjonen med interpolation.
function RotateTowardsTarget(float DeltaTime)
{
	local Rotator desiredRotation;
	local Rotator newRotation;
	local float rotSpeed;

	desiredRotation = Rotator(target.Location - Location);
	desiredRotation.Pitch = Rotation.Pitch;
	desiredRotation.Roll = Rotation.Roll;

	if(Rotation != desiredRotation)
	{
		rotSpeed = 10.0f * DeltaTime;
		newRotation = RLerp(Rotation, desiredRotation, rotSpeed, true);
		SetRotation(newRotation);
	}

}

function KillSelf()
{
	`Log("Deactivating partikles");
	particleEffect.DeactivateSystem();
	Destroy();
}

function Attack(ToA_Pawn victim, float dmg)
{
	DamageAmount = dmg;
	target = victim;
	bReachedTarget = false;

}

function MoveTowardsTarget(float DeltaTime)
{
	local Vector newLocation, targetLocation;
	local float distanceRemaining, minDistance;
	local float zPosOffset, colRadius, colHeight;

	minDistance = 30.0f;

	target.GetBoundingCylinder(colRadius, colHeight);
	zPosOffset = colHeight/7;
	targetLocation = target.Location;
	targetLocation.Z -= zPosOffset;

	if(FastTrace(target.Location, ,,true))
	{
		newLocation = Location;
		newLocation += Normal(target.Location - Location) * speed * DeltaTime;
		SetLocation(newLocation);
	}
	else
	{
		//Enemy er ikke in line of sight
		KillSelf();
	}

	distanceRemaining = VSize(targetLocation - Location);

	bReachedTarget = DistanceRemaining <= minDistance;
	
}
//fireball = WorldInfo.MyEmitterPool.SpawnEmitter(particleTemplate, sphere.Location);

DefaultProperties
{
	bBlockActors=true
	bCollideActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	Begin Object Class=ParticleSystemComponent Name=Particles
		bAutoActivate=true 
		Scale=1.0f
		Template=ParticleSystem'ToA_Particles.Particles.ToA_TorchFlame_Particle'
		Rotation=(Pitch=90,Roll=0,Yaw=0)
		SecondsBeforeInactive=1.0f
		End Object
	particleEffect=Particles
	Components.Add(Particles)

	speed=800.0f
}
