class ToA_BossSpawner extends ToA_ActorBase
	placeable;

function PostBeginPlay()
{
	super.PostBeginPlay();
    ToA_GameInfo(WorldInfo.Game).bossSpawner = self;
}

function SpawnBoss()
{
	local Pawn p;
	local Vector spawnPos;

	spawnPos = Location;
	spawnPos.Z += 50;

	p = Spawn(class'ToA_GiantSpider',,,spawnPos,,,true);
	p.SpawnDefaultController();
}

DefaultProperties
{
	begin object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	end object
	Components.Add(Sprite)

}
