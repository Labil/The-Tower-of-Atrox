class ToA_DungeonDoor2 extends ToA_AnimatedDoor
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
		SkeletalMesh=SkeletalMesh'Atrox_Walls_Floors.SkeletalMeshes.Door_Bars_SkelMesh'
		AnimSets(0)=AnimSet'Atrox_Walls_Floors.AnimSets.Door_Bars_AnimSet'
		AnimTreeTemplate=AnimTree'Atrox_Walls_Floors.AnimTrees.Door_Bars_AnimTree'
		PhysicsAsset=PhysicsAsset'Atrox_Walls_Floors.PhysicsAssets.Door_Bars_SkelMesh_Physics'
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	CollisionComponent=SkelMesh
	Components.Add(SkelMesh)

	//outside=Material'ToA_Destructibles.Texture.WineJug_Mat'
	//inside=Material'ToA_Destructibles.Texture.WineJug_Inside_Mat'

	distanceToUse=70.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.LockedDoor_ToolTip'

	
}
