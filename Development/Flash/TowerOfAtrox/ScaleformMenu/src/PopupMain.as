package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	import scaleform.clik.controls.Button;
	
	
	public class PopupMain extends MovieClip 
	{
		
		public var _cursor:MenuCursor;
			
		public function PopupMain() 
		{
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			Mouse.hide();
			_cursor=new MenuCursor(stage);
			addChild(_cursor);
		}
	}
	
}
