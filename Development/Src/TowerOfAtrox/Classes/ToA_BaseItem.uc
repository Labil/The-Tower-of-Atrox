/*
 * Parent class for alle items som kan interageres med (Hovres over, klikkes på & plukkes opp med mus eller trigger) 
 * Implementerer en Interface (ITargetInterface) som har deklarert alle de nødvendige funksjonene.
 * Disse må alle implementeres i denne klassen.
 * Når spilleren beveger musa over objektet på scenen så forandres materialet til en lysere versjon, og evt et tooltip displayes i HUD-en.
 * 
 * av Solveig Hansen 2013
 */

class ToA_BaseItem extends ToA_ActorBase implements(ITargetInterface)
	abstract;

struct BaseItem_SaveData
{
	var bool bUsed;
};

var BaseItem_SaveData data;

var bool bIsTargeted;
var bool bIsHoveredOver;
var bool bIsDestroyed;
var() const float distanceToUse;

var() StaticMeshComponent Mesh;
var SkeletalMeshComponent skelMesh;

var Material selectedMaterial;
var Material normalMaterial;

var const Texture2D tooltipTexture;

function UpdateStruct()
{
	data.bUsed = bIsDestroyed;
}

function InteractWithActor(ToA_Pawn hero)
{
	//Når objektet er "brukt", kan det ikke interageres med på nytt.
	//Setter bIsDestroyed og material til vanlig material, for å gjøre det umulig å klikke på igjen.
	bIsDestroyed = true;
	SetTimer(1.5f, false, 'MakeMaterialNormal');
}

function SetBoolDestroyed()
{
	bIsDestroyed = true;
}

simulated event Destroyed()
{
	super.Destroyed();

	bIsDestroyed = true;
}

function DestroySelf()
{
	Destroy();
}

function bool CheckActorDestroyed()
{
	return bIsDestroyed;
}

function MakeMaterialBrighter()
{
	if(skelMesh != none)
		skelMesh.SetMaterial(0, selectedMaterial);
	else if(Mesh != none)
		Mesh.SetMaterial(0, selectedMaterial);
}
function MakeMaterialNormal()
{
	if(skelMesh != none)
		skelMesh.SetMaterial(0, normalMaterial);
	else if(Mesh != none)
		Mesh.SetMaterial(0, normalMaterial);
}

function float GetInteractDistance()
{
	return distanceToUse;
}

function OnMouseOver()
{
	if(bIsDestroyed)
		return;
	bIsHoveredOver = true;
	MakeMaterialBrighter();
}

function OnMouseAway()
{
	bIsHoveredOver = false;
	if(bIsDestroyed)
		return;
	if(!bIsTargeted)
	{
		MakeMaterialNormal();
	}
}

function OnMouseClick()
{
	if(bIsDestroyed)
		return;
	bIsTargeted = true;
	MakeMaterialBrighter();
}

function OnMouseClickAway()
{
	bIsTargeted = false;
	if(bIsDestroyed)
		return;
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

function Texture2D GetTooltipTexture()
{
	return tooltipTexture;
}

DefaultProperties
{
	bBlockActors=true
	bCollideActors=true

	bIsTargeted=false
	bIsHoveredOver=false

	distanceToUse=100.0f

}
