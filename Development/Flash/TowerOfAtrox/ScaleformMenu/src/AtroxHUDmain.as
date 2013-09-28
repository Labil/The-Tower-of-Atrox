package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;//For å kalle unrealscript kode fra actionscript
	import scaleform.clik.controls.Button;
	import scaleform.gfx.Extensions;
	import flash.display.DisplayObjectContainer;
	import flashx.textLayout.formats.Float;
	import flash.display.StageAlign;
	
	public class AtroxHUDmain extends MovieClip 
	{
		
		public var _cursor:MenuCursorHUD;
		
		
		public function AtroxHUDmain() 
		{
			waitForStage();
			
		}
  
		private function waitForStage() : void
		{
			if (stage) {init();}
			else {addEventListener(Event.ADDED_TO_STAGE, init);}
		}
  
 		private function init(e:Event = null) : void 
  		{
   			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			/*stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			stage.addEventListener(Event.RESIZE, resizeHandler); */
			
			

			
			popup.visible = false;
			popup.gotoAndStop(1);
			
			Mouse.hide();
			_cursor=new MenuCursorHUD(stage);
			addChild(_cursor);
			
			//recurseStage(stage);
			
   		}
		
		public function resizeHandler(evt:Event):void 
		{ 
			// instructions here (elements to stretch, resposition, etc.) 
		} 
		
		/*public function recurseStage(dOC:DisplayObjectContainer)
		{
			var numCh = dOC.numChildren;
			for(var i = 0; i < numCh; i++)
			{
				var child = dOC.getChildAt(i); 
				
				// Change the width directly. 
				//child.width *= 1.5;
				child.scaleX = 1.1;
				child.scaleY = 1.1;
				
				trace("child: " + child + " at i: " + i);
	
				if (child is DisplayObjectContainer && child.numChildren > 0)
				{
					recurseStage(child);
				}
			}
		}*/
		
	}
	
}
