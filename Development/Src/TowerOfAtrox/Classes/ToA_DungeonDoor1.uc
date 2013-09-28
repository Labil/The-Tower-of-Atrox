class ToA_DungeonDoor1 extends ToA_AnimatedDoor
	placeable;

function InteractWithActor(ToA_Pawn hero)
{
	//Denne funksjonen er tom, skal ikke kunne åpne dør med å klikke på!
	`Log("Denne døra er låst");
	//Lage til hud!
}

DefaultProperties
{
	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object Class=SkeletalMeshComponent Name=SkelMesh
		SkeletalMesh=SkeletalMesh'Atrox_Walls_Floors.SkeletalMeshes.Door_Animation2_WIP'
		AnimSets(0)=AnimSet'Atrox_Walls_Floors.AnimSets.Door_AnimSet'
		AnimTreeTemplate=AnimTree'Atrox_Walls_Floors.AnimTrees.Door_Animtree'
		PhysicsAsset=PhysicsAsset'Atrox_Walls_Floors.PhysicsAssets.Door_Asset_WIP_Physics'
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=SkelMesh
	Components.Add(SkelMesh)

	normalMaterial=Material'Atrox_Walls_Floors.Materials.Door_Material'
	selectedMaterial=Material'Atrox_Walls_Floors.Materials.Door_Selected_Material'

	distanceToUse=70.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.LockedDoor_ToolTip'
}
