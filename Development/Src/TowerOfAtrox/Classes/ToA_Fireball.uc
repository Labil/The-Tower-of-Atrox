class ToA_Fireball extends ToA_MagicBall;

DefaultProperties
{
	Begin Object Name=Particles
		bAutoActivate=true 
		Scale=0.4f
		Template=ParticleSystem'ToA_Particles.Particles.ToA_GreenGoo_Particle'
		//Template=ParticleSystem'ToA_Particles.Particles.ToA_TorchFlame_Particle'
		SecondsBeforeInactive=0.5f
		End Object
	particleEffect=Particles
	Components.Add(Particles)
}
