class ToA_AnimatedDoor extends ToA_InteractableItem
	abstract;

function InteractWithActor(ToA_Pawn hero)
{
	//Denne funksjonen er tom, skal ikke kunne �pne d�r med � klikke p�!
	`Log("Denne d�ra er l�st");
	//Lage til hud!
	super.InteractWithActor(hero);
}

function OpenDoor()
{
	if(bPlayedAnimation || bIsDestroyed)
		return;
	if(animNodeCrossfader != none)
	{
		animNodeCrossfader.PlayOneShotAnim('animation', ,,true); //true s�rger for at animasjonen stopper p� siste frame
		bPlayedAnimation = true;
		SetCollision(false, false);
		bIsDestroyed = true;
		SetTimer(1.5f, false, 'MakeMaterialNormal');
	}
	else
		`Log("Didn't find the animation node...");

	
}

DefaultProperties
{
}
