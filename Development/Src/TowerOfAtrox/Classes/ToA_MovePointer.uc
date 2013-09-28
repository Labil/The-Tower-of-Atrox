class ToA_MovePointer extends ToA_ActorBase;

var() StaticMeshComponent Mesh;

DefaultProperties
{
	begin object class=StaticMeshComponent Name=PointerMesh
		BlockActors=false
		CollideActors=false
		BlockRigidBody=false
		StaticMesh=StaticMesh'ToA_SelectionMarkers.Meshes.ToA_MouseDecal_Mesh'
		Scale3D=(X=2.0,Y=2.0,Z=2.0)
		Rotation=(Pitch=0,Yaw=0,Roll=0)
	end object
	Mesh=PointerMesh
	CollisionComponent=PointerMesh
	Components.Add(PointerMesh)
}
