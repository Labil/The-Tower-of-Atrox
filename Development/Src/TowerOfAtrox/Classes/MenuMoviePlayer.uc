class MenuMoviePlayer extends GFxMoviePlayer config(UI);

var GFxClikWidget SaveBtn, ResolutionStepper, AliasingStepper, StartBtn, ExitBtn, FullscreenStepper;

var config array<string> ResolutionList;
var config int ResolutionIndex, AliasingIndex, FullscreenIndex;
var config string StartMap;

function Init(optional LocalPlayer LocPlay)
{
	Start();
	Advance(0);
	
	//bPauseOn=false;
	super.Init(LocPlay);
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	bWasHandled=false;
	
	switch(WidgetName)
	{
	case ('saveBtn') :
		SaveBtn = GFxClikWidget(Widget);
		SaveBtn.AddEventListener('CLIK_click', SaveOptions);
		bWasHandled=true;
		break;
	case ('startBtn') :
		StartBtn = GFxClikWidget(Widget);
		StartBtn.AddEventListener('CLIK_click', StartGame);
		bWasHandled=true;
	break;
		case ('exitBtn') :
		ExitBtn = GFxClikWidget(Widget);
		ExitBtn.AddEventListener('CLIK_click', ExitGame);
		bWasHandled=true;
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
	}

	return bWasHandled;
}

function SaveOptions(EventData data)
{
	local int ASI, RSI, FSI;
	local bool bUpdatedSettings;
	local string fs;

	ASI = AliasingStepper.GetInt("selectedIndex");
	RSI = ResolutionStepper.GetInt("selectedIndex");
	FSI = FullscreenStepper.GetInt("selectedIndex");
	bUpdatedSettings=false;

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

function StartGame(EventData data)
{
	if(data.mouseIndex==0)
	{
		//Close(true);
		ConsoleCommand("open " $ StartMap);
		//ConsoleCommand("open TowerOfAtrox_IntroLevel");
		//ConsoleCommand("open TowerOfAtrox_IntroLevel?game=ToA_GameInfo");
	}
}

function ExitGame(EventData data)
{
	if(data.mouseIndex==0)
	{
		//Close(true);
		ConsoleCommand("exit");
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
	WidgetBindings.Add((WidgetName="saveBtn", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="resolutionStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="aliasingStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="fullscreenStepper", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="startBtn", WidgetClass=class'GFxClikWidget'));
	WidgetBindings.Add((WidgetName="exitBtn", WidgetClass=class'GFxClikWidget'));

	TimingMode=TM_Real
	bPauseGameWhileActive=true
	bCaptureInput=true
}
