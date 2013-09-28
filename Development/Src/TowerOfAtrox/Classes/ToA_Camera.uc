/*
 * En klasse som extender Camera
 * Går også an å implementere CalcCamera() i Pawn-klassen
 * for å lage eget kamera, men dette tilbyr noe simplere funksjonalitet
 */
class ToA_Camera extends Camera;

var Vector cameraAdjust;
var Vector screenAdjust;
var float rotateAdjust;
var float camPitch;
var ToA_Wall OccludingObj;

var bool bCamIsIso;

var int i;
/* 
 * UpdateViewTarget kalles hver frame og oppdaterer view target
 * til dets nye posisjon, rotasjon, og fov. Ved bruk av custom kameraer
 * er dette den vikigste funksjonen å override for å implementere ønsket
 * kameraoppførsel. Ifølge http://udn.epicgames.com/Three/CameraTechnicalGuide.html
 */

//TViewTarget er data som definerer view target, det kameraet skal peke mot
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local Vector Loc, Pos, HitLocation, HitNormal;
	local Rotator Rot;
	local Actor HitActor;
	local CameraActor CamActor;
	local bool bDoNotApplyModifiers;
	local TPOV OrigPOV;
	local Vector PawnLocOffset;
	//local float colRadius, colHeight, zPosOffset;

	PerspectiveAdjustment();
	
	if(ToA_GamePlayerController(PCOwner) != none)
		bCamIsIso = ToA_GamePlayerController(PCOwner).bCamIsIso;

	if(bCamIsIso)
		CameraStyle = 'Isometric';
	else
		CameraStyle = 'FreeCam_Default';

	if(PendingViewTarget.Target != none && OutVT == ViewTarget && BlendParams.bLockOutgoing)
		return;

	//Forrige POV
	OrigPOV = OutVT.POV;
	//Default FOV for viewtarget, settes i DefaultProperties
	OutVT.POV.FOV = DefaultFOV;
	//camera actor vi ser gjennom
	CamActor = CameraActor(OutVT.Target);
	if(CamActor != none)
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);
		//Henter aspect ratio fra CameraActor
		bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		OutVT.AspectRatio = CamActor.AspectRatio;
		//Sjekk om cameraActor vil override PostProcess settings som blir brukt
		CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CamActor.CamOverridePostProcess;
	}
	else
	{
		if(PCOwner.Pawn != none)
		{
			//Hvis pawn ikke overrider camera view så fortsetter vi med iso-kameraet
			if(Pawn(OutVT.Target) == none || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV))
			{
				//Ikke bruk modifiers ved bruk av debug kamera modes
				bDoNotApplyModifiers = true;

				switch(CameraStyle)
				{
					case 'Fixed':
						OutVt.POV = OrigPOV;
						break;
					case 'ThirdPerson':
					case 'FreeCam':
						Loc = OutVT.Target.Location;
						Rot = OutVT.Target.Rotation;

						if(CameraStyle == 'FreeCam')
						{
							Rot = PCOwner.Rotation;
						}
						Loc += FreeCamOffset >> Rot;

						Pos = Loc - Vector(Rot) * FreeCamDistance;

						HitActor = Trace(HitLocation, HitNormal, Pos, Loc, false, vect(12,12,12));
						OutVT.POV.Location = (HitActor == none) ? Pos : HitLocation;
						OutVT.POV.Rotation = Rot;
						break;
					case 'Isometric':
						//Hvis spilleren prøver å zoome lengre ut enn tillatt
						if(FreeCamDistance < 200) {FreeCamDistance = 200;}
						if(FreeCamDistance > 700) {FreeCamDistance = 700;}
						//Når spilleren roterer kamera forbi 0 eller 360 settes verdien sømløst til 360 eller 0 respektivt
						if(rotateAdjust > 360) {rotateAdjust = 0;}
						if(rotateAdjust < 0) {rotateAdjust = 360;}
				
						//Kamerarotasjon
						Rot = OutVT.Target.Rotation;
						Rot.Pitch = (-55* DegToRad) * RadToUnrRot; //Pitch er rotasjon rundt Y
						Rot.Yaw = ((rotateAdjust+90) * DegToRad) * RadToUnrRot; //Yaw er rotasjon rundt Z
						Rot.Roll = (0.0f * DegToRad) * RadToUnrRot; //Roll er rotasjon rundt X
				
						//Loc.X = PCOwner.Pawn.Location.X - 64; 
						//Loc.Y = PCOwner.Pawn.Location.Y -64;
						Loc.X = PCOwner.Pawn.Location.X; 
						Loc.Y = PCOwner.Pawn.Location.Y;
						Loc.Z = PCOwner.Pawn.Location.Z;

						Pos = Loc - Vector(Rot) * FreeCamDistance;

						OutVT.POV.Location = Pos;
						OutVT.POV.Rotation = Rot;
						
						//
						PawnLocOffset = PCOwner.Pawn.Location;
						/*PCOwner.Pawn.GetBoundingCylinder(colRadius, colHeight);
						zPosOffset = colHeight/2;
						PawnLocOffset.Z -= zPosOffset;*/ //Ofsetter med ca halve høyden på pawn så tracet treffer lang beina i stedet.

						foreach TraceActors(class'ToA_Wall', OccludingObj, HitLocation, HitNormal, PawnLocOffset, Pos, vect(1,1,1)) //siste extent gjør at den tracer Non-Zero-Extent og ikke Zero Extent! Viktig!
						{
							if(OccludingObj != none)
							{
								OccludingObj.Hide();
								OccludingObj.ClearAllTimers();
								SetTimer(OccludingObj.GetTimeHidden(), false,'Show', OccludingObj);
							}
						}

						break;
					case 'FirstPerson': 
						OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
						break;
					default:
						OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
						break;
					}
			}
		}
	}
	if(!bDoNotApplyModifiers)
	{
		//Her kan kamera modifiers legges til (eks view shakes)
		ApplyCameraModifiers(DeltaTime, OutVT.POV);
	}
}


function PerspectiveAdjustment()
{
	screenAdjust.X += cameraAdjust.X;
	screenAdjust.Y += cameraAdjust.Y;
	screenAdjust.Z += cameraAdjust.Z;
}

DefaultProperties
{
	DefaultFOV=60.f
	bCamIsIso=true;
	rotateAdjust=-180.0f
	FreeCamDistance=400
	camPitch=20.0f
}
