class ToA_Mirror extends SceneCapture2DActor
	placeable;

var() TextureRenderTarget2D textureTarget;
var() float fieldOfView;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SceneCapture2DComponent(SceneCapture).SetCaptureParameters(textureTarget, fieldOfView, 20.0f, 500.0f);

}

DefaultProperties
{
	Begin Object Name=SceneCapture2DComponent0
	End Object
	SceneCapture=SceneCapture2DComponent0
	Components.Add(SceneCapture2DComponent0)

	textureTarget=TextureRenderTarget2D'PilotTestStuff.RenderTextures.ToA_CharPortrait_RenderTexture'
	fieldOfView=80.0f
}
