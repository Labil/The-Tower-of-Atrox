class ToA_Level1_Door1Opener extends ToA_InvisibleDoorOpener
	placeable;

function PostBeginPlay()
{
	super.PostBeginPlay();
    ToA_GameInfo(WorldInfo.Game).door1Opener = self;
	`Log("Setter referanse til door opener i GameInfo");
}

DefaultProperties
{
	requiredNumberOfEnemiesKilled=3
}
