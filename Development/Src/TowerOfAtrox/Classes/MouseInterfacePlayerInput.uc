class MouseInterfacePlayerInput extends PlayerInput;

var Vector2D MousePosition;

event PlayerInput(float DeltaTime)
{
	local ATROXHUD aHud;
	aHud = ATROXHUD(myHUD);

	if(aHUD != none)
	{
		if(!aHud.bUsiningScaleform)
		{
			MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, aHud.SizeX);
			MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, aHud.SizeY);
		}
	}
	//Denne må stå etter det andre, litt usikker på hvorfor, men det funker ikke å ha den først...
	super.PlayerInput(DeltaTime);
	
}

function SetMousePosition(int x, int y)
{
	if(myHUD != none)
	{
		MousePosition.X = Clamp(x, 0, myHUD.SizeX);
		MousePosition.Y = Clamp(y, 0, myHUD.SizeY);
	}
}

DefaultProperties
{
}
