/*
 * Kaller den med prefix X pga den er avhengig av at andre filer er kompilert f�r den, 
 * og compileren kompilerer filene i alfabetisk rekkef�lge s� vidt jeg har skj�nt.
 * Kunne ogs� skrevet :
 * class SaveFile extends Object dependson(Toa_Pawn, Toa_GameInfo....etc etc), men syns det her ble lettere.
 * 
 * Dette objektet skrives ut til en tekstfil og lagres p� harddisken med et navn og path spesifisert i ToA_EscMenu, for det  er via menyen at vi lagrer
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
