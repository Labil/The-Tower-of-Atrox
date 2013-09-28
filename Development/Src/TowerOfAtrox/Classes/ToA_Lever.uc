class ToA_Lever extends ToA_InteractableItem
	placeable;

var ToA_DungeonDoor2 door;

simulated function PostBeginPlay()
{
	local ToA_DungeonDoor2 d;
	super.PostBeginPlay();

	foreach DynamicActors(class'ToA_DungeonDoor2', d)
	{
		door = d;
	}
	if(door == none)
		`Log("DIDN*T FIND DOOOOOOR");
}

function InteractWithActor(ToA_Pawn hero)
{
	super.InteractWithActor(hero);
	`Log("Using Lever");
	SetTimer(1.0f, false, 'TriggerOpenDoor');
	
	//TriggerEventClass(class'SeqEvent_PullLever', self, 1);
}

function TriggerOpenDoor()
{
	if(door != none)
		door.OpenDoor();
}

DefaultProperties
{
	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	end object
	Components.Add(MyLightEnvironment)

	begin object Class=SkeletalMeshComponent Name=SkelMesh
		SkeletalMesh=SkeletalMesh'ToA_Assets.SkeletalMeshes.Lever'
		AnimSets(0)=AnimSet'ToA_Assets.AnimSets.Lever_AnimSet'
		AnimTreeTemplate=AnimTree'ToA_Assets.AnimTrees.Lever_AnimTree'
		PhysicsAsset=PhysicsAsset'ToA_Assets.PhysicsAsset.Lever_Physics'
		Materials(0)=Material'ToA_Assets.Materials.Lever_Material'
		LightEnvironment=MyLightEnvironment
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockActors=true
		CollideActors=true
	end object
	skelMesh=SkelMesh
	CollisionComponent=SkelMesh
	Components.Add(SkelMesh)

	normalMaterial=Material'ToA_Assets.Materials.Lever_Material'
	selectedMaterial=Material'ToA_Assets.Materials.Lever_Selected_Material'

	distanceToUse=100.0f

	//SupportedEvents.Add(class'SeqEvent_PullLever')
	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Lever_ToolTip'
}
