class ToA_Wall extends ToA_ActorBase
	placeable;

//Utskiftbar mesh
var() StaticMeshComponent StaticMesh;
var() float timeBeforeShow;

//For å feks hindre vegg-deler som er lave å kunne bli usynlige
//Kunne sikkert laga en egen klasse for disse meshene, men ble mer oversiktlig
//å ha alt som har med vegger å gjøre i en wall-klasse... får tenke litt på det
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
	//Disse må være her...litt usikker på hvorfor når collisons-komponenten blir satt til static mesh comp, og der står det at den collider actors etc
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
		//Bruker BlockNonZeroExtent for å teste om veggen er i veien for at kamera kan se helten.
		BlockNonZeroExtent=true
		//BlockZeroExtent er false for at man skal kunne klikke på gulvet som er gjemt bak veggen, pga de to tracene hindrer ikke hverandre
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

	
