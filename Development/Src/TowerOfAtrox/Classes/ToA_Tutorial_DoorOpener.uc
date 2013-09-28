class ToA_Tutorial_DoorOpener extends ToA_InvisibleDoorOpener
	placeable;

function PostBeginPlay()
{
	super.PostBeginPlay();
    ToA_GameInfo(WorldInfo.Game).tutorialDoorOpener = self;
	`Log("Setter referanse til door opener i GameInfo");
}

DefaultProperties
{
	requiredNumberOfEnemiesKilled=1
}
