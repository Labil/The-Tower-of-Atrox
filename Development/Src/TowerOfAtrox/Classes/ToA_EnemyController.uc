class ToA_EnemyController extends AIController;

var float SeekDistance;
var bool bAttacking, bEnemySpotted, bIsReceivingDamage, bNearDestination, bNearPathNode, bShouldPatrol;

var() Vector TempDest;

var PathNode currentDestination;
var PathNode newDestination;
var int i;
var array<PathNode> idleWalkNodes;

var const SoundCue AttackSound;
var ToA_GamePlayerController heroPC;

var bool  bIsEnemyStationary;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(0.1f, false, 'GetHeroControllerRef');

}

/*function SetShouldPatrol(bool b)
{
	bShouldPatrol = b;
}*/

function GetHeroControllerRef()
{
	heroPC = ToA_GameInfo(WorldInfo.Game).controllerWorld;

	if(heroPC == none)
		`Log("ENEMY PLAYER IS NONE");

	bIsEnemyStationary = Pawn.GroundSpeed <= 0;
}

function SetEnemyStationary(bool b)
{
	bIsEnemyStationary = b;
}

function FindIdleWalkNodes()
{
	local PathNode walkNode;

	idleWalkNodes.Length = 0;

	if(!bIsEnemyStationary)
	{
		foreach VisibleActors(class'PathNode', walkNode, 300.0f)
		{
			idleWalkNodes[idleWalkNodes.Length] = walkNode;
		}
	}
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(Enemy == none)
			GetEnemy();

	if(bEnemySpotted)
		bNearDestination = VSize(Enemy.Location - Pawn.Location) < ToA_BaseEnemy(Pawn).GetInteractDistance();

}

auto state Idling
{
	event BeginState(Name PreviousStateName)
	{
		if(ToA_BaseEnemy(Pawn) != none)
		{
			Pawn.SetPhysics(PHYS_None);
			ToA_BaseEnemy(Pawn).PlayAnimation('Idling');
		}
		bEnemySpotted = false;	
	}
	event EndState(Name NextStateName)
	{
	}
	event Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		if(!ToA_BaseEnemy(Pawn).animNodeSlot.bIsPlayingCustomAnim)
			ToA_BaseEnemy(Pawn).PlayAnimation('Idling');

		if(Enemy != none && !ToA_Pawn(Enemy).IsHeroDead())
		{
			if(VSize(Pawn.Location - Enemy.Location) < SeekDistance)
			{
				bEnemySpotted = true;
				if(!bIsEnemyStationary)
				{
					GoToState('Following');
				}
			}
			if(bNearDestination)
			{
				GotoState('Attacking');
			}
		}
	}
Begin:
	Sleep(GenerateRandomFloat(3,15));
	goto('Looking');
Looking:
	ToA_BaseEnemy(Pawn).PlayAnimation('Looking');
	goto('Walking');
Walking:
	Sleep(3.0f);
	FindIdleWalkNodes();
	//Sjekker om idle walknodes > 1, og ikke 0, for han må ha en annen node enn den han står på for å bevege seg mot
	if(idleWalkNodes.Length > 1)
	{
		//`Log("Idle walknodes array length:"@idleWalkNodes.Length);
		for(i = 0; i < idleWalkNodes.Length; i++)
		{
			if(currentDestination == idleWalkNodes[i])
			{
				idleWalkNodes.RemoveItem(idleWalkNodes[i]);
			}
		}
		newDestination = idleWalkNodes[Rand(idleWalkNodes.Length-1)];
		if(currentDestination != newDestination)
		{
			if(FastTrace(newDestination.Location, Pawn.Location,,true))
			{
				currentDestination = newDestination;
				SetDestinationPosition(currentDestination.Location);
				bNearPathNode = false;
				//bPreciseDestination = True;
				GotoState('IdleWalk');
			}
		}
	}
	goto('Begin');

}

