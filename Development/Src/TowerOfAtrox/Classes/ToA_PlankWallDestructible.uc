class ToA_PlankWallDestructible extends ToA_Destructible
	placeable;


DefaultProperties
{
	begin object name=DestructibleComponent0
		Asset=ApexDestructibleAsset'ToA_Destructibles.Apex.WoodenPlank'
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

	outside=Material'ToA_Destructibles.Materials.WoodenPlank'
	inside=Material'ToA_Destructibles.Materials.WoodenPlankInside'

	bIsTargeted=false
	bIsHoveredOver=false

	distanceToUse=80.0f

	//tooltipTexture=Texture2D'ToA_ToolTips.Textures.Jug_Tooltip'
}
