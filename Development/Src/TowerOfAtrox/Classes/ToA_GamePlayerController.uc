/*
 *  The brain of the Pawn.
 * 
 *  Also handles exec functions and uses input from the hud and MouseInterfacePlayerInput.
 *  Has states for idling, moving, attacking, death, dodging, receiving damage as well as some other special states. 
 */
class ToA_GamePlayerController extends PlayerController;

var Vector2D        PlayerMouse; //Holds the mouse position that is being calculated in the hud
var ToA_MovePointer MoveLocationPointer; //The mesh that spawns on the floor to indicate where the player clicked to move

var Vector          MouseHitWorldLocation; //Lagrer i 3D-koordinat hvor i verden ray casten fra musa treffer world geometry. Bruker dette til å si hvor spilleren skal flyttes hen
var Vector          MouseHitWorldNormal; //Lagrer den normaliserte vektoren for world location for å få retningen MouseHitWorldLocation trenger (ikke brukt)
var Vector          MousePosWorldLocation; //Lagrer deprojectert mus location i 3d world coords. (regnes ut i hud) (ikke brukt her)
var Vector          MousePosWorldNormal; //Lagrer deprojectert mouse location normal. (beregnes i HUD, brukes for kamera ray ovenfra)

var vector          StartTrace; //Der ray-en begynner fra kameraet
var Vector          EndTrace;  //Der ray-en ender opp, fra kamera mot bakken
var vector          RayDir;   //Retningen på ray-en
var Vector          PawnEyeLocation; //Pawnens øye som brukes til å sende ray query for å finne ut om noe blokkerer path-en fra Pawn til destinasjon
var Actor           TraceActor; //Holder eventuelle Actors som befinner seg under muspekeren til et hvert tidspunkt

//Muse-klikk variabler:
var float           DeltaTimeAccumulated, clickSensitivity; //Hvor lenge mustasten må holdes nede før det regnes som at man holder den inne, og ikke bare klikker
var bool            bLeftMousePressed, bRightMousePressed, bMouseMiddleCheck, bOneButtonPressed, bRotateLeft, bRotateRight, bRightMouseHold; 

//Variabler som har med Pitch-rotasjon rundt Pawn ved å holde nede midterste mus-tast
var Vector          mouseCurrentRotation;
var float           mouseTotalXRotation;

var Actor           currentHoverTarget, currentClickTarget;

var bool            bCamIsIso, bPawnNearDestination, bAttackingSword,bMouseAtHeroLoc, bAttackingMagic, bClickingOnItem, bReceivingDmg, bTorchEquipped;
var bool            bShouldInteract, bHitObstacle, bUsingTorch, bDoneCharging, bDoneBlocking, bBlocking, bNotAbleToAttack, bDodging;
var const float     swordAttackDistance, castingTime, cycleEnemiesRadius, cameraRotationSpeed, chargeRangeMax, chargeRangeMin;

var array<ToA_BaseEnemy> enemiesNearby; // For Q-targetings

var Vector          TempDest;
var Vector          FinalDestination;

var Name            currentAttackName; //Gets sent in from pawn class
var name            lastState; //The last state the player was in

var ToA_Pawn        heroPawn;//Reference to our custom Pawn class
var ATROXHUD        customHud;
var ToA_EscMenu     escapeMenu; 
var ToA_DeathMenu   deathMenu;


//----------------------------------------------------------------------------------

function SetWorldVariables()
{
	customHud = ToA_GameInfo(WorldInfo.Game).hudWorld;
	heroPawn = ToA_Pawn(Pawn);
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	ToA_GameInfo(WorldInfo.Game).controllerWorld = self;
	//Setter til true så man kan slå med sverdet uten å ha flyttet seg(da det krever at man står i ro/har ankommet målet (bPawnNearDestination = true) for å kunne slå
	bPawnNearDestination = true;
	SetTimer(0.1, false, 'SetWorldVariables');
}

