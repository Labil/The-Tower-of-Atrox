class ToA_DeathMenu extends GFxMoviePlayer;


var GFxClikWidget quitBtn, continueBtn;
var GFxObject RootMC, deathNote;
var ToA_GameInfo gameRef;
var string currentLevel;

function Init(optional LocalPlayer LocPlay)
{
	Start();
	Advance(0);

	RootMC = GetVariableObject("root");
	deathNote = RootMC.GetObject("deathNote");

	SetDeathCaption("This is a test...");
	
	super.Init(LocPlay);
}

function SetDeathCaption(string s)
{
	deathNote.SetText(s);
}

event bool WidgetInitialized(Name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	bWasHandled = false;

	switch(WidgetName)
	{
	case ('quitBtn') :
		quitBtn = GFxClikWidget(Widget);
		quitBtn.AddEventListener('CLIK_click', ExitGame);
		bWasHandled=true;
		break;
	case('continueBtn'):
		continueBtn = GFxClikWidget(Widget);
		continueBtn.AddEventListener('CLIK_click', LoadGame);
		bWasHandled=true;
		break;
	default:
		break;
	}

	return bWasHandled;
}

function LoadGame(EventData data)
{
	//local int death;
//	death = gameRef.GetTimesDied();
	if(data.mouseIndex==0)
	{
		//Close();
		ConsoleCommand("open "$ currentLevel $ "?ShouldLoadMenu=0" $ "?ShouldLoadGameSave=0" $ "?ShouldDisplayStory=0");
	}
}

function ExitGame(EventData data)
{
	if(data.mouseIndex == 0)
	{
		//Close();
		ConsoleCommand("open TowerOfAtrox_IntroLevel" $ "?ShouldLoadMenu=1" $ "?ShouldLoadGameSave=0" $ "?ShouldDisplayStory=0");
		//ConsoleCommand("Quit");
	}
}



DefaultProperties
{
	MovieInfo=SwfMovie'ScaleformMenuGFx.SFMFrontEnd.AtroxDeathMenu'

	WidgetBindings.Add((WidgetName="quitBtn",WidgetClass=class'GFxCLIKWidget'))
	WidgetBindings.Add((WidgetName="continueBtn",WidgetClass=class'GFxCLIKWidget'))

	TimingMode=TM_Real
	bPauseGameWhileActive=true
	bCaptureInput=true

}