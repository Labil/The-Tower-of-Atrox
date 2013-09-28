package {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	
	public class MenuCursorHUD extends CursorSym {
		
		
		public function MenuCursorHUD(parentStage:DisplayObject) 
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
			
			import flash.external.ExternalInterface;
			ExternalInterface.call("UpdateMousePosition", x, y);
			
			
		}
	}
	
}
