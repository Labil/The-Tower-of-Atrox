/*
 * Kaller den med prefix X pga den er avhengig av at andre filer er kompilert før den, 
 * og compileren kompilerer filene i alfabetisk rekkefølge så vidt jeg har skjønt.
 * Kunne også skrevet :
 * class SaveFile extends Object dependson(Toa_Pawn, Toa_GameInfo....etc etc), men syns det her ble lettere.
 * 
 * Dette objektet skrives ut til en tekstfil og lagres på harddisken med et navn og path spesifisert i ToA_EscMenu, for det  er via menyen at vi lagrer
 */
class X_SaveFile extends Object; 

var int numEnemiesSaved;
var int numDestructiblesSaved;
var int numBaseItemsSaved;

var ToA_Pawn_SaveData heroSaveObj;
var GameInfo_SaveData gameInfoSaveObj;
var Enemy_SaveData enemiesSaveObjs[50];
var Destructible_SaveData destructibles[100];
var BaseItem_SaveData baseItemObjs[300];
var Inventory_SaveData inventoryObj;


DefaultProperties
{
}