function GetPawnReference()
{
	if(ToA_Pawn(Pawn) != none)
		heroPawn = ToA_Pawn(Pawn);
}
function EnterStartState()
{
	`Log("Overriding EnterStartState()");
	//Må gjøre dette pga ellers overkjører denne at pawnen er i Idlin state fra starten
	GotoState('Idling');
}
event PlayerTick(float DeltaTime)
{
	super.PlayerTick(DeltaTime);

	if(heroPawn == none)
		GetPawnReference();

	RotateCameraIfMiddleMouseButtonPressed();
	if(bRotateLeft || bRotateRight)
		CheckRotateCamera();

	CheckIfMouseOverActor();
	CheckIfMouseOffActor();

	if(ITargetInterface(currentClickTarget) != none)
	{
		RotatePawnTowardsTarget(DeltaTime, currentClickTarget.Location);
		if(VSize(currentClickTarget.Location - Pawn.Location) <= ITargetInterface(currentClickTarget).GetInteractDistance())
		{
			bPawnNearDestination = true;
			RotatePawnTowardsTarget(DeltaTime, currentClickTarget.Location);
			//InstantRotateHeroTowardTarget(currentClickTarget.Location);
			if(!IsInState('Idling') && !bNotAbleToAttack)
			{
				GotoState('Idling');
				bShouldInteract = true;
			}
			else if(IsInState('Idling') && !bNotAbleToAttack && bLeftMousePressed)
			{
				//Husker ikke helt hvorfor jeg gjorde det sånn med denne elsen, men den bugger litt uten, så la dette stå!
				bShouldInteract = true;
			}
		}
		
		if(ITargetInterface(currentClickTarget).CheckActorDestroyed())
			currentClickTarget = none;

	}
	
	if(bLeftMousePressed)
	{
		DeltaTimeAccumulated += DeltaTime;
		SetDestinationPosition(MouseHitWorldLocation);

		if(DeltaTimeAccumulated >= clickSensitivity)
		{
			if(!IsInState('FollowMouse'))
			{
				RemoveMouseGroundTarget();
				GotoState('FollowMouse');
			}
			else
				GotoState('FollowMouse', 'Begin', false, true);
		}
	
	}
	else if(bRightMousePressed)
	{
		DeltaTimeAccumulated += DeltaTime;

		if(DeltaTimeAccumulated > 0.9f)
		{
			bRightMouseHold = true;
		}

	}
	if(!bRightMousePressed)
	{
		bAttackingSword = false;
		bRightMouseHold = false;
	}

	
	/*if(bBlocking && !bNotAbleToAttack)
	{
		GotoState('Blocking');
	}*/
	if(bBlocking)
	{
		GotoState('Blocking');
	}
}

auto state Idling
{
	ignores PlayerMove; //Ellers kjører PlayerMove non stop i bakgrunnen
	event BeginState(Name PreviousStateName)
	{
		if(heroPawn != none)
		{
			heroPawn.SetPhysics(PHYS_None);
			heroPawn.PlayAnimation('Idling');
		}
	}
	event EndState(Name NextStateName)
	{
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		//Make sure hero plays idle animation
		if(!heroPawn.animNodeSlot.bIsPlayingCustomAnim)
			heroPawn.PlayAnimation('Idling');

		if(bShouldInteract && bPawnNearDestination && !bNotAbleToAttack)
		{
			if(ToA_BaseItem(currentClickTarget) != none)
			{
				InstantRotateHeroTowardTarget(currentClickTarget.Location);
				InteractWithItem();
			}
			EndInteraction();

		}
		else if(bRightMouseHold && bPawnNearDestination && !bNotAbleToAttack)
		{
			heroPawn.SpecialAttackSword();
			bRightMouseHold = false;
			bRightMousePressed = false;
	
		}
	}
Begin:

}

state MoveMouseClick
{
	event BeginState(Name PreviousStateName)
	{
		if(heroPawn != none)
		{
			heroPawn.SetPhysics(PHYS_Walking);
			heroPawn.PlayAnimation('Walking');
		}
		//En timer som avslutter bevegelsen av seg selv hvis feks pawn sitter fast
		SetTimer(4, false, nameof(StopLingering));
	}
	event EndState(Name NextStateName)
	{
		if(IsTimerActive(nameof(StopLingering)))
			ClearTimer(nameof(StopLingering));
		RemoveMouseGroundTarget();
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);

		//if(heroPawn.animNodeSlot.GetPlayedAnimation() != 'Run')
			//heroPawn.PlayAnimation('Walking');
		if(!heroPawn.animNodeSlot.bIsPlayingCustomAnim)
			heroPawn.PlayAnimation('Walking');

		//If player hits a wall or an object in his way he should stop in his tracks.
		if(bHitObstacle)
		{
			GotoState('Idling');
			bPawnNearDestination = true;
			bHitObstacle = false;
		}
	}
Begin:
	while(!bPawnNearDestination)
	{
		MoveTo(GetDestinationPosition());
	}
	GotoState('Idling');
}

//Pawn følger slavisk etter musa
state FollowMouse
{
	event BeginState(Name PreviousStateName)
	{
		//Bool som sjekker om musa er over spiller, og i så fall skal ikke helten spille gå-anim eller ha Phys_Walking.
		bMouseAtHeroLoc = false;
		heroPawn.SetPhysics(PHYS_Walking);
		//For at animasjonen ikke begynner å spille på nytt om man allerede er i en move-state
		if(PreviousStateName != 'MoveMouseClick')
			heroPawn.PlayAnimation('Walking');
	}
	event EndState(Name NextStateName)
	{
		heroPawn.PlayAnimation('Idling');
		heroPawn.SetPhysics(PHYS_None);
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);

		if(!bLeftMousePressed)
			GotoState('Idling');
		if(bPawnNearDestination && !bMouseAtHeroLoc)
		{
			bMouseAtHeroLoc = true;
			heroPawn.PlayAnimation('Idling');
			heroPawn.SetPhysics(PHYS_None);
		}
		if(bPawnNearDestination)
		{
			//Denne funksjonen kjøres av PlayerMove, men iom helten står stille sjekkes den her for å evt iverksette at helten beveger seg igjen!
			if(!CheckPawnNearDestination(MouseHitWorldLocation))
				bPawnNearDestination = false;
		}
		if(!bPawnNearDestination && bMouseAtHeroLoc)
			GotoState(,'Begin', true);

		if(!heroPawn.animNodeSlot.bIsPlayingCustomAnim)
			heroPawn.PlayAnimation('Walking');
	}
Begin:
	if(!bPawnNearDestination)
	{
		MoveTo(GetDestinationPosition());
	}

}
//State som helten går inn i når han blir angrepet
state Dodge
{
	ignores PlayerMove;
	
	event PushedState()
	{
		bDodging = false;
		bNotAbleToAttack = true;
		heroPawn.SetPhysics(PHYS_None);
		//Sørger for at spilleren ikke fryser til det første 0.4 sek av denne staten (Se 'Begin')
		heroPawn.PlayAnimation('Idling');
	}
	event PoppedState()
	{
		bNotAbleToAttack = false;
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);

		if(bDodging)
		{
			if(heroPawn.animNodeSlot.GetPlayedAnimation() != 'Dodge')
				PopState();
		}
	}
Begin:
	//Venter litt med å spille dodge animasjon, for å time det bedre med angreps-animasjonen til fienden
	Sleep(0.4f);
	bDodging = true;
	heroPawn.PlayAnimation('Dodge');


}

state Attacking
{
	//Push staten når helten utfører de forskjellige animasjonene
	//Gjør så de ikke kan bli avbrutt, når staten har begynt så blir ikke helten påvirket av receive damage eller andre ting, men han kan flytte seg
	ignores PlayerMove;

	event PushedState()
	{
		bNotAbleToAttack = true;
		//`Log(currentAttackName);
		if(heroPawn != none)
		{
			heroPawn.SetPhysics(PHYS_None);
			heroPawn.PlayAnimation(currentAttackName);
		}
	}
	event PoppedState()
	{
		bNotAbleToAttack = false;
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
	
		if(heroPawn.animNodeSlot.GetPlayedAnimation() != currentAttackName)
		{
			PopState();
		}
		if(bLeftMousePressed)
			PopState();
		
	}
	
}
state Charge
{
	//Skal ikke kunne angripe eller gjøre andre handlinger mens han er i charge mode
	ignores StartAltFire, StartFire;
	event PushedState()
	{
		bNotAbleToAttack = true;
		bDoneCharging = false;
		if(heroPawn != none)
		{
			heroPawn.SetPhysics(PHYS_Walking);
			heroPawn.PlayAnimation('ChargeRun');
			heroPawn.GroundSpeed = 500.0f;
		}
		SetTimer(2, false, nameof(StopLingering));
	}
	event PoppedState()
	{
		`Log("Popped State of Charge!!");
		bNotAbleToAttack = false;
		if(IsTimerActive(nameof(StopLingering)))
			ClearTimer(nameof(StopLingering));
		heroPawn.GroundSpeed = 160.0f;
	}
	event EndState(Name NextStateName)
	{
		bNotAbleToAttack = false;
		if(IsTimerActive(nameof(StopLingering)))
			ClearTimer(nameof(StopLingering));
		heroPawn.GroundSpeed = 160.0f;
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
	
		if(bPawnNearDestination)
		{
			if(!bDoneCharging)
			{
				heroPawn.SetPhysics(PHYS_None);
				heroPawn.ChargeAttackSwordHit();
				bDoneCharging = true;
			}
		}
		if(bDoneCharging && heroPawn.animNodeSlot.GetPlayedAnimation() != 'ChargeAttack')
		{
			GotoState('Idling');
		}
		
	}
Begin:
	while(!bPawnNearDestination)
	{
		MoveTo(GetDestinationPosition());
	}
}

state Blocking
{
	//ignores PlayerMove, StartAltFire, StartFire;
	ignores PlayerMove;

	event BeginState(Name PreviousStateName)
	{
		bNotAbleToAttack = true;
		lastState = PreviousStateName;
		bDoneBlocking = false;
		if(heroPawn != none)
		{
			heroPawn.SetPhysics(PHYS_None);
			heroPawn.PlayAnimation('BlockUp');
		}
	}
	event EndState(Name NextStateName)
	{
		bNotAbleToAttack = false;
	}
	event PlayerTick(float DeltaTime)
	{
		//Global.PlayerTick(DeltaTime);
	
		if(bBlocking && !heroPawn.animNodeSlot.bIsPlayingCustomAnim)
		{
			heroPawn.PlayAnimation('BlockHold');
		}
		else if(!bBlocking && !bDoneBlocking)
		{
			heroPawn.PlayAnimation('BlockRelease');
			bDoneBlocking = true;
		}
		else if(bDoneBlocking && heroPawn.animNodeSlot.GetPlayedAnimation() != 'BlockRelease')
		{
			GotoState(lastState);
		}

	}
Begin:
}

state ReceiveDamage
{
	ignores PlayerMove;
	
	event PushedState()
	{
		bNotAbleToAttack = true;
		bReceivingDmg = false;
		heroPawn.SetPhysics(PHYS_None);
		heroPawn.PlayAnimation('Idling');
	}
	event PoppedState()
	{
		bNotAbleToAttack = false;
	}
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);

		if(bReceivingDmg)
		{
			if(heroPawn.animNodeSlot.GetPlayedAnimation() != 'ReceiveDamage')
				PopState();
		}
		if(bLeftMousePressed)
			PopState();
	}
Begin:
	Sleep(0.4f);
	bReceivingDmg = true;
	heroPawn.PlayAnimation('ReceiveDamage');

}
state Death
{
	ignores PlayerMove, StartAltFire, StartFire;
	event BeginState(Name PreviousStateName)
	{
		heroPawn.SetPhysics(PHYS_None);
		heroPawn.PlayAnimation('Death');
	}
	event EndState(Name NextStateName)
	{
	}
	event PlayerTick(float DeltaTime)
	{
		if(!heroPawn.animNodeSlot.bIsPlayingCustomAnim)
		{
			deathMenu = new class'ToA_DeathMenu'; 
			deathMenu.gameRef = ToA_GameInfo(WorldInfo.Game);
			deathMenu.currentLevel = ToA_GameInfo(WorldInfo.Game).currentLevel;
			deathMenu.MovieInfo = SwfMovie'ScaleformMenuGFx.SFMFrontEnd.AtroxDeathMenu'; 
			deathMenu.Start();
		}
	}
}

exec function StartShieldBlock()
{
	if(heroPawn.GetOffhand() != none)
		bBlocking = true;
}
exec function StopShieldBlock()
{
	bBlocking = false;
}

function SpecialAttackSword()
{
	heroPawn.SpecialAttackSword();
}

function AttackWithSword()
{	
	if(!bAttackingSword)
	{
		bAttackingSword = true;
		heroPawn.AttackWithSword();
	}
}

exec function use()
{
	UsePotion();
}

function UsePotion()
{
	if(heroPawn.pawnInventory != none)
		heroPawn.pawnInventory.SpendPotion();
}

function UseEnergyPotion()
{
	if(heroPawn.pawnInventory != none)
		heroPawn.pawnInventory.SpendEnergyPotion();
}

function bool EquipTorchMainHand()
{
	
	if(heroPawn.AttachInventory('ToA_InventoryTorch'))
	{
		bTorchEquipped = true;
		return true;
	}
	`Log("TORCH IS NOT EQUIPPED @GameplayerController EquipTorchToMainHand");
	return false;
}

function bool EquipSwordMainHand()
{
	if(heroPawn.AttachInventory('ToA_InventorySword'))
	{
		bTorchEquipped = false;
		return true;
	}
	`Log("Sword is NOT equipped @ GPC - EquipSWordMainhand");
	return false;
}

function bool EquipShieldOffHand()
{
	if(heroPawn.AttachInventoryOffhand('ToA_InventoryShield'))
	{
		return true;
	}
	`Log("Shield is NOT equipped");
	return false;
}

function InteractWithItem()
{
	if(ToA_Burnable(currentClickTarget) != none)
	{
		if(bTorchEquipped && !bUsingTorch)
		{
			heroPawn.UseTorch(ToA_Burnable(currentClickTarget));
			bUsingTorch = true;
		}
	}
	else
	{
		heroPawn.Interact(ToA_BaseItem(currentClickTarget));
	}
}

function EndInteraction()
{
	bUsingTorch = false;
	bShouldInteract = false;
}

exec function StartCharge()
{
	RemoveMouseGroundTarget();
	DeltaTimeAccumulated = 0;
	bOneButtonPressed = true;
}
exec function StopCharge()
{
	bOneButtonPressed = false;

	if(ToA_BaseEnemy(currentClickTarget) != none)
	{
		if(VSize(currentClickTarget.Location - Pawn.Location) < chargeRangeMax && VSize(currentClickTarget.Location - Pawn.Location) > chargeRangeMin)
		{
			bPawnNearDestination = false;
			SetDestinationPosition(currentClickTarget.Location);
			heroPawn.ChargeAttackRun();
		}
	}
}

exec function CycleThroughEnemies()
{
	local ToA_BaseEnemy nmy;
	local int j;

	enemiesNearby.Length = 0;
	//Denne er raskere enn feks AllActors() og DynamicActors fordi den søker med collisjon, og i tillegg tar den bare en viss radius, som er det jeg er ute etter her
	foreach VisibleCollidingActors(class'ToA_BaseEnemy', nmy, cycleEnemiesRadius, heroPawn.Location)
	{
		if(FastTrace(nmy.Location, heroPawn.Location, vect(1,1,1),true))
		{
			enemiesNearby[enemiesNearby.Length] = nmy;
		}
	}
	//`Log("Dette er fiender nearby length:"@enemiesNearby.Length);
	for(j=0; j<enemiesNearby.Length; j++)
	{
		if(enemiesNearby[j] != currentClickTarget)
		{
			if(ToA_BaseEnemy(currentClickTarget) != none)
				ToA_BaseEnemy(currentClickTarget).OnMouseClickAway();
			enemiesNearby[j].OnMouseClick();
			currentClickTarget = enemiesNearby[j];
			return;
		}
	}

}

//Høyre musetast
exec function StartFire(optional byte FireModeNum)
{
	DeltaTimeAccumulated = 0;
	bRightMousePressed = true;
	bLeftMousePressed = false;

	RemoveMouseGroundTarget();
	DeltaTimeAccumulated = 0;

	//CheckIfMouseClickActor();
}

exec function StopFire(optional byte FireModeNum)
{
	bRightMousePressed = false;
	DeltaTimeAccumulated = 0;

	if(!bAttackingSword)
	{
		AttackWithSword();
		bAttackingSword = true;
	}
}

//Venstre musetast
exec function StartAltFire(optional byte FireModeNum)
{
	RemoveMouseGroundTarget();
	DeltaTimeAccumulated = 0;

	CheckIfMouseClickActor();
	bRightMousePressed = false;

	//Må ha gulv som target for å kunne velge nytt mål å bevege seg mot
	if(ToA_Floor(TraceActor) != none)
	{
		bPawnNearDestination = false;
		//bPreciseDestination = True;
		SpawnMousePointer();
		bLeftMousePressed = true;
		SetDestinationPosition(MouseHitWorldLocation);
	}
	else if(ITargetInterface(TraceActor) != none)
	{
		bPawnNearDestination = false;
		bLeftMousePressed = true;
		SetDestinationPosition(MouseHitWorldLocation);
	}
}

exec function StopAltFire(optional byte FireModeNum)
{
	if(bLeftMousePressed)
	{
		bLeftMousePressed = false;
		
		//IF(FastTrace(MouseHitWorldLocation, heroPawn.Location, vect(1,1,1) ,true))
		//{
			if(!bPawnNearDestination && DeltaTimeAccumulated < clickSensitivity)
				GotoState('MoveMouseClick');
		//}
        DeltaTimeAccumulated = 0;
	}
}

exec function ToggleCharSheet()
{
	customHud.HudMovie.ToggleCharSheet();
}

exec function ToggleInventory()
{
	customHud.HudMovie.ToggleInventory();
}

function PlayerMove(float DeltaTime)
{
	local Vector Destination;

	if(bPawnNearDestination)
		return;
	
	super.PlayerMove(DeltaTime);

	Destination = GetDestinationPosition();
	RotatePawnTowardsTarget(DeltaTime, Destination);

	bPawnNearDestination = CheckPawnNearDestination(Destination);
}

function bool CheckPawnNearDestination(Vector finalDest)
{
	local float distanceRemaining;
	local Vector2D distanceCheck;
	local float minDistance;

	//Setter minDistance til litt unna, ellers når aldri Pawnen målet. Hvis jeg bruker bPreciseDestination = true så når han målet til slutt, men slower ned en del før han kommer fram, og det passet ikke til spillet.
	minDistance = 30.0f;
	
	distanceCheck.X = finalDest.X - Pawn.Location.X;
	distanceCheck.Y = finalDest.Y - Pawn.Location.Y;
	distanceRemaining = Sqrt((distanceCheck.X * distanceCheck.X) + (distanceCheck.Y * distanceCheck.Y));

	return distanceRemaining <= minDistance;
}

//Snur Pawn-en mot destinasjonen med interpolation.
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
		rotSpeed = 7.0f * DeltaTime;
		newRotation = RLerp(Pawn.Rotation, DesiredPawnRotation, rotSpeed, true);
		Pawn.SetRotation(NewRotation);
	}

}

