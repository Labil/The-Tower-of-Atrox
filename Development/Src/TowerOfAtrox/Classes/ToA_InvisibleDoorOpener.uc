/*
 * Klasse for å åpne dører etter at et gitt mål er nådd, 
 * her er det å drepe en viss mengde fiender
 * 
 * requiredNumberOfEnemiesKilled kan settes i editoren, default 3.
 * 
 * av Solveig Hansen 2013
 */
class ToA_InvisibleDoorOpener extends ToA_ActorBase
	abstract;

var int numEnemiesKilled;
var() int requiredNumberOfEnemiesKilled;
var ToA_AnimatedDoor door;

function PostBeginPlay()
{
	super.PostBeginPlay();
    //ToA_GameInfo(WorldInfo.Game).doorOpener = self;
	FindDoor();
}

function FindDoor()
{
	local ToA_AnimatedDoor d;
	foreach VisibleCollidingActors(class'ToA_AnimatedDoor', d, 300.0f)
	{
		door = d;
		`Log("DOOR IS"@door);
	}

	if(door == none)
		`Log("Didn't find door in DoorOpener!!");
}

function AddEnemyKilled()
{
	`Log("Adding enemy killed point in invisible open door!");
	numEnemiesKilled += 1;
	CheckOpenConditions();
}

function CheckOpenConditions()
{
	if(numEnemiesKilled >= requiredNumberOfEnemiesKilled)
	{
		//TriggerEventClass(class'SeqEvent_ActivateOpenDoor', self, 1);
		`Log("Triggering event class in invisible open door!");
		door.OpenDoor();
	}
}

DefaultProperties
{
	begin object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	end object
	Components.Add(Sprite)

	//SupportedEvents.Add(class'SeqEvent_ActivateOpenDoor')
	numEnemiesKilled=0
	requiredNumberOfEnemiesKilled=1
}