state IdleWalk
{
	event BeginState(Name PreviousStateName)
	{
		Pawn.SetPhysics(PHYS_Walking);
		ToA_BaseEnemy(Pawn).PlayAnimation('Walking');
	}
	event EndState(Name NextStateName)
	{
		//`Log("Popping state of Idlewalk");
	}
	event Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		if(Enemy != none && !ToA_Pawn(Enemy).IsHeroDead())
		{
			if(VSize(Pawn.Location - Enemy.Location) < SeekDistance)
			{
				bEnemySpotted = true;
				GoToState('Following');
			}
		}

		bNearPathNode = VSize(Pawn.Location - GetDestinationPosition()) < 60.0f;
		if(bNearPathNode)
		{
			GotoState('Idling');
		}
		
	}
Begin:
	while(!bNearPathNode)
	{
		MoveTo(GetDestinationPosition());
	}
	GotoState('Idling');

}


state Following
{
	event BeginState(Name PreviousStateName)
	{
		if(ToA_BaseEnemy(Pawn) != none)
		{
			Pawn.SetPhysics(PHYS_Walking);
			ToA_BaseEnemy(Pawn).PlayAnimation('Walking');
		}
	}
	event EndState(Name NextStateName)
	{
	}
	event Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);

		if(ToA_BaseEnemy(Pawn).animNodeSlot.GetPlayedAnimation() != 'Walking')
			ToA_BaseEnemy(Pawn).PlayAnimation('Walking');

		if(bNearDestination)
		{
			GotoState('Attacking');
		}
		if(ToA_Pawn(Enemy).IsHeroDead())
			GotoState('Idling');
	}
    function bool FindNavMeshPath()
    {
        NavigationHandle.PathConstraintList = none;
        NavigationHandle.PathGoalList = none;
 
        class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, Enemy );
        class'NavMeshGoal_At'.static.AtActor(NavigationHandle, Enemy , 32); //siste tallet sier hvor nærme som regnes som mål, så fiendene kommer ikke helt oppå

        return NavigationHandle.FindPath();
    }
Begin:
 
    if( NavigationHandle.ActorReachable(Enemy))
    {
        //FlushPersistentDebugLines();
        MoveToward(Enemy, Enemy);
    }
    else if(FindNavMeshPath())
    {
        NavigationHandle.SetFinalDestination(Enemy.Location);
       // FlushPersistentDebugLines();
        //NavigationHandle.DrawPathCache(,TRUE);
 
        if(NavigationHandle.GetNextMoveLocation(TempDest, Pawn.GetCollisionRadius()))
        {
           // DrawDebugLine(Pawn.Location,TempDest,255,0,0,true);
           // DrawDebugSphere(TempDest,16,20,255,0,0,true);
 
            MoveTo(TempDest); //Kan legge inn at fienden hele tida ser mot spiller hele tida med andre parameteret, men uten så ser den mot dit den går og det liker jeg
        }
    }
    else
    {
        GotoState('Idling');
    }
 
    goto 'Begin';
}


state Attacking
{
	event BeginState(Name PreviousStateName)
	{
		if(ToA_BaseEnemy(Pawn) != none)
		{
			Pawn.SetPhysics(PHYS_None);
			bAttacking = false;
			ToA_BaseEnemy(Pawn).PlayAnimation('Idling');
		}
	}
	event EndState(Name NextStateName)
	{
	}
	function Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);
		if(Enemy != none)
		{
			if(!bNearDestination && !IsInState('Following') && !bAttacking && !bIsReceivingDamage && !ToA_BaseEnemy(Pawn).bIsDestroyed && !bIsEnemyStationary)
				GotoState('Following');
			if(bNearDestination && !bAttacking && !bIsReceivingDamage && !ToA_BaseEnemy(Pawn).bIsDestroyed && !heroPC.IsInState('Attacking') && !heroPC.IsInState('ReceiveDamage'))
			{
				RotatePawnTowardsTarget(DeltaTime, Enemy.Location);
				ToA_BaseEnemy(Pawn).Attack(ToA_Pawn(Enemy));
				bAttacking = true;
				SetTimer(ToA_BaseEnemy(Pawn).GetAttackSpeed(), false, 'EndAttack');
			}
			else if(ToA_GiantSpider(Pawn) != none && !bNearDestination && bEnemySpotted && !bAttacking)
			{
				RotatePawnTowardsTarget(DeltaTime, Enemy.Location);
				ToA_GiantSpider(Pawn).AttackAcidSpray(ToA_Pawn(Enemy));
				bAttacking = true;
				SetTimer(ToA_BaseEnemy(Pawn).GetAttackSpeed(), false, 'EndAttack');
			}

			if(!ToA_BaseEnemy(Pawn).animNodeSlot.bIsPlayingCustomAnim && !ToA_BaseEnemy(Pawn).bIsDestroyed)
				ToA_BaseEnemy(Pawn).PlayAnimation('Idling');

			if(ToA_Pawn(Enemy).IsHeroDead())
				GotoState('Idling');
		}
		/*if(ToA_Zombie(Pawn).currentHealth < 10)
		{
			GotoState('Fleeing');
		}*/
	}
}
state ReceiveDamage
{
	event PushedState()
	{
		bIsReceivingDamage = true;
		ToA_BaseEnemy(Pawn).PlayAnimation('ReceiveDamage');
	}
	event PoppedState()
	{
		bIsReceivingDamage = false;
		DumpStateStack();
	}
	event Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);

		//if(ToA_BaseEnemy(Pawn).animNodeSlot.GetPlayedAnimation() != 'Animation_Zombie_Damage01')
		//if(!ToA_BaseEnemy(Pawn).animNodeSlot.bIsPlayingCustomAnim)
			//PopState();

	}
