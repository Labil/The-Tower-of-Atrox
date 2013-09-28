class ToA_IntroGameInfo extends GameInfo;

var ToA_IntroMenu introMenu;

var AudioComponent splatSound1;
var AudioComponent splatSound2;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(3.0f, false, 'StartIntro');
}

function StartIntro()
{
	introMenu = new class'ToA_IntroMenu'; 
	introMenu.MovieInfo = SwfMovie'ScaleformMenuGFx.SFMFrontEnd.Atrox_IntroMenu'; 
	introMenu.Start();

	SetTimer(6.0f, false, 'LoadMainMenu');
	SetTimer(1.9f, false, 'PlayFirstSplat');
	SetTimer(3.9f, false, 'PlaySecondSplat');
}

function PlayFirstSplat()
{
	splatSound1.Play();
}
function PlaySecondSplat()
{
	splatSound2.Play();
}

function LoadMainMenu()
{
	ConsoleCommand("open TowerOfAtrox_IntroLevel?game=ToA_GameInfo" $ "?ShouldLoadMenu=1" $ "?ShouldLoadGameSave=0");
}


DefaultProperties
{
	begin object class=AudioComponent Name=AudioComp
		SoundCue=SoundCue'ToA_Lyder.IntroMenuSounds.Splat_small_Cue'
		bAutoPlay=false
	end object
	splatSound1=AudioComp
	Components.Add(AudioComp)

	begin object class=AudioComponent Name=AudioComp2
		SoundCue=SoundCue'ToA_Lyder.IntroMenuSounds.Splat_large_Cue'
		bAutoPlay=false
	end object
	splatSound2=AudioComp2
	Components.Add(AudioComp2)
}
