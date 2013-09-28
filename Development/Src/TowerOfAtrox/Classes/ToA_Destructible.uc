/*
 * Klasse av objekter som kan knuses. Takk til evernewjoy på UDK forum for tutorial
 * (http://forums.epicgames.com/threads/925559-How-to-Spawn-Apex-Destructible-and-Set-Material-using-UnrealScript)
 */
class ToA_Destructible extends ApexDestructibleActorSpawnable implements(ITargetInterface)
	abstract;

struct Destructible_SaveData
{
	var bool bDestroyed;
};

var Destructible_SaveData data;

var bool bIsTargeted;
var bool bIsHoveredOver;
var bool bIsDestroyed;
var() const float distanceToUse;
var AudioComponent smashSound;

var const Texture2D tooltipTexture;

var Material outside, inside;

function UpdateStruct()
{
	data.bDestroyed = bIsDestroyed;
}

function ApexSetMaterial(Material outsideMat, Material insideMat) 
{
	if (outsideMat == None || insideMat == None) 
	{
		`log("invalid materials");
		return;
	}
	
	StaticDestructibleComponent.SetMaterial(0, outsideMat);
	StaticDestructibleComponent.SetMaterial(1, insideMat);
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	smashSound.Play();

	StaticDestructibleComponent.SetActorCollision(false, false);
	StaticDestructibleComponent.SetBlockRigidBody(false);
	StaticDestructibleComponent.SetNotifyRigidBodyCollision(false);

	bIsDestroyed = true;
	UpdateStruct();

	SetTimer(5.0f, false,'SelfDestroy');
}

function SelfDestroy()
{
	Destroy();
}

function MakeMaterialBrighter()
{
	ApexSetMaterial(outside, inside);
}
function MakeMaterialNormal()
{
	ApexSetMaterial(outside, inside);
}

function InteractWithActor(ToA_Pawn hero)
{
}

function float GetInteractDistance()
{
	return distanceToUse;
}

function OnMouseOver()
{
	bIsHoveredOver = true;
	MakeMaterialBrighter();
}

function OnMouseAway()
{
	bIsHoveredOver = false;
	if(!bIsTargeted)
	{
		MakeMaterialNormal();
	}

}

function OnMouseClick()
{

	bIsTargeted = true;
	MakeMaterialBrighter();

}

function OnMouseClickAway()
{
	bIsTargeted = false;
	MakeMaterialNormal();

}

function bool IsActorTargeted()
{
	return bIsTargeted;
}

function bool IsActorHoveredOver()
{
	return bIsHoveredOver;
}

function bool CheckActorDestroyed()
{
	return bIsDestroyed;
}

function Texture2D GetTooltipTexture()
{
	return tooltipTexture;
}

DefaultProperties
{
}