//Idet helten skal til å plukke opp noe eller bruke en gjenstand, så må han snus direkte mot gjenstanden, ellers har han en tendens til å ikke rekke snu seg før interact-animasjonen spilles. Og det ser jo bare teit ut.
function InstantRotateHeroTowardTarget(Vector dest)
{
	local Rotator desiredPawnRotation;
	desiredPawnRotation = Rotator(dest - Pawn.Location);
	desiredPawnRotation.Pitch = Pawn.Rotation.Pitch;
	desiredPawnRotation.Roll = Pawn.Rotation.Roll;

	if(Pawn.Rotation != desiredPawnRotation)
	{
		Pawn.SetRotation(desiredPawnRotation);
	}
}

/** Sets bPawnNearDestination = true, in cases where the pawn has gotten stuck and we want him to stop moving. Called by timer. */
function StopLingering()
{
	bPawnNearDestination = true;
}

/** Removes the target marker on the ground. */
function RemoveMouseGroundTarget()
{
	if(MoveLocationPointer != none)
	{
		MoveLocationPointer.Destroy();
		MoveLocationPointer = none;
	}
}

/** Spawns the target marker on the ground where the player has clicked to move. */
function SpawnMousePointer()
{
	local Vector MovePointerSpawnPos;
	MovePointerSpawnPos = MouseHitWorldLocation;
	MovePointerSpawnPos.Z += 2.6f; //Spawner den litt over bakken så den ikke blir overlappa med bakkegrafikken
	MovePointerSpawnPos.X += 30.0f;//Må flytte litt på den så grafikken er midtstilt med der musa klikker.
	MoveLocationPointer = Spawn(class'ToA_MovePointer', self, 'MovePointer', MovePointerSpawnPos);
}

