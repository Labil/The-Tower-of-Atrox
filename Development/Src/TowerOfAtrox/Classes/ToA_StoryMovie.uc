class ToA_StoryMovie extends GFxMoviePlayer;

function Init(optional LocalPlayer LocPlay)
{
	Start();
	Advance(0);
	
	super.Init(LocPlay);
}

function HideStoryMovie()
{
	Close(true);
}

DefaultProperties
{
	MovieInfo=SwfMovie'ScaleformMenuGFx.SFMFrontEnd.Atrox_Story'
	TimingMode=TM_Real
	bPauseGameWhileActive=false
	bCaptureInput=true
}
