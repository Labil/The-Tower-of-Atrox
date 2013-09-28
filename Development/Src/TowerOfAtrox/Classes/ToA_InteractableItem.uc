/*
 * Klasse for objekter som spiller av en animasjon når spilleren klikker på dem. 
 * F.eks: Kister, bøker, dører etc.
 * Alle skeletal meshene må ha en AnimNodeCrossfader, og en animasjons-sekvens med navn "animation".
 * Bruker AnimNodeCrossfader fordi den har mulighet til å stoppe animasjonen på siste frame.
 * 
 * av Solveig Hansen 2013
 */
class ToA_InteractableItem extends ToA_BaseItem;

var AnimNodeCrossfader animNodeCrossfader;
var bool bPlayedAnimation;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	if(SkelComp != none)
		animNodeCrossfader = AnimNodeCrossfader(SkelComp.FindAnimNode('AnimCrossfadeNode')); 
	else
		`Log("Didn't find reference to skelMesh");
}

simulated event Destroyed()
{
	Super.Destroyed();
	
	//Viktig å sette animasjonsnoden til none, for den blir ikke garbage collected.
	animNodeCrossfader = None;
}

function InteractWithActor(ToA_Pawn hero)
{
	if(bPlayedAnimation || bIsDestroyed)
		return;
	super.InteractWithActor(hero);
	if(animNodeCrossfader != none)
	{
		animNodeCrossfader.PlayOneShotAnim('animation', ,,true); //true sørger for at animasjonen stopper på siste frame.
		bPlayedAnimation = true;
	}
	else
		`Log("Fant ikke animasjonsnode...");
}




DefaultProperties
{	
}