/** Checks if the player has moused over a relevant actor, and if so, sets the currentHoverTarget to this actor, calls OnMouseOver() in the actor, and tells the hud to display any tool tip linked to this actor. */
function CheckIfMouseOverActor()
{
	if(ITargetInterface(TraceActor) != none)
	{
		if(!ITargetInterface(TraceActor).IsActorHoveredOver() && !ITargetInterface(TraceActor).CheckActorDestroyed())
		{
			SetupTooltips(ITargetInterface(TraceActor));
			currentHoverTarget = TraceActor;
			ITargetInterface(TraceActor).OnMouseOver();
		}
	}
}

/** Calls DisplayTooltip in the hud class, which checks if the object hovered over has a tool tip texture that it should display on the hud. */
function SetupTooltips(ITargetInterface obj)
{
	if(customHud != none)
		customHud.DisplayTooltip(true, obj.GetTooltipTexture());
}

/** Checks if the player has moused off an actor. If so, sets currentHoverTarget to none, calls OnMouseAway() on the actor, and tells the hud not to display the tooltip anymore. */
function CheckIfMouseOffActor()
{
	if(TraceActor != currentHoverTarget && currentHoverTarget != none)
	{
		if(ITargetInterface(currentHoverTarget) != none)
			ITargetInterface(currentHoverTarget).OnMouseAway();

		currentHoverTarget = none;
		customHud.DisplayTooltip(false);
	}
}

