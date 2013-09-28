class ToA_Pawn extends Pawn;

struct ToA_Pawn_SaveData
{
	var Vector location;
	var Rotator rotation;
	var int HP, maxHP, strength, defence, level, currentXP, minDMG, maxDMG;
	var bool torchEquipped, swordEquipped, shieldEquipped, bAttack;

};

var ToA_Pawn_SaveData data;

var int heroHealth, heroMaxHealth, heroStrength, heroDefence, heroCurrentLevel, heroMaxLevel, heroCurrentXp, xpToNextLevel, heroDmgMin, heroDmgMax, DamageAmount;

var ToA_Energy heroEnergy;

var bool bAttacking, bDead;

var ToA_PointLight pawnLight;

var AnimNodeSlot animNodeSlot;

var class<ToA_InventoryManager>	invManagerClass;
var repnotify ToA_InventoryManager pawnInventory;

var int SwingsLeft;
var const int MaxSwings;
var float SwingCooldown;

var Name currentAnim;
var int specialAttackBonusDmg;
var ATROXHUD customHud;
var ToA_InventoryItem mainhand;
var ToA_InventoryItem offhand;

function UpdateStruct()
{
	data.location = self.Location;
	data.rotation = self.Rotation;
	data.HP = heroHealth;
	data.maxHP = heroMaxHealth;
	data.currentXP = heroCurrentXp;
	data.defence = heroDefence;
	data.strength = heroStrength;
	data.level = heroCurrentLevel;
	data.maxDMG = heroDmgMax;
	data.minDMG = heroDmgMin;
	data.shieldEquipped = ToA_InventoryShield(offhand) != none;
	data.swordEquipped = ToA_InventorySword(mainhand) != none;
	data.torchEquipped = ToA_InventoryTorch(mainhand) != none;
	data.bAttack = bAttacking;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(0.1, false, 'SetWorldVariables');

	//Setter opp InventoryManager
    if (invManagerClass != None)
	{
		pawnInventory = Spawn(invManagerClass, Self);
		if (pawnInventory == None )
			`log("Klarte ikke spawne" @ invManagerClass @ "for" @ Self @  GetHumanReadableName() );

	}

	heroEnergy = Spawn(class'ToA_Energy', self);

	AttachInventory('ToA_InventorySword');

}

function SetWorldVariables()
{
	customHud = ToA_GameInfo(WorldInfo.Game).hudWorld;
}

simulated event Destroyed()
{
	super.Destroyed();

	animNodeSlot = none;
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	animNodeSlot = AnimNodeSlot(SkelComp.FindAnimNode('HeroAnimSlot'));
}

/*
 * Denne funksjonen returnerer kamera modus som denne pawnen
 * vil ha, i dette tilfellet 'Isometric', til PlayerController-klassen
 * som kaller funksjonen idet den possesser pawnen
 */
simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
	return 'Isometric';
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	//`Log("Mainhand weapon:"@mainhand);

}

function PlayAnimation(Name animName)
{
	//if(!bDead)
	//{
		switch(animName)
		{
			case 'Looking': animNodeSlot.PlayCustomAnim('Idle',  1.f, 0.3f, 0.3f, false, true);
				break;
			case 'Idling': animNodeSlot.PlayCustomAnim('Idle',  1.f, 0.3f, 0.3f, true, true);
				break;
			case 'Walking': animNodeSlot.PlayCustomAnim('Run',  1.0f, 0.3f, 0.3f, true, true);
				break;
			case 'Attacking': animNodeSlot.PlayCustomAnim('Attacking',  1.f, 0.3f, 0.3f, false, true);
				break;
			case 'ReceiveDamage': animNodeSlot.PlayCustomAnim('ReceiveDamage', 1.f, 0.3f, 0.3f, false, true);
				break;
			case 'Death': animNodeSlot.PlayCustomAnim('Death', 1.0f, 0.3f, 0.2f, false, true);
				break;
			case 'UseTorch': animNodeSlot.PlayCustomAnim('UseTorch', 1.0, 0.3f, 0.2f, false, true);
				break;
			case 'ChargeAttack': animNodeSlot.PlayCustomAnim('ChargeAttack', 1.0, 0.1f, 0.1f, false, true);
				break;
			case 'ChargeRun': animNodeSlot.PlayCustomAnim('ChargeRun', 2.0f, 0.1f,0.2f, true, true);
				break;
			case 'SecondAttack': animNodeSlot.PlayCustomAnim('SecondAttack', 1.0f, 0.3f, 0.3f, false, true);
				break;
			case 'Interact': animNodeSlot.PlayCustomAnim('Interact', 1.5f, 0.1f, 0.2f, false, true);
				break;
			case 'BlockRelease': animNodeSlot.PlayCustomAnim('BlockRelease', 1.5f, 0.1f, 0.2f, false, true);
				break;
			case 'BlockUp': animNodeSlot.PlayCustomAnim('BlockUp', 1.5f, 0.1f, 0.2f, false, true);
				break;
			case 'BlockHold': animNodeSlot.PlayCustomAnim('BlockHold', 1.5f, 0.1f, 0.2f, true, true);
				break;
			case 'Dodge':animNodeSlot.PlayCustomAnim('Dodge', 1.0f, 0.1f, 0.1f, false, true);
				break;
			case 'PowerAttack': animNodeSlot.PlayCustomAnim('PowerAttack', 1.0f, 0.2f, 0.2f, false, true);
				break;
			case 'Died': animNodeSlot.PlayCustomAnim('Died', 1.0f, 0.2f, 0.2f, true, true);
				break;
			default:
				break;
		}
	//}
}
function StopAnimation()
{
	animNodeSlot.StopCustomAnim(0);
}
function bool IsHeroDead()
{
	return bDead;
}

function bool AttachInventory(name className)
{
	if(pawnInventory != none)
	{
		if(pawnInventory.CheckInventoryFor(className) != none)
		{
			if(mainhand != none)
			{
				mainhand.PutAwayItem(self);
			}
			mainhand = pawnInventory.CheckInventoryFor(className);
			mainhand.EquipItemToOwner(self);
			//customHud.combatLog.AddEntriesToLog("Hero sucessfully equipped the item!");
			return true;
		}
		else
			`Log("Item not found in inventory!");
	}
	`Log("Something went wrong in Pawn->AttachInventory()");
	return false;
}

function bool AttachInventoryOffhand(name className)
{
	if(pawnInventory != none)
	{
		if(pawnInventory.CheckInventoryFor(className) != none)
		{
			if(offhand != none)
			{
				mainhand.PutAwayItem(self);
			}
			offhand = pawnInventory.CheckInventoryFor(className);
			offhand.EquipItemToOwner(self);
			//customHud.combatLog.AddEntriesToLog("Hero sucessfully equipped the offhand!");
			return true;
		}
		else
			`Log("Item not found in inventory!");
	}
	`Log("Something went wrong in Pawn->AttachInventory()");
	return false;
}

function int GenerateRandomInt(int min, int max)
{
	local int diff;
	local int val;
	diff = max - min;
	val = Rand(diff) + min;

	return val;
}

function bool IsHeroDodging()
{
	local int chanceToDodge;
	chanceToDodge = GenerateRandomInt(0, 100);

	chanceToDodge += heroDefence;

	if(chanceToDodge >= 90)
	{
		customHud.combatLog.AddEntriesToLog("Hero dodged the attack!");
		return true;
	}
	else
		return false;

}

function int GenerateDamageForCurrentAttack()
{
	local int dieRollDmg;

	dieRollDmg = GenerateRandomInt(heroDmgMin, heroDmgMax);

	dieRollDmg += heroStrength;	

	return dieRollDmg;
}

function HeroAddXP(int xp)
{
	heroCurrentXp += xp;

	if(heroCurrentXp >= xpToNextLevel)
	{
		HeroAddLevel();
	}
}

function int HeroGetLevel()
{
	return heroCurrentLevel;
}

function HeroAddLevel()
{
	heroCurrentLevel += 1;
	if(heroCurrentLevel == 2)
		customHud.HudMovie.ShowChargeButton();
	IncreaseXpToNextLevel(heroCurrentLevel);
	IncreaseStatsForNextLevel();
	customHud.combatLog.AddEntriesToLog("Hero leveled up! Hero is now level"@string(heroCurrentLevel)$".");
	customHud.combatLog.AddEntriesToLog("Check out the character sheet!");
}

function IncreaseStatsForNextLevel()
{
	heroMaxHealth = CalculateStatIncrease(heroMaxHealth);
	//Får fullt liv når man levler?
	heroHealth = heroMaxHealth;
	
	heroStrength = CalculateStatIncrease(heroStrength);
    heroDefence = CalculateStatIncrease(heroDefence);

	heroDmgMin = CalculateStatIncrease(heroDmgMin);
	heroDmgMax = CalculateStatIncrease(heroDmgMax);
}

function AddStatPoint(string statType, int statIncrease)
{
	switch(statType)
	{
	case "Strength":
		heroStrength += statIncrease;
		break;
	case "Health":
		heroMaxHealth += statIncrease;
		break;
	default:
		break;
	}
}

//Øker stats med en tredjedel av hva helten har fra før - midlertidig
function int CalculateStatIncrease(int stat)
{
	local int val;

	val = stat;
	val += Round(val/3);
	return val;
}

function IncreaseXpToNextLevel(int level)
{
	switch(level)
	{
		case 1: xpToNextLevel = 100;
				heroCurrentXp = 0;
				break;
		case 2: xpToNextLevel = 200;
				heroCurrentXp = 0;
				ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.ShowPopupDisplay("Charge");
				break;
		case 3: xpToNextLevel = 400;
				heroCurrentXp = 0;
				ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.ShowPopupDisplay("SpecialAttack");
				break;
		case 4: xpToNextLevel = 800;
				heroCurrentXp = 0;
				break;
		case 5: break;
		default: break;
	}
}

function bool IsFullHealth()
{
	return heroHealth == heroMaxHealth;
}

function ReceiveDamage(int Dmg)
{
	local ToA_GamePlayerController PC;
	PC = ToA_GamePlayerController(Owner);

	if(!PC.bNotAbleToAttack)
	{
		if(!IsHeroDodging())
		{
			if(heroHealth - Dmg > 0)
			{
				ToA_GamePlayerController(Owner).PushState('ReceiveDamage');
				heroHealth -= Dmg;
				customHud.combatLog.AddEntriesToLog("Hero received"@Dmg@"points of damage!");
			}	
			else
			{
				heroHealth = 0;
				bDead = true;
				ToA_GameInfo(WorldInfo.Game).AddTimesDied();
				customHud.combatLog.AddEntriesToLog("Hero died!");
				ToA_GamePlayerController(Owner).GotoState('Death');
				//PlayAnimation('Death');
			}
		}
		else
		{
			ToA_GamePlayerController(Owner).PushState('Dodge');
		}
	}
}

function UseTorch(ToA_Burnable item)
{
	PlayAnimation('UseTorch');
	item.InteractWithActor(self);

}

function Interact(ToA_BaseItem item)
{
	PlayAnimation('Interact');
	item.InteractWithActor(self);
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	if(ITargetInterface(Other) != none || ToA_Wall(Other) != none)
	{
		`Log("Walked into a wall...Aborting move");
		ToA_GamePlayerController(Owner).bHitObstacle = true;
	}
}

function SpecialAttackSword()
{
	local ToA_GamePlayerController PC;
	local int energyCost;
	PC = ToA_GamePlayerController(Owner);
	energyCost = 30;

	if(heroCurrentLevel >= 3)
	{
		if(!PC.bNotAbleToAttack && mainhand != none)
		{
			if(heroEnergy.CheckIfEnoughEnergy(energyCost))
			{
				heroEnergy.UseEnergyPoints(energyCost);
				DamageAmount = GenerateDamageForCurrentAttack();
				DamageAmount += specialAttackBonusDmg;
				ToA_InventoryWeapon(mainhand).SwingSword(DamageAmount);
				currentAnim = 'PowerAttack';
				PC.currentAttackName = currentAnim;
				PC.PushState('Attacking');
			}
		}
	}
}

function ChargeAttackRun()
{
	local ToA_GamePlayerController PC;
	local int energyCost;
	PC = ToA_GamePlayerController(Owner);
	energyCost = 25;

	if(heroCurrentLevel >= 2)
	{
		if(heroEnergy.CheckIfEnoughEnergy(energyCost))
		{
			heroEnergy.UseEnergyPoints(energyCost);
			PC.PushState('Charge');
		}
	}
	
}

function ChargeAttackSwordHit()
{
	local ToA_GamePlayerController PC;
	PC = ToA_GamePlayerController(Owner);

	if(mainhand != none)
	{
		PlayAnimation('ChargeAttack');
		currentAnim = 'ChargeAttack';
		PC.currentAttackName = currentAnim;
		DamageAmount = GenerateDamageForCurrentAttack();
		ToA_InventoryWeapon(mainhand).SwingSword(DamageAmount);
	}
}


function AttackWithSword()
{
	local ToA_GamePlayerController PC;
	local int energyCost;
	PC = ToA_GamePlayerController(Owner);
	energyCost = 20;

	if(!PC.bNotAbleToAttack && mainhand != none)
	{
		
		if(heroEnergy.CheckIfEnoughEnergy(energyCost))
		{
			if(HasSwingsLeft())
			{
				heroEnergy.UseEnergyPoints(energyCost);
				
				DamageAmount = GenerateDamageForCurrentAttack();
				ToA_InventoryWeapon(mainhand).SwingSword(DamageAmount);
				
				if(MaxSwings - SwingsLeft == 0)
				{
					currentAnim = 'Attacking';
					PC.currentAttackName = currentAnim;
					PC.PushState('Attacking');
					SwingsLeft -= 1;
				}
				else if(MaxSwings - SwingsLeft == 1)
				{
					currentAnim = 'SecondAttack';
					PC.currentAttackName = currentAnim;
					PC.PushState('Attacking');
					SwingsLeft -= 1;
			
					SetTimer(SwingCooldown, false, 'RestoreSwings');
				}
			}
		}

	}

}

/*function AttackFireball(ToA_BaseEnemy victim)
{
	local ToA_Fireball fireball;

	fireball = Spawn(class'ToA_Fireball', self,, Location,,,true); //På location skal settes in slot i hånda feks

	DamageAmount = GenerateDamageForCurrentAttack();

	fireball.Attack(victim, DamageAmount);

}*/

function ToA_InventoryItem GetMainhand()
{
	return mainhand;
}

function ToA_InventoryItem GetOffhand()
{
	return offhand;
}

function RestoreSwings()
{
	SwingsLeft = MaxSwings;
}

function bool HasSwingsLeft()
{
	return SwingsLeft > 0;
}

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
}

DefaultProperties
{
	Components.Remove(Sprite)
	bBlockActors=true
	BlockRigidBody=true
	bCollideActors=true

	begin object class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		ModShadowFadeoutTime=0.25
		MinTimeBetweenFullUpdates=0.2
		AmbientGlow=(R=.01,G=.01,B=.01,A=1)
		AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
		bSynthesizeSHLight=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=SkeletalMeshComponent name=MySkeletalMeshComponent
		CastShadow=true
		bCastDynamicShadow=true
		bCacheAnimSequenceNodes=false
		//DepthPriorityGroup=SDPG_Foreground
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
		Scale3D=(X=1,Y=1,Z=1)
		AnimSets(0)=AnimSet'ToA_Hero.AnimSets.Hero_AnimSet2'
		AnimTreeTemplate=AnimTree'ToA_Hero.AnimTrees.Hero_AnimTree2'
		SkeletalMesh=SkeletalMesh'ToA_Hero.Meshes.Hero_SkelMesh2'
	end object
	Mesh=MySkeletalMeshComponent
	//CollisionComponent=MySkeletalMeshComponent
	Components.Add(MySkeletalMeshComponent)

	//Når man overrider en component som finnes i klassen fra før, så kutter man ut å spesifisere en klasse
	begin object Name=CollisionCylinder
		CollisionRadius=20.0
		CollisionHeight=40.0
		//Begge må være false
		BlockNonZeroExtent=false
		BlockZeroExtent=false
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	//InventoryManagerClass=class'ToA_InventoryManager'

	heroHealth=40;
	heroMaxHealth=40;
	heroStrength=6
	heroDefence=10

	heroCurrentLevel=1
	heroMaxLevel=10

	heroCurrentXp=0
	xpToNextLevel=100

	heroDmgMin=1
	heroDmgMax=10
	specialAttackBonusDmg=10.0f

	GroundSpeed=160.0f

	bCanPickUpInventory = true
    invManagerClass = ToA_InventoryManager

	MaxSwings=2
	SwingsLeft=2
	SwingCooldown=1.8f


}
