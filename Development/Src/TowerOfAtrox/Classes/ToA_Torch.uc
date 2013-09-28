class ToA_Torch extends ToA_PickupItem
	placeable;


simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	inventoryItem = Spawn(class'ToA_InventoryTorch', self);
}

DefaultProperties
{
	bCollideActors=true
	bBlockActors=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=SkeletalMeshComponent Name=TorchMesh
		SkeletalMesh=SkeletalMesh'ToA_Hero.Weapons.Torch_USE'
		PhysicsAsset=PhysicsAsset'ToA_Hero.PhysicsAssets.Torch_USE_Physics'
		CastShadow=true
		bCastDynamicShadow=true
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	skelMesh=TorchMesh
	CollisionComponent=TorchMesh
	Components.Add(TorchMesh)

	selectedMaterial=Material'ToA_Hero.Materials.Torch_Selected_Material'
	normalMaterial=Material'ToA_Hero.Materials.Torch_Material'

	distanceToUse=100.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Torch_ToolTip'
	PopupLabelName="Torch"

}
