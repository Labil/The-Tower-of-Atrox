/*
 * Klasse av items som kan plukkes opp av spiller. Feks inventory (sverd, skjold, nøkler, fakkel).
 * Objektene har en variabel inventoryItem som addes til InventoryManager når de plukkes opp. 
 * Hovedfunksjonaliteten ligger i disse inventoryItems. 
 * Objektene som arver fra denne klassen representerer bare meshen.
 * 
 * Av Solveig Hansen 2013
 */
class ToA_PickupItem extends ToA_BaseItem
	abstract;

//Inventory item opprettes i itemklassene som arver fra denne. Torch setter InventoryTorch som sitt inventoryItem etc.
var ToA_InventoryItem inventoryItem;

//String som sendes videre til hud-en, og korresponderer med label navn på timelinen i flash swf-fila
var string PopupLabelName;

function InteractWithActor(ToA_Pawn hero)
{
	super.InteractWithActor(hero);
	if(inventoryItem != none)
	{
		hero.pawnInventory.PickUpInventory(inventoryItem);
		SetTimer(0.4f, false, 'ShowPopupDisplay');
		SetTimer(0.5f, false, 'DestroySelf');
	}
}

//Viser en popup som forklarer hva man har plukket opp og hvordan bruke det. Vises på Hud-en.
function ShowPopupDisplay()
{
	ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.ShowPopupDisplay(PopupLabelName);
}

DefaultProperties
{
}