/** Checks if the player has clicked on an actor. If so, sets currentClickTarget to this actor, and takes care of calling the correct click function on the previous clickTarget as well as the new. */
function CheckIfMouseClickActor()
{
	if(currentHoverTarget != none)
	{
		if(currentClickTarget != none && currentClickTarget != currentHoverTarget)
		{
			if(ITargetInterface(currentClickTarget) != none)
				ITargetInterface(currentClickTarget).OnMouseClickAway();
		}
	
		if(ITargetInterface(currentHoverTarget) != none)
			ITargetInterface(currentHoverTarget).OnMouseClick();

		currentClickTarget = currentHoverTarget;
	}
	else
	{
		if(currentClickTarget != none)
		{
			if(ITargetInterface(currentClickTarget) != none)
				ITargetInterface(currentClickTarget).OnMouseClickAway();

		}
		currentClickTarget = none;
	}
}

/** If the player has pressed either A or D, this function rotates the camera to that effect. */
function CheckRotateCamera()
{
	if(bRotateLeft)
		ToA_Camera(PlayerCamera).rotateAdjust -= cameraRotationSpeed * DegToRad;
	else if(bRotateRight)
		ToA_Camera(PlayerCamera).rotateAdjust += cameraRotationSpeed * DegToRad;
}
/** If the player presses down the middle mouse button, this function calculates the mouse X-rotation and tells the camera class to rotate accordingly. */
function RotateCameraIfMiddleMouseButtonPressed()
{
	if(bMouseMiddleCheck == true)
	{
		mouseTotalXRotation = mouseCurrentRotation.X - PlayerMouse.X;
		mouseTotalXRotation = mouseTotalXRotation / 100;
		ToA_Camera(PlayerCamera).rotateAdjust -= mouseTotalXRotation;
	}
	else if(bMouseMiddleCheck == false)
	{
		mouseCurrentRotation.X = PlayerMouse.X;
	}
}

