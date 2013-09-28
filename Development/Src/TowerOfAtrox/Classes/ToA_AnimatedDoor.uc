class ToA_AnimatedDoor extends ToA_InteractableItem
	abstract;

function InteractWithActor(ToA_Pawn hero)
{
	//Denne funksjonen er tom, skal ikke kunne åpne dør med å klikke på!
	`Log("Denne døra er låst");
	//Lage til hud!
	super.InteractWithActor(hero);
}

function OpenDoor()
{
	if(bPlayedAnimation || bIsDestroyed)
		return;
	if(animNodeCrossfader != none)
	{
		animNodeCrossfader.PlayOneShotAnim('animation', ,,true); //true sørger for at animasjonen stopper på siste frame
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
