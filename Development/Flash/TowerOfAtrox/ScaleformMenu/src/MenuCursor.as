package {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	
	public class MenuCursor extends CursorSym 
	{
		
		public function MenuCursor(parentStage:DisplayObject) 
		{
			trace("Mouse initialized");
			mouseEnabled=false;
			mouseChildren=false;
			parentStage.addEventListener(MouseEvent.MOUSE_MOVE, MoveCursor);
			
		}
		
		private function MoveCursor(e:MouseEvent):void 
		{
			x=e.stageX;
			y=e.stageY;
			
		}
	}
	
}
