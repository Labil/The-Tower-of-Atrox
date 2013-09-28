class ToA_LightSource extends ToA_ActorBase
	placeable;

var ToA_PointLight mLight;
var() float mBrightness;
var() float mRadius;
var() bool bDynamicShadows;


simulated function PostBeginPlay()
{
	SetUpLight();		
}

function SetUpLight()
{
	mLight = Spawn(class'ToA_PointLight',self,,self.Location,rot(0,0,0),,true);//Siste booleanen sørger for at lyset spawner selv inni actors som har collison
	mLight.setBrightness(mBrightness);
	mLight.setColor(255, 255, 122, 255);
	mLight.setRadius(mRadius);
	mLight.setShadowFalloffExponent(60);
	mLight.setCastDynamicShadows(bDynamicShadows);

}


DefaultProperties
{
	begin object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	end object
	Components.Add(Sprite)

	mBrightness=2.0f
	mRadius=2024.0f
	bDynamicShadows=true
}
