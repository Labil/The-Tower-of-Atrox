package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.display.StageScaleMode;
	import scaleform.clik.controls.Button;
	import flash.system.fscommand;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.controls.OptionStepper;
	
	public class Atrox_MainMenuClass extends MovieClip
	{
		
		public var _cursor:MenuCursor;
		public var _resStepper:OptionStepper;
		public var _fullscreenStepper:OptionStepper;

		public function Atrox_MainMenuClass() 
		{
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			
			HideOptionsMenu();
			HideControlsMenu();
			HideSettingsMenu();
			ShowMainMenu();
			
			//logoIntro.gotoAndPlay(1);
			
			Mouse.hide();
			_cursor=new MenuCursor(stage);
			addChild(_cursor);
			
			settingsMenu.aliasingStepper.dataProvider=new DataProvider(["None", "2x", "4x", "8x", "16x"]);
			settingsMenu.gammaStepper.dataProvider=new DataProvider([0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]);
			
			_fullscreenStepper=settingsMenu.fullscreenStepper;
			_fullscreenStepper.dataProvider=new DataProvider(["Windowed", "Fullscreen"]);
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
		
		private function ShowSettingsMenu() : void
		{
			settingsMenu.visible = true;
			settingsMenu.cancelBtn.addEventListener(MouseEvent.CLICK, onSettingsCancelClicked);
			settingsMenu.saveBtn.addEventListener(MouseEvent.CLICK, onSettingsSaveClicked);
		}
		private function HideSettingsMenu() : void 
		{
			settingsMenu.visible= false;
			settingsMenu.cancelBtn.removeEventListener(MouseEvent.CLICK, onSettingsCancelClicked);
			settingsMenu.saveBtn.removeEventListener(MouseEvent.CLICK, onSettingsSaveClicked);
		}
		
		private function onSettingsCancelClicked(e:MouseEvent) : void {
			
			HideSettingsMenu();
			ShowOptionsMenu();
		}
		
		private function onSettingsSaveClicked(e:MouseEvent) : void {
			
			//fscommand("saveOptions "+_resStepper.selectedItem.toString()+" "+_fullscreenStepper.selectedItem.toString());
			HideSettingsMenu();
			ShowOptionsMenu();
		}
		
		private function ShowMainMenu() : void 
		{
			mainMenu.visible=true;
			
			mainMenu.optionsBtn.addEventListener(MouseEvent.CLICK, onOptionsClicked);
		}
		
		private function onOptionsClicked(e:MouseEvent) : void 
		{
			HideMainMenu();
			ShowOptionsMenu();
		}
		
		private function onOptionsBackClicked(me:MouseEvent):void
		{
			HideOptionsMenu();
			ShowMainMenu();
		}
		
		private function onSettingsClicked(me:MouseEvent):void
		{
			HideOptionsMenu();
			ShowSettingsMenu();
		}
		
		private function onControlsClicked(me:MouseEvent):void
		{
			HideOptionsMenu();
			ShowControlsMenu();
		}
		
		private function HideMainMenu():void
		{
			mainMenu.visible = false;
			mainMenu.optionsBtn.removeEventListener(MouseEvent.CLICK, onOptionsClicked);
		}
		
		private function onResumeClicked(e:MouseEvent) :void
		{
			trace("Resume clicked!");
			//ExternalInterface.call(
		}
	
	}
	
}
