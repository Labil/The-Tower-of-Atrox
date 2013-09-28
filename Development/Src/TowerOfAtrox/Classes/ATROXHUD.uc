class ATROXHUD extends HUD;

//Refererer til den faktiske SWF containeren
var GFxHUD HudMovie;

var const Texture2D CursorTexture;
var const Color CursorColor;
var ToA_GamePlayerController PC;

var ToA_CombatLog combatLog;

var Texture2D currentTooltipTexture;

var name toolTipName;

var bool bUsiningScaleform;

var bool bShouldDisplayTooltip;

var bool shouldDisplayDamage;

//Kalles når den blir destroyed
singular event Destroyed()
{
	super.Destroyed();

	if(HudMovie != none)
	{
		HudMovie.Close(true);
		HudMovie = none;
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	combatLog = Spawn(class'ToA_CombatLog');

	if(bUsiningScaleform)
	{
		`Log("SETTER NY HUD!");
		HudMovie = new class'GFxHUD';
		HudMovie.aHud = Self;
		HudMovie.PlayerOwner = PlayerOwner;
		//Setter timing mode til TM_Real, ellers blir ting pauset i menyer
		HudMovie.SetTimingMode(TM_Real);
		//Kaller HudMovie sin Initialize function
		HudMovie.Init();
		PreCalcValues();
	}

	ToA_GameInfo(WorldInfo.Game).hudWorld = self;

	//PC = ToA_GameInfo(WorldInfo.Game).controllerWorld;
	PC = ToA_GamePlayerController(PlayerOwner);
}

function PreCalcValues()
{
	super.PreCalcValues();

	if(HudMovie != none)
	{
		HudMovie.SetViewport(0,0,SizeX,SizeY);
		HudMovie.SetViewScaleMode(SM_NoScale);
		//HudMovie.SetViewScaleMode(SM_ExactFit);
		HudMovie.SetAlignment(Align_TopLeft);

	}
}

function CheckViewPortAspectRatio()
{
        local vector2D ViewportSize;
		local bool bIsWideScreen;

        if(PC != none)
			LocalPlayer(PC.Player).ViewportClient.GetViewportSize(ViewportSize);
        
		bIsWideScreen = (ViewportSize.Y > 0.f) && (ViewportSize.X/ViewportSize.Y > 1.7);

		if (bIsWideScreen)
		{
			RatioX = SizeX / 1280.f;
			RatioY = SizeY / 720.f;
		}

		//PreCalcValues();
}

event DrawHud()
{
	local ToA_BaseEnemy enemy;
	local ToA_Pawn pawnie;
	local Vector enemy2DPos;
	//local Vector hero2DPos;

	Canvas.DrawColor = WhiteColor;
	//Canvas.Font = class'Engine'.Static.GetLargeFont();

	//PC = ToA_GamePlayerController(PlayerOwner);
	if(PC != none)
	{
		enemy = ToA_BaseEnemy(PC.currentClickTarget);
		pawnie = ToA_Pawn(PC.Pawn);

		CheckViewPortAspectRatio();
		/*if(pawnie != none)
		{
			Canvas.SetPos(Canvas.ClipX * 0.05, Canvas.ClipY * 0.9);
			Canvas.DrawText("Hero health:" @ pawnie.heroHealth @ "/"@ pawnie.heroMaxHealth);
		}
		if(PlayerOwner.Pawn != none && enemy != none && enemy.currentHealth > 0)
		{
			Canvas.SetPos(Canvas.ClipX * 0.05, Canvas.ClipY * 0.95);
			Canvas.DrawText("Enemy health:" @ enemy.currentHealth);
		}*/
		/*if(PlayerOwner.Pawn != none)
		{
			Canvas.SetPos(Canvas.ClipX * 0.05, Canvas.ClipY * 0.85);
			Canvas.DrawText("Hero level:" @ pawnie.heroCurrentLevel);
		}*/
		if(PC != none && enemy != none && enemy.bReceivingDmg)
		{
			enemy2DPos = Canvas.Project(enemy.Location);
			enemy2DPos.Y -= 150;
			enemy2DPos.X -= 20;
			Canvas.SetPos(enemy2DPos.X, enemy2DPos.Y);
			Canvas.DrawText("-"@pawnie.DamageAmount);
		}
		/*if(PC != none && enemy != none && PC.bReceivingDmg)
		{
			hero2DPos = Canvas.Project(pawnie.Location);
			hero2DPos.Y -= 150;
			hero2DPos.X -= 20;
			Canvas.SetPos(hero2DPos.X, hero2DPos.Y);
			Canvas.DrawText("-"@enemy.DamageAmount);
		}*/
		if(bShouldDisplayTooltip)
		{
			Canvas.SetPos(GetMouseCoordinates().X + 25.0f, GetMouseCoordinates().Y + 20.0f);
			Canvas.DrawTile(currentTooltipTexture, currentTooltipTexture.SizeX/2, currentTooltipTexture.SizeY/2, 0.f, 0.f, currentTooltipTexture.SizeX, currentTooltipTexture.SizeY,,true);
		}
	}

}

function DisplayTooltip(bool shouldDisplay, optional Texture2D tex)
{
	if(tex != none)
	{
		currentTooltipTexture = tex;
		bShouldDisplayTooltip = true;
	}
	else
		bShouldDisplayTooltip = false;
}

function vector2D GetMouseCoordinates()
{
	local Vector2D mousePos;
	local MouseInterfacePlayerInput MouseInterfacePlayerInput;

	if(PlayerOwner != none)
	{
		MouseInterfacePlayerInput = MouseInterfacePlayerInput(PlayerOwner.PlayerInput);

		if(MouseInterfacePlayerInput != none)
		{
			mousePos.X = MouseInterfacePlayerInput.MousePosition.X;
			mousePos.Y = MouseInterfacePlayerInput.MousePosition.Y;
		}
	}
	return mousePos;
}

//All definering og rendring av HUD må foregå i PostRender-eventen.
event PostRender()
{
	local ToA_Camera PlayerCam;
	local MouseInterfacePlayerInput MIPI;

	if(!bUsiningScaleform)
	{
		if(PlayerOwner != none && CursorTexture != none)
		{
			MIPI = MouseInterfacePlayerInput(PlayerOwner.PlayerInput);

			if(MIPI != none)
			{
				Canvas.SetPos(MIPI.MousePosition.X, MIPI.MousePosition.Y);
				Canvas.DrawColor = CursorColor;
				Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,,true);
			}
		}
	}

	super.PostRender();

	//Henter inn hud'ens player owner og caster den som spill kontroller klassen
	PC = ToA_GamePlayerController(PlayerOwner);
	//Henter muskoordinatene med GetMouseCoordinates() som henter dem fra MouseInterfacePlayerInput-klassen, en klasse kopiert fra UDK's forum, en såkalt Gem
	PC.PlayerMouse = GetMouseCoordinates();
	//Transformerer 2D screen coordinater om til 3D world-space origin og retning
	Canvas.DeProject(PC.PlayerMouse, PC.MousePosWorldLocation, PC.MousePosWorldNormal);
	//Henter en referanse til kameraet vårt
	PlayerCam = ToA_Camera(PC.PlayerCamera);

	//Kalkulerer en trace fra spillerns kamera + 100 oppover i z-aksen i retning tilsvarende den deprojecterte MousePosWorldNormal (dv musas retning)

	//Setter ray direction som MouseWorldNormal
	PC.RayDir = PC.MousePosWorldNormal;
	//Starter trace på spillerens kamera(isometrisk) + 100 units opp og en liten offset i front av kameraet(direction * 10)
	PC.StartTrace = (PlayerCam.ViewTarget.POV.Location + vect(0,0,0)) + PC.RayDir;
	//Avslutt ray'en på avstand: start + retningen ganger en gitt avstand (feks 5000 som pleier å holde)
	PC.EndTrace = PC.StartTrace + PC.RayDir * 5000;

    PC.TraceActor = Trace(PC.MouseHitWorldLocation, PC.MouseHitWorldNormal, PC.EndTrace, PC.StartTrace, true);

    //Kan sjekke hindringer i veien for pawnen med dette
    PC.PawnEyeLocation = Pawn(PlayerOwner.ViewTarget).Location + Pawn(PlayerOwner.ViewTarget).EyeHeight * vect(0,0,1);

    //Basic draw hud rutine
    DrawHUD();
	HudMovie.TickHUD();

}


function int GetNumKilledEnemies()
{
	return ToA_GameInfo(WorldInfo.Game).GetNumKilledEnemies();
}

function int GetNumSmashedObjs()
{
	return ToA_GameInfo(WorldInfo.Game).GetNumSmashedObjs();
}

function int GetTimesDied()
{
	return ToA_GameInfo(WorldInfo.Game).GetTimesDied();
}

function int GetSecretRoomsFound()
{
	return ToA_GameInfo(WorldInfo.Game).GetSecretRoomsFound();
}

DefaultProperties
{
	CursorColor=(R=255,G=255,B=255,A=255)
	CursorTexture=Texture2D'EngineResources.Cursors.Arrow'

	shouldDisplayDamage=true

	bUsiningScaleform=true
}
