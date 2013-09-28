Interface ITargetInterface;

function InteractWithActor(ToA_Pawn hero);

function MakeMaterialBrighter();

function MakeMaterialNormal();

function float GetInteractDistance();

function OnMouseOver();

function OnMouseAway();

function OnMouseClick();

function OnMouseClickAway();

function bool IsActorTargeted();

function bool IsActorHoveredOver();

/** Checks to see if the target has been destroyed or killed. */
function bool CheckActorDestroyed();

function Texture2D GetTooltipTexture();

DefaultProperties
{
}