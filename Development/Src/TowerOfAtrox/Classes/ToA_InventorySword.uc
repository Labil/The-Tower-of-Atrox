class ToA_InventorySword extends ToA_InventoryWeapon;

DefaultProperties
{
	begin object Class=SkeletalMeshComponent name=Skelly
		SkeletalMesh=SkeletalMesh'ToA_Hero.Weapons.Sword_USE'
	end object
	attachMesh=Skelly

	/*Begin Object Class=ParticleSystemComponent Name=Particles
		bAutoActivate=false
		SecondsBeforeInactive=0.0f
		Scale=1.0f
		Template=ParticleSystem'erik_particle.Material.Key_Sparkle'
	End Object
	swordParticleSwoosh=Particles*/

	HiltSocketName="SwordHiltSocket"
	TipSocketName="SwordTipSocket"
	HandSocketName="WeaponSlot"
	BackSocketName="SwordBackSocket"
	HudDisplayName="Sword"

	//SwordClank=


}
