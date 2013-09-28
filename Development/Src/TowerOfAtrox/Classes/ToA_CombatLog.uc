class ToA_CombatLog extends ToA_ActorBase;

var Array<string> combatLog;
var const int numLogEntries;
var GFxHUD hudRef;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(0.2f, false, 'Setup');

}

function Setup()
{
	GetHudReference();

	if(hudRef != none)
	{
		SetUpLog();
		//AddEntriesToLog("Dette er en test.");
	}
}

function GetHudReference()
{
	hudRef = ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie;

	if(hudRef == none)
		`Log("HUD MOVIE NOT FOUND!");
	else
		`Log("HUD MOVIE FOUND");
}

function AddEntriesToLog(string entry)
{
	local int i;

	
	for(i = 0; i < combatLog.Length-1; i++)
	{
		//`Log("Flytter combat entries");
		combatLog[i] = combatLog[i + 1];
	}

	combatLog[combatLog.Length-1] = entry;
	

	hudRef.UpdateCombatLog(self);
}

function SetUpLog()
{
	local int i;
	for(i = 0; i < numLogEntries; i++)
	{
		combatLog[i] = "";
	}
}

DefaultProperties
{
	numLogEntries=8
}
