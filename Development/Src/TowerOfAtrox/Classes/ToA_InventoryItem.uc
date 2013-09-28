class ToA_InventoryItem extends ToA_BaseItem;

var SkeletalMeshComponent attachMesh;
var const name HandSocketName, BackSocketName, HudDisplayName;
var bool bIsEquipped;
var ToA_Pawn heroRef;

function EquipItemToOwner(ToA_Pawn hero)
{
	if(attachMesh != none && !bIsEquipped)
	{
		`Log("Equipping item to Hero"@attachMesh);
		ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.HideInventoryItem(HudDisplayName);
		attachMesh.SetShadowParent(hero.Mesh);
		hero.Mesh.AttachComponentToSocket(attachMesh, HandSocketName);
		bIsEquipped = true;
		SetItemOwner(hero);
	}
}

function SetItemOwner(ToA_Pawn hero)
{
	heroRef = hero;
}

function PutAwayItem(ToA_Pawn hero)
{
	ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.DisplayInventoryItem(HudDisplayName);
	hero.Mesh.DetachComponent(attachMesh);
	bIsEquipped = false;
}

function SkeletalMeshComponent GetMesh()
{
	return attachMesh;
}

function bool IsItemEquipped()
{
	return bIsEquipped;
}

DefaultProperties
{
	bIsEquipped=false
}
