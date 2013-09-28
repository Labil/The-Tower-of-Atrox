class ToA_InventoryShield extends ToA_InventoryItem;


function PutAwayItem(ToA_Pawn hero)
{
	super.PutAwayItem(hero);

	hero.Mesh.AttachComponentToSocket(attachMesh, BackSocketName);
}

DefaultProperties
{
	begin object Class=SkeletalMeshComponent name=Skelly
		SkeletalMesh=SkeletalMesh'ToA_Hero.Weapons.Shield_USE'
	end object
	attachMesh=Skelly

	HandSocketName="ShieldSlot"
	BackSocketName="ShieldBackSocket"
	HudDisplayName="Shield"
}
