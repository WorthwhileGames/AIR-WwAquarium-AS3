package 
{
    import flash.ui.Keyboard;
    
    import org.wwlib.starling.WwSprite;
    import org.wwlib.utils.WwDebug;
    import org.wwlib.utils.WwDeviceInfo;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.events.TouchEvent;
    import starling.textures.RenderTexture;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
    public class QcStarlingAquarium extends starling.display.Sprite
    {

		private var __debug:WwDebug;
		private var __appStateAquarium:QcAppStateAquarium;
		
		private var __renderTexture:RenderTexture;
		private var __canvas:Image;
		private var __backgroundWrapper:WwSprite;
		private var __backgroundWrapperOffsetX:Number;
		private var __backgroundSprite:WwSprite;
		private var __backgroundSpriteBG:WwSprite;
		
        public function QcStarlingAquarium()
        {
			__debug = WwDebug.instance;

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			
        }
        
		public function setupTextures():void
		{
			__backgroundWrapper = new WwSprite();
			__backgroundWrapperOffsetX = 0;
			
			addChild(__backgroundWrapper);
			
			__renderTexture = new RenderTexture(WwDeviceInfo.instance.canvasWidth, WwDeviceInfo.instance.canvasHeight);
			
			__canvas = new Image(__renderTexture);
			__backgroundWrapper.addChild(__canvas);
			
			__backgroundSprite = new WwSprite();
			__backgroundWrapper.addChild(__backgroundSprite);
			__backgroundSprite.onReadyCallback = onBackgroundSpriteReady;
			

			__backgroundWrapper.visible = false;
		}
				
		public function setPage(url:String):void
		{
			if (url)
			{
				__backgroundWrapper.visible = false;
				__backgroundWrapper.scaleX = 1.0;
				__backgroundWrapper.scaleY = 1.0;
				//__backgroundSprite.onReadyCallback = onColoringPageReady;
				
				__renderTexture.clear();
				__backgroundSprite.loadImage(url);
			}
			else
			{
				if (__appStateAquarium) __appStateAquarium.onBackgroundSpriteReady(null);
				__backgroundSprite.clearImg();
			}
		}
		
		public function onBackgroundSpriteReady(url:String):void
		{
			__backgroundWrapper.visible = true;
			if (__appStateAquarium) __appStateAquarium.onBackgroundSpriteReady(url);
			
			__debug.msg("onBackgroundSpriteReady: " + url + ", __backgroundWrapper.x: " + __backgroundWrapper.x, "1");
		}
		
		
        private function onAddedToStage(event:starling.events.Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onRemovedFromStage(event:starling.events.Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
		
		private function onKey(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
				Starling.current.showStats = !Starling.current.showStats;
			else if (event.keyCode == Keyboard.X)
				Starling.context.dispose();
		}
		
		
		public function set appStateAquarium(_state:QcAppStateAquarium):void
		{
			__appStateAquarium = _state;
		}
		
		public override function dispose():void
		{
			__backgroundWrapper.removeChildren();
			__backgroundWrapper.removeEventListeners();
			__backgroundWrapper = null;
			
			__backgroundSprite.removeEventListeners();
			__backgroundSprite.removeChildren();
			__backgroundSprite = null;
		}

    }
}