class ToA_Wall extends ToA_ActorBase
	placeable;

//Utskiftbar mesh
var() StaticMeshComponent StaticMesh;
var() float timeBeforeShow;

//For � feks hindre vegg-deler som er lave � kunne bli usynlige
//Kunne sikkert laga en egen klasse for disse meshene, men ble mer oversiktlig
//� ha alt som har med vegger � gj�re i en wall-klasse... f�r tenke litt p� det
var() bool bCanBeHidden;


function Hide()
{
	if(bCanBeHidden)
	{
		SetHidden(true);
	}
}

function Show()
{
	SetHidden(false);
}

function float GetTimeHidden()
{
	return timeBeforeShow;
}

DefaultProperties
{
	//Disse m� v�re her...litt usikker p� hvorfor n�r collisons-komponenten blir satt til static mesh comp, og der st�r det at den collider actors etc
	bBlockActors=true
	bCollideActors=true
	bBlocksNavigation=true
	bBlocksTeleport=true
	CollisionType=COLLIDE_BlockAll
	bWorldGeometry=true
	//bStatic=true

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
		Scale3D=(X=1,Y=1,Z=1)
		//Bruker BlockNonZeroExtent for � teste om veggen er i veien for at kamera kan se helten.
		BlockNonZeroExtent=true
		//BlockZeroExtent er false for at man skal kunne klikke p� gulvet som er gjemt bak veggen, pga de to tracene hindrer ikke hverandre
		BlockZeroExtent=false
		BlockActors=true
		CollideActors=true
		LightEnvironment=MyLightEnvironment
	end object

	StaticMesh=StaticMeshComp
	
	CollisionComponent=StaticMeshComp
	Components.Add(StaticMeshComp)

	bCanBeHidden=true

	timeBeforeShow=5.0f

}

	
