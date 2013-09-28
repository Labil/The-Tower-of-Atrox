class ToA_Shield extends ToA_PickupItem
	placeable;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	inventoryItem = Spawn(class'ToA_InventoryShield', self);
}

DefaultProperties
{
	bBlockActors=true
	bCollideActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=StaticMeshComponent Name=StaticMeshComp
		StaticMesh=StaticMesh'ToA_Hero.Weapons.Shield_StaticMesh'
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

	normalMaterial=Material'ToA_Hero.Materials.Shield_Material'
	selectedMaterial=Material'ToA_Hero.Materials.Shield_Selected_Material'

	distanceToUse=90.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Shield_ToolTip'
	PopupLabelName="Shield"
}
