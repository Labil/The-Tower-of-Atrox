class ToA_DestructibleWall extends ToA_Destructible
	placeable;

var() StaticMeshComponent wallCrack;

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super(ApexDestructibleActorSpawnable).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	smashSound.Play();

	StaticDestructibleComponent.SetActorCollision(false, false);
	StaticDestructibleComponent.SetBlockRigidBody(false);
	StaticDestructibleComponent.SetNotifyRigidBodyCollision(false);

	bIsDestroyed = true;
	wallCrack.SetHidden(true);

	ToA_GameInfo(WorldInfo.Game).AddSecretRoomFound();
}

DefaultProperties
{
	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		ModShadowFadeoutTime=0.25
		MinTimeBetweenFullUpdates=0.2
		AmbientGlow=(R=.01,G=.01,B=.01,A=1)
		AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
		bSynthesizeSHLight=true
	end object
	Components.Add(MyLightEnvironment)

	begin object name=DestructibleComponent0
		Asset=ApexDestructibleAsset'ToA_Destructibles.Apex.Wall2'
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

	begin object class=StaticMeshComponent Name=WallCrack
		StaticMesh=StaticMesh'erik_particle.wallCrack'
		Scale3D=(X=3,Y=3,Z=3)
		Rotation=(Pitch=0,Roll=180,Yaw=0)
		Translation=(X=10,Y=10,Z=-3)
		LightEnvironment=MyLightEnvironment
	end object
	wallCrack=WallCrack
	Components.Add(WallCrack)

	outside=Material'ToA_Destructibles.Materials.Wall_Brick_Apex'
	inside=Material'ToA_Destructibles.Materials.Wall_Brick_Inside'

	bIsTargeted=false
	bIsHoveredOver=false

	distanceToUse=80.0f

	//tooltipTexture=Texture2D'ToA_ToolTips.Textures.Jug_Tooltip'
}