Begin:
	Sleep(1.0f);
	PopState();
}
state Death
{
	event BeginState(Name PreviousStateName)
	{
		`Log("Begin state of Death");
		if(ToA_BaseEnemy(Pawn) != none)
		{
			Pawn.SetPhysics(PHYS_None);
			ToA_BaseEnemy(Pawn).PlayAnimation('Death');
			ToA_BaseEnemy(Pawn).SetCollision(false, false);
		}
	}
	event EndState(Name NextStateName)
	{
		`Log("This should never print...");
	}
	function Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);
		
		if(!ToA_BaseEnemy(Pawn).animNodeSlot.bIsPlayingCustomAnim)
			ToA_BaseEnemy(Pawn).PlayAnimation('Died');
		
	}
}

function RotatePawnTowardsTarget(float DeltaTime, vector dest)
{
	local Rotator desiredPawnRotation;
	local Rotator newRotation;
	local float rotSpeed;

	desiredPawnRotation = Rotator(dest - Pawn.Location);
	desiredPawnRotation.Pitch = Pawn.Rotation.Pitch;
	desiredPawnRotation.Roll = Pawn.Rotation.Roll;

	if(Pawn.Rotation != desiredPawnRotation)
	{
		rotSpeed = 60.0f * DeltaTime;
		newRotation = RLerp(Pawn.Rotation, DesiredPawnRotation, rotSpeed, true);
		Pawn.SetRotation(NewRotation);
	}

}


state Fleeing
{
	//ignores TakeDamage;
	function BeginState(Name PreviousStateName)
	{
//		movementSpeed += 20;
		if(Pawn != none)
		{
			Pawn.SetPhysics(PHYS_Walking);
			ToA_BaseEnemy(Pawn).PlayAnimation('Walking');
		}
	}
	event PlayerTick(float DeltaTime)
	{
		//local Vector NewLocation;

		if(Enemy == none)
			GetEnemy();
		/*if(Enemy != none)
		{
			NewLocation = Pawn.Location;
			NewLocation -= Normal(Enemy.Location - Pawn.Location) * movementSpeed * DeltaTime;
			Pawn.SetLocation(NewLocation);
			RotatePawnTowardsTarget(DeltaTime, NewLocation);
		}*/
	}
}


function EndAttack()
{
	bAttacking = false;
}

function float GenerateRandomFloat(int min, int max)
{
	local int diff;
	local int val;
	diff = max - min;
	val = Rand(diff) + min;

	return float(val);
}

function GetEnemy()
{
	local ToA_GamePlayerController PC;

	foreach LocalPlayerControllers(class'ToA_GamePlayerController', PC)
	{
		if(PC.Pawn != none)
			Enemy = ToA_Pawn(PC.Pawn);
	}
}


DefaultProperties
{
	SeekDistance=250.0
	bIsReceivingDamage=false;
	bShouldPatrol=true

}
