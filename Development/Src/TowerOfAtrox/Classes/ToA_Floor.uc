class ToA_Floor extends ToA_ActorBase
	placeable;

var() StaticMeshComponent StaticMesh;

DefaultProperties
{

	bBlockActors=true
	bCollideActors=true
	//bWorldGeometry=true

	begin object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		ModShadowFadeoutTime=0.25
		MinTimeBetweenFullUpdates=0.2
		AmbientGlow=(R=.01,G=.01,B=.01,A=1)
		AmbientShadowColor=(R=0.15,G=0.15,B=0.15)
		bSynthesizeSHLight=true
	end object
	Components.Add(MyLightEnvironment)

	begin object class=StaticMeshComponent Name=StaticMeshComp
		StaticMesh=StaticMesh'Atrox_Walls_Floors.Meshes.FloorMesh'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=1,Y=1,Z=1)
		bAcceptsStaticDecals=true
		bAcceptsDynamicDecals=true
		bAcceptsDecals=true
	end object
	StaticMesh=StaticMeshComp
	Components.Add(StaticMeshComp)


}
