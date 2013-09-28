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
	//Denne m� st� etter det andre, litt usikker p� hvorfor, men det funker ikke � ha den f�rst...
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
