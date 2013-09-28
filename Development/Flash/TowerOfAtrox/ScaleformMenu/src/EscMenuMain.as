package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;//For å kalle unrealscript kode fra actionscript
	import scaleform.clik.controls.Button;
	
	
	public class EscMenuMain extends MovieClip 
	{
		
		public var _cursor:MenuCursor;
		
		
		public function EscMenuMain() 
		{
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			HideOptionsMenu();
			HideControlsMenu();
			ShowMainMenu();
			
			Mouse.hide();
			_cursor=new MenuCursor(stage);
			addChild(_cursor);
			
		}
		
		private function ShowControlsMenu() : void
		{
			controlsMenu.visible = true;
			controlsMenu.backBtn.addEventListener(MouseEvent.CLICK, onControlsBackClicked);
		}
		
		private function HideControlsMenu() : void
		{
			controlsMenu.visible = false;
			controlsMenu.backBtn.removeEventListener(MouseEvent.CLICK, onControlsBackClicked);
		}
		
		private function onControlsBackClicked(me:MouseEvent) : void
		{
			HideControlsMenu();
			ShowOptionsMenu();
		}
		
		private function ShowOptionsMenu() : void
		{
			optionsMenu.visible = true;
			
			optionsMenu.settingsBtn.addEventListener(MouseEvent.CLICK, onSettingsClicked);
			optionsMenu.controlsBtn.addEventListener(MouseEvent.CLICK, onControlsClicked);
			optionsMenu.backBtn.addEventListener(MouseEvent.CLICK, onOptionsBackClicked);
		}
		
		private function HideOptionsMenu() : void
		{
			optionsMenu.visible = false;
			optionsMenu.settingsBtn.removeEventListener(MouseEvent.CLICK, onSettingsClicked);
			optionsMenu.controlsBtn.removeEventListener(MouseEvent.CLICK, onControlsClicked);
			optionsMenu.backBtn.removeEventListener(MouseEvent.CLICK, onOptionsBackClicked);
			
		}
		
		private function ShowMainMenu() : void 
		{
			mainMenu.visible=true;
			
			mainMenu.resumeBtn.addEventListener(MouseEvent.CLICK, onResumeClicked);
			mainMenu.optionsBtn.addEventListener(MouseEvent.CLICK, onOptionsClicked);
			mainMenu.exitBtn.addEventListener(MouseEvent.CLICK, onExitClicked);
		}
		
		private function onOptionsBackClicked(me:MouseEvent):void
		{
			HideOptionsMenu();
			ShowMainMenu();
		}
		
		private function onSettingsClicked(me:MouseEvent):void
		{
			trace("On settings clicked!");
		}
		
		private function onControlsClicked(me:MouseEvent):void
		{
			HideOptionsMenu();
			ShowControlsMenu();
		}
		
		private function HideMainMenu():void
		{
			mainMenu.visible = false;
			mainMenu.resumeBtn.removeEventListener(MouseEvent.CLICK, onResumeClicked);
			mainMenu.optionsBtn.removeEventListener(MouseEvent.CLICK, onOptionsClicked);
			mainMenu.exitBtn.removeEventListener(MouseEvent.CLICK, onExitClicked);
		}
		
		private function onResumeClicked(e:MouseEvent) :void
		{
			trace("Resume clicked!");
			//ExternalInterface.call(
		}
		
		private function onExitClicked(e:MouseEvent) :void
		{
			trace("Exitclicked!");
		}
		
		private function onOptionsClicked(e:MouseEvent) : void 
		{
			HideMainMenu();
			ShowOptionsMenu();
		}
	}
	
}