/** This function was ment to be used to change between Isometric camera view and first person view, but so far has not been implemented. */
exec function SetDesiredCameraMode()
{
	bCamIsIso = !bCamIsIso;
}

/** The middle mouse button is pressed. */
exec function MiddleMouseRotate()
{
	bMouseMiddleCheck = true;
}
/** The middle mouse button is not pressed anymore. */
exec function MiddleMouseRotateStop()
{
	bMouseMiddleCheck = false;
}
/** The A keyboard button is pressed. */
exec function StartRotateLeft()
{
	bRotateLeft = true;
}
/** The A keyboard button is not pressed anymore. */
exec function StopRotateLeft()
{
	bRotateLeft = false;
}
/** The D keyboard button is pressed. */
exec function StartRotateRight()
{
	bRotateRight = true;
}
/** The D keyboard button is not pressed anymore. */
exec function StopRotateRight()
{
	bRotateRight = false;
}
/** This function overrides the base class version, if not the default version will mess up the "isometric" camera. */
function UpdateRotation( float DeltaTime )
{
	if(!bCamIsIso)
		super.UpdateRotation(DeltaTime);
}
/** This function overrides the base class version, if not the default version will mess up the "isometric" camera. */
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	//Overrider camera settings
}
/** This function overrides the base class version, if not the default version will mess up the "isometric" camera. */
function ProcessViewRotation( float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot )
{
	if(!bCamIsIso)
		super.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
}
/** Player has pressed the escape key to exit to menu. */
exec function QuitGame()
{
	//ConsoleCommand("Exit");
	//ConsoleCommand("open TowerOfAtrox_MainMenu");
	escapeMenu = new class'ToA_EscMenu'; 
	escapeMenu.gameRef = ToA_GameInfo(WorldInfo.Game);
	escapeMenu.MovieInfo = SwfMovie'ScaleformMenuGFx.SFMFrontEnd.AtroxMenu'; 
	escapeMenu.Start();
}
/** Player has pressed the R key to use energy pot. */
exec function RestartGame()
{
	UseEnergyPotion();
	//ConsoleCommand("open ?restart");
}
/** Zoom in. */
exec function NextWeapon()
{
	if(!bCamIsIso)
		return;
	//Denne begrenses i kameraklassen slik at man ikke kan zoome inn uendelig
	PlayerCamera.FreeCamDistance += 64;
}
/** Zoom out. */
exec function PrevWeapon()
{
	if(!bCamIsIso)
		return;
	//Denne begrenses i kameraklassen slik at man ikke kan zoome ut uendelig
	PlayerCamera.FreeCamDistance -= 64;

}

DefaultProperties
{
	CameraClass=class'ToA_Camera'
	InputClass=class'MouseInterfacePlayerInput'
	bCamIsIso=true
	clickSensitivity=0.30f

	swordAttackDistance=60
	bAttackingSword=false
	bAttackingMagic=false

	castingTime=1.5f

	cycleEnemiesRadius=400.0f
	cameraRotationSpeed=200.0f

	chargeRangeMax=600.0f
	chargeRangeMin=200.0f

}