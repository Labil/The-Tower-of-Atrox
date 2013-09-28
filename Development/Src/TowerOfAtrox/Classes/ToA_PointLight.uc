class ToA_PointLight extends PointLightMovable
	placeable;

function turnOn() 
{
	LightComponent.SetEnabled(true);
}

function turnOff() 
{

	LightComponent.SetEnabled(false);
}

function setBrightness(float f) 
{
	LightComponent.SetLightProperties(f);
        LightComponent.UpdateColorAndBrightness();
}

function setColor(byte r, byte g, byte b, byte a) 
{
	local color c;
	
	c.R = r;
	c.G = g;
	c.B = b;
	c.A = a;

	LightComponent.SetLightProperties(,c); 
    LightComponent.UpdateColorAndBrightness();
}

//default 1024.0
function setRadius(float r) 
{
	PointLightComponent(LightComponent).Radius = r;
}

//default 2.0
function setFallOffExponent(float e) 
{
	PointLightComponent(LightComponent).FalloffExponent = e;
}

//default 2.0
function setShadowFalloffExponent(float e) 
{
	PointLightComponent(LightComponent).ShadowFalloffExponent = e;
}

//default 1.1
function setShadowRadiusMultiplier(float f) 
{
	PointLightComponent(LightComponent).ShadowRadiusMultiplier = f;
}

function setCastDynamicShadows(bool b) 
{
	LightComponent.CastDynamicShadows = b;
}

function Tick(Float DeltaTime) 
{
	super.Tick(DeltaTime);
	Move(Owner.Location - self.Location);
}


DefaultProperties
{
    bNoDelete = false
	
    //for use with actor.move()
    bCollideActors = false
	bCollideWorld = false

}
