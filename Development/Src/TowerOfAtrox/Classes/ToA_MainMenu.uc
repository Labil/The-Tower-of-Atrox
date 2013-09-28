class ToA_MainMenu extends GFxMoviePlayer config(UI);

var GFxClikWidget newGameBtn, tutorialBtn, loadBtn, exitBtn;
var GFxClikWidget SaveBtn, ResolutionStepper, AliasingStepper, FullscreenStepper, GammaStepper;

var config array<string> ResolutionList;
var globalconfig int ResolutionIndex, AliasingIndex, FullscreenIndex, GammaIndex;
var config string StartMap;
var config string TutorialMap;

var ToA_GameInfo gameRef;

function Init(optional LocalPlayer LocPlay)
{
	Start();
	Advance(0);
	
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
	case('tutorialBtn'):
		tutorialBtn = GFxClikWidget(Widget);
		tutorialBtn.AddEventListener('CLIK_click', StartTutorial);
		bWasHandled=true;
		break;
	case('newGameBtn'):
		newGameBtn = GFxClikWidget(Widget);
		newGameBtn.AddEventListener('CLIK_click', NewGame);
		bWasHandled = true;
		break;
	case('loadBtn'):
		loadBtn = GFxClikWidget(Widget);
		loadBtn.AddEventListener('CLIK_click', LoadGame);
		bWasHandled = true;
		break;
	case('exitBtn'):
		exitBtn = GFxClikWidget(Widget);
		exitBtn.AddEventListener('CLIK_click', ExitGame);
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
		class'Client'.default.DisplayGamma = int(GammaStepper.GetString("selectedItem"));//Lagrer
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

function NewGame(EventData data)
{
	if(data.mouseIndex==0)
	{
		//Close();
		ConsoleCommand("open" @ StartMap $ "?ShouldLoadMenu=0" $ "?ShouldLoadGameSave=0" $ "?ShouldAllowSave=1" $ "?ShouldDisplayStory=1");
	}
}

function StartTutorial(EventData data)
{
	if(data.mouseIndex==0)
	{
		//Close();
		ConsoleCommand("open" @ TutorialMap $ "?ShouldLoadMenu=0" $ "?ShouldLoadGameSave=0" $ "?ShouldAllowSave=0");
	}
}

function LoadGame(EventData data)
{
	//Close();
	ConsoleCommand("open" @ StartMap $ "?ShouldLoadMenu=0" $ "?ShouldLoadGameSave=1" $ "?ShouldAllowSave=1");
}


function ExitGame(EventData data)
{
	if(data.mouseIndex == 0)
	{
		//Close();
		ConsoleCommand("Quit");
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
	MovieInfo=SwfMovie'ScaleformMenuGFx.SFMFrontEnd.Atrox_MainMenu'

	WidgetBindings.Add((WidgetName="newGameBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="tutorialBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="loadBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="exitBtn",WidgetClass=class'GFxCLIKWidget'))

	WidgetBindings.Add((WidgetName="saveBtn", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="resolutionStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="aliasingStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="fullscreenStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="gammaStepper", WidgetClass=class'GFxClikWidget'));

	TimingMode=TM_Real
	bPauseGameWhileActive=true
	bCaptureInput=true

}
