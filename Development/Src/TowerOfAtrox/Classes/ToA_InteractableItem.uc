/*
 * Klasse for objekter som spiller av en animasjon n�r spilleren klikker p� dem. 
 * F.eks: Kister, b�ker, d�rer etc.
 * Alle skeletal meshene m� ha en AnimNodeCrossfader, og en animasjons-sekvens med navn "animation".
 * Bruker AnimNodeCrossfader fordi den har mulighet til � stoppe animasjonen p� siste frame.
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
	
	//Viktig � sette animasjonsnoden til none, for den blir ikke garbage collected.
	animNodeCrossfader = None;
}

function InteractWithActor(ToA_Pawn hero)
{
	if(bPlayedAnimation || bIsDestroyed)
		return;
	super.InteractWithActor(hero);
	if(animNodeCrossfader != none)
	{
		animNodeCrossfader.PlayOneShotAnim('animation', ,,true); //true s�rger for at animasjonen stopper p� siste frame.
		bPlayedAnimation = true;
	}
	else
		`Log("Fant ikke animasjonsnode...");
}




DefaultProperties
{	
}
