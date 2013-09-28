class ToA_Chest extends ToA_InteractableItem
	placeable;

var() string lootType; //Sword, Shield
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	//Hadde problemer med å få kista til å se normal ut, spiller av en egen "closed" animasjon
	animNodeCrossfader.PlayOneShotAnim('Closed', 0.0f, 0.0f,true);
}

function InteractWithActor(ToA_Pawn hero)
{
	local Vector spawnLoc;
	super.InteractWithActor(hero);

	spawnLoc = Location;
	
	if(lootType == "Shield")
	{
		spawnLoc.Z += 20;
		Spawn(class'ToA_Shield',,,spawnLoc);
	}
	else if(lootType == "Sword")
	{
		spawnLoc.Z += 20;
		spawnLoc.X += 15;
		Spawn(class'ToA_Sword',,,spawnLoc);
		
	}

	TriggerEventClass(class'SeqEvent_SpawnBoss', self, 1);

}

DefaultProperties
{
	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object Class=SkeletalMeshComponent Name=SkelMesh
		SkeletalMesh=SkeletalMesh'ToA_Assets.SkeletalMeshes.Chest_Animated_WIP'
		AnimSets(0)=AnimSet'ToA_Assets.AnimSets.Chest_AnimSet'
		AnimTreeTemplate=AnimTree'ToA_Assets.AnimTrees.Chest_AnimTree'
		PhysicsAsset=PhysicsAsset'ToA_Assets.PhysicsAsset.Chest_Animated_WIP_Physics'
		Materials(0)=Material'ToA_Assets.Materials.Chest_material'
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	skelMesh=SkelMesh
	CollisionComponent=SkelMesh
	Components.Add(SkelMesh)

	normalMaterial=Material'ToA_Assets.Materials.Chest_material'
	selectedMaterial=Material'ToA_Assets.Materials.Chest_Selected_Material'

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Chest_ToolTip'

	SupportedEvents.Add(class'SeqEvent_SpawnBoss')

}
