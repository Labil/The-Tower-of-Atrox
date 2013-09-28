class ToA_Jug extends ToA_Destructible
	placeable;


simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	//smashSound.Play();

	if(CheckIfShouldSpawnPotion())
		SpawnRandomPotion();

	ToA_GameInfo(WorldInfo.Game).AddSmashedObj();

}

function bool CheckIfShouldSpawnPotion()
{
	local int chanceToSpawn;
	chanceToSpawn = GenerateRandomInt(0, 100);

	if(chanceToSpawn >= 30)
		return true;
	else
		return false;

}

function SpawnRandomPotion()
{
	local int num;
	num = GenerateRandomInt(0,2);

	if(num == 1)
		Spawn(class'ToA_Potion',,,Location, rotator(vect(1,0,0)));
	else
		Spawn(class'ToA_EnergyPotion',,,Location, rotator(vect(1,0,0)));
}

function int GenerateRandomInt(int min, int max)
{
	local int diff;
	local int val;
	diff = max - min;
	val = Rand(diff) + min;

	return val;
}

DefaultProperties
{
	begin object name=DestructibleComponent0
		Asset=ApexDestructibleAsset'ToA_Destructibles.Apex.WineJug2'
		RBChannel=RBCC_EffectPhysics
		RBCollideWithChannels={(
			Default=true,
			BlockingVolume=true,
			GamePlayPhysics=true,
			EffectPhysics=true
			)}
	end object

	begin object class=AudioComponent Name=AudioComp
		SoundCue=SoundCue'ToA_Lyder.WAV.JugSmash_Sound_Cue'
		bAutoPlay=false
	end object
	smashSound=AudioComp
	Components.Add(AudioComp)

	outside=Material'ToA_Destructibles.Texture.WineJug_Mat'
	inside=Material'ToA_Destructibles.Texture.WineJug_Inside_Mat'

	bIsTargeted=false
	bIsHoveredOver=false

	distanceToUse=70.0f

	tooltipTexture=Texture2D'ToA_ToolTips.Textures.Jug_Tooltip'
}
