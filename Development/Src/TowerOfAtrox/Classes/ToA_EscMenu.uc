class ToA_EscMenu extends GFxMoviePlayer config(UI);

var GFxClikWidget ResumeBtn, SaveGameBtn, LoadGameBtn, OptionsBtn, settingsBtn, ExitGameBtn;
var GFxClikWidget SaveBtn, ResolutionStepper, AliasingStepper, FullscreenStepper, GammaStepper;

var config array<string> ResolutionList;
var globalconfig int ResolutionIndex, AliasingIndex, FullscreenIndex, GammaIndex;
var config string StartMap;

var string filename;

var ToA_GameInfo gameRef;

var ToA_MainMenu mainMenu;


function Init(optional LocalPlayer LocPlay)
{
	Start();
	Advance(0);
	//bPauseOn=false;
	super.Init(LocPlay);

}

event bool WidgetInitialized(Name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	bWasHandled = false;

	switch(WidgetName)
	{
	case ('saveBtn') :
		SaveBtn = GFxClikWidget(Widget);
		SaveBtn.AddEventListener('CLIK_click', SaveOptions);
		bWasHandled=true;
		break;
	case('saveGameBtn'):
		SaveGameBtn = GFxClikWidget(Widget);
		SaveGameBtn.AddEventListener('CLIK_click', SaveGame);
		if(gameRef.iShouldAllowSave == 0)
			SaveGameBtn.SetBool("enabled", false);
		bWasHandled=true;
		break;
	case('resumeBtn'):
		ResumeBtn = GFxClikWidget(Widget);
		ResumeBtn.AddEventListener('CLIK_click', ResumeGame);
		bWasHandled = true;
		break;
	case('loadGameBtn'):
		LoadGameBtn = GFxClikWidget(Widget);
		LoadGameBtn.AddEventListener('CLIK_click', LoadGame);
		if(gameRef.iShouldAllowSave == 0)
			LoadGameBtn.SetBool("enabled", false);
		bWasHandled = true;
		break;
	case('exitBtn'):
		ExitGameBtn = GFxClikWidget(Widget);
		ExitGameBtn.AddEventListener('CLIK_click', ExitGame);
		bWasHandled = true;
		break;
	case ('resolutionStepper') :
		ResolutionStepper = GFxClikWidget(Widget);
		SetDataProvider(ResolutionStepper);
		ResolutionStepper.SetInt("selectedIndex", ResolutionIndex);
		bWasHandled=true;
		break;
	case ('aliasingStepper') :
		AliasingStepper = GFxClikWidget(Widget);
		AliasingStepper.SetInt("selectedIndex", AliasingIndex);
		bWasHandled=true;
		break;
	case ('fullscreenStepper') :
		FullscreenStepper = GFxClikWidget(Widget);
		FullscreenStepper.SetInt("selectedIndex", FullscreenIndex);
		bWasHandled=true;
		break;
	case ('gammaStepper') :
		GammaStepper = GFxClikWidget(Widget);
		GammaStepper.SetInt("selectedIndex", GammaIndex);
		bWasHandled=true;
		break;

	default:
		break;
	}

	return bWasHandled;
}

function SaveOptions(EventData data)
{
	local int ASI, RSI, FSI, GSI;
	local bool bUpdatedSettings;
	local string fs;

	ASI = AliasingStepper.GetInt("selectedIndex");
	RSI = ResolutionStepper.GetInt("selectedIndex");
	FSI = FullscreenStepper.GetInt("selectedIndex");
	GSI = GammaStepper.GetInt("selectedIndex");
	bUpdatedSettings=false;

	if(GammaIndex != GSI)
	{
		GammaIndex = GSI;
		ConsoleCommand("Gamma" @ GammaStepper.GetString("selectedItem"));
		class'Client'.default.DisplayGamma = int(GammaStepper.GetString("selectedItem"));	// Won't be saved if you don't change this!
		class'Client'.static.StaticSaveConfig();
		bUpdatedSettings=true;
	}

	if(AliasingIndex != ASI)
	{
		AliasingIndex=ASI;
		ConsoleCommand("Scale Set MaxMultiSamples " $ AliasingStepper.GetString("selectedItem"));
		bUpdatedSettings=true;
	}
	
	if(ResolutionIndex!=RSI || FullscreenIndex!=FSI)
	{
		FullscreenIndex=FSI;
		ResolutionIndex=RSI;
		if(FullscreenIndex==0)
			fs=" w";
		else
			fs=" f";

		ConsoleCommand("Setres " $ ResolutionStepper.GetString("selectedItem") $ "x32" $ fs);
		bUpdatedSettings=true;
	}

	if(bUpdatedSettings)
	{
		SaveConfig();
	}
}

/*function StartGame(EventData data)
{
	if(data.mouseIndex==0)
	{
		//Close(true);
		ConsoleCommand("open " $ StartMap);
		//ConsoleCommand("open TowerOfAtrox_IntroLevel");
		//ConsoleCommand("open TowerOfAtrox_IntroLevel?game=ToA_GameInfo");
	}
}*/

function ResumeGame(EventData data)
{
	if(data.mouseIndex == 0)
	{
		Close();
	}
}

function LoadGame(EventData data)
{
	gameRef.Load(filename);
	//gameRef.hudWorld.combatLog.AddEntriesToLog("Game loaded.");
	Close();
}

function SaveGame(EventData data)
{
	//Hvis spiller er i idle state! ikke i combat eller noe annet!
	gameRef.Save(filename);
	gameRef.hudWorld.combatLog.AddEntriesToLog("Game saved.");
	Close();
	
}
function ExitGame(EventData data)
{
	if(data.mouseIndex == 0)
	{
		mainMenu = new class'ToA_MainMenu'; 
		mainMenu.gameRef = gameRef;
		mainMenu.MovieInfo = SwfMovie'ScaleformMenuGFx.SFMFrontEnd.Atrox_MainMenu'; 
		mainMenu.Start();
		Close();
	}
}

function SetDataProvider(GFxClikWidget Widget)
{
	local byte i;
	local GFxObject DataProvider;

	DataProvider=CreateObject("scaleform.clik.data.DataProvider");

	for(i=0; i<ResolutionList.Length; i++)
	{
		DataProvider.SetElementString(i, ResolutionList[i]);
	}

	Widget.SetObject("dataProvider", DataProvider);
}

DefaultProperties
{
	MovieInfo=SwfMovie'ScaleformMenuGFx.SFMFrontEnd.AtroxMenu'

	WidgetBindings.Add((WidgetName="resumeBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="saveGameBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="loadGameBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="exitBtn",WidgetClass=class'GFxCLIKWidget'))

	WidgetBindings.Add((WidgetName="saveBtn", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="resolutionStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="aliasingStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="fullscreenStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="gammaStepper", WidgetClass=class'GFxClikWidget'));

	TimingMode=TM_Real
	bPauseGameWhileActive=true
	bCaptureInput=true

	filename="ToA_GameState.bin"
}
