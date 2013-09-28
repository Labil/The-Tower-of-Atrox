package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	
	public class Atrox_StoryMain extends MovieClip
	{
		public var _cursor:MenuCursor;

		public function Atrox_StoryMain() 
		{
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			Mouse.hide();
			_cursor=new MenuCursor(stage);
			addChild(_cursor);
			
			addEventListener(MouseEvent.CLICK, OnScreenClick);
		}
		
		public function OnScreenClick(me:MouseEvent):void
		{
			trace("Hei");
			ExternalInterface.call("HideStoryMovie");
		}

	}
	
}