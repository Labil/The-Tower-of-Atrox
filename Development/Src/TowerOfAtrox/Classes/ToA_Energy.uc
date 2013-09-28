class ToA_Energy extends ToA_ActorBase;

var const float totalEnergyAmount;
var float currentEnergyAmount;
var float energyRefillAmount;

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(currentEnergyAmount + energyRefillAmount <= totalEnergyAmount)
		RefillEnergy();

	if(currentEnergyAmount < 20)
		ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.DisableAttackButton();
	else
		ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.EnableAttackButton();
}

function float GetEnergyAmountLeft()
{
	return currentEnergyAmount;
}

function bool CheckIfEnoughEnergy(int amount)
{
	if(currentEnergyAmount - amount < 0)
	{
		ToA_GameInfo(WorldInfo.Game).hudWorld.combatLog.AddEntriesToLog("Not enough energy!");
		return false;
	}
	else
	{
		return true;
	}
}

function RefillEnergy()
{
	currentEnergyAmount += energyRefillAmount;
}

function UseEnergyPoints(int amount)
{
	currentEnergyAmount -= amount;
	`Log("Current energy amount left:"@currentEnergyAmount);
}

//Til HUD
function int GetPercentOfEnergyLeft()
{
	return int((currentEnergyAmount/totalEnergyAmount) * 100.0f);
}

function SetEnergyRefillAmount(float boost)
{
	energyRefillAmount += boost;
}

DefaultProperties
{
	totalEnergyAmount=100.0f
	currentEnergyAmount=100.0f
	energyRefillAmount=0.1f
}
