class ToA_Sword extends ToA_PickupItem
	placeable;


simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	inventoryItem = Spawn(class'ToA_InventorySword', self);
}

DefaultProperties
{
	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=StaticMeshComponent Name=StaticMeshComp
		StaticMesh=StaticMesh'ToA_Hero.Weapons.Sword_StaticMesh'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=1,Y=1,Z=1)
	end object
	Mesh=StaticMeshComp
	Components.Add(StaticMeshComp)

	begin object class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=50.0
		CollisionHeight=50.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=false
		CollideActors=true
	end object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	selectedMaterial=Material'ToA_Hero.Materials.Sword_Selected_Material'
	normalMaterial=Material'ToA_Hero.Materials.Sword_Material'

	distanceToUse=100.0f
	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Sword_ToolTip'
	PopupLabelName="Sword"
	

}
