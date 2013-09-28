package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.StageScaleMode;
	import scaleform.clik.controls.Button;
	
	public class Atrox_DeathMenuMain extends MovieClip
	{
		public var _cursor:MenuCursor;

		public function Atrox_DeathMenuMain() 
		{
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			Mouse.hide();
			_cursor=new MenuCursor(stage);
			addChild(_cursor);
		}

	}
	
}
