package org.wwlib.starling
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.wwlib.WwAquarium.ui.UI_AquariumMenu;
	import org.wwlib.WwColoring.anim.UI_ColoringFrame;
	import org.wwlib.flash.WwAlertsManager;
	import org.wwlib.flash.WwAquariumDecor;
	import org.wwlib.flash.WwAquariumDecorController;
	import org.wwlib.flash.WwAquariumFish;
	import org.wwlib.flash.WwAquariumFishController;
	import org.wwlib.flash.WwAquariumMenuController;
	import org.wwlib.flash.WwAquariumMenuDecorTools;
	import org.wwlib.flash.WwAquariumMenuFishTools;
	import org.wwlib.utils.WwDeviceInfo;
	import org.wwlib.utils.WwGoViral;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.RenderTexture;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
    public class WwAquariumScene extends WwScene
    {
		public static const UI_MODE_NONE:String = "NONE";
		public static const UI_MODE_FISH:String = "FISH";
		public static const UI_MODE_DECOR:String = "DECOR";
		public static const UI_MODE_DECOR_TOOLS:String = "DECOR_TOOLS";
		public static const UI_MODE_FISH_TOOLS:String = "FISH_TOOLS";
		
        private var mRenderTexture:RenderTexture;
        private var mCanvas:Image;
		
		private var __accelX:Number;
		private var __accelY:Number;
		private var __accelZ:Number;
		private var __accelXStart:Number;
		private var __accelYStart:Number;
		private var __accelZStart:Number;
		private var __accelStarted:Boolean;
		
		private var __backgroundWrapper:WwSprite;
		private var __backgroundWrapperOffsetX:Number;
		private var __backgroundSprite:WwSprite;
		private var __backgroundSpriteBG:WwSprite;
		
		private var __touchEvent:TouchEvent
		
		private var __UI_AquariumFrame:UI_ColoringFrame;
		private var __UI_AquariumMenu:UI_AquariumMenu;
		private var __AquariumMenuController:WwAquariumMenuController;
		private var __UI_AquariumBackgroundBitmap:Bitmap;
		
		private var __uiActive:Boolean;
		
		private var __fishPlaneFG:MovieClip;
		private var __fishControllerFG:WwAquariumFishController;
		private var __fishPlaneBG:MovieClip;
		private var __fishControllerBG:WwAquariumFishController;
		
		private var __decorPlaneFG:MovieClip;
		private var __decorControllerFG:WwAquariumDecorController;
		private var __decorPlaneBG:MovieClip;
		private var __decorControllerBG:WwAquariumDecorController;
		
		private var __UIMode:String;
		private var __UIModeActiveType:String;
		
		private var __activeFish:WwAquariumFish;
		private var __activeObject:WwAquariumDecor;
		
		
        public function WwAquariumScene(scene_manager:WwSceneManager)
        {
			super(scene_manager);
			
			WwSprite.FLASH_STAGE.parent.addEventListener(MouseEvent.MOUSE_UP, onGlobalMouseUp);
			WwSprite.FLASH_STAGE.parent.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			// Note: blocking propagation to Starling is accomplished using the uiActive flag
			uiActive = false;
			
			__UIMode = UI_MODE_NONE;
        }
		
		public function onGlobalMouseUp(e:Event):void
		{
			if (__AquariumMenuController)
			{
				__AquariumMenuController.onGlobalMouseUp(e);
			}
			uiActive = false;
		}
		
		public function onMouseDown(e:Event):void
		{
			
			var mx:Number = WwSprite.FLASH_STAGE.mouseX;
			var my:Number = WwSprite.FLASH_STAGE.mouseY;
			
			switch(__UIMode)
			{
				case UI_MODE_FISH:
				{
					__fishControllerFG.newObject(__UIModeActiveType, mx, my);
					break;
				}
				case UI_MODE_DECOR:
				{
					__decorControllerFG.newObject(__UIModeActiveType, mx, my);
					break;
				}
				default:
				{
					break;
				}
			}
			
			__UIMode = UI_MODE_NONE;
			
		}
		
		public override function initWithXML(xml:XML):void
		{
			//super.initWithXML(xml);
			
			__UI_AquariumBackgroundBitmap = new Bitmap();
			__UI_AquariumBackgroundBitmap.visible = false;
			WwSprite.FLASH_STAGE.addChild(__UI_AquariumBackgroundBitmap);
			
			__fishPlaneBG = new MovieClip();
			WwSprite.FLASH_STAGE.addChild(__fishPlaneBG);
			
			__decorPlaneBG = new MovieClip();
			WwSprite.FLASH_STAGE.addChild(__decorPlaneBG);
			
			__fishPlaneFG = new MovieClip();
			WwSprite.FLASH_STAGE.addChild(__fishPlaneFG);
			
			__decorPlaneFG = new MovieClip();
			WwSprite.FLASH_STAGE.addChild(__decorPlaneFG);
			
			__UI_AquariumMenu = new UI_AquariumMenu();
			WwSprite.FLASH_STAGE.addChild(__UI_AquariumMenu);
			//MAGIC NUMBER
			__UI_AquariumMenu.x = 864;
			__UI_AquariumMenu.y = 64;
			__AquariumMenuController = new WwAquariumMenuController(this, __UI_AquariumMenu);
			
			
			__UI_AquariumFrame = new UI_ColoringFrame();
			__UI_AquariumFrame.logo.visible = false;
			WwSprite.FLASH_STAGE.addChild(__UI_AquariumFrame);
			var frame_mc:flash.display.MovieClip = __UI_AquariumFrame["frame"];
			__UI_AquariumFrame.mouseChildren = false;
			__UI_AquariumFrame.mouseEnabled = false;
			__UI_AquariumFrame.visible = false;
			//Starling.current.showStats = true;
			
			
			var xml_xtra:XML = xml.xtra[0];
			try 
			{
				if (xml_xtra != null)
				{
					__backgroundWrapper = new WwSprite();
					__backgroundWrapperOffsetX = 0;

					addChild(__backgroundWrapper);
										
					mRenderTexture = new RenderTexture(WwDeviceInfo.instance.canvasWidth, WwDeviceInfo.instance.canvasHeight);
					
					mCanvas = new Image(mRenderTexture);
					__backgroundWrapper.addChild(mCanvas);
					
					__backgroundSprite = new WwSprite();
					__backgroundSprite.addEventListener(TouchEvent.TOUCH, onTouch);
					__backgroundWrapper.addChild(__backgroundSprite);
					__backgroundSprite.onReadyCallback = onBackgroundSpriteReady;
				
					__AquariumMenuController.show(false);
					__backgroundWrapper.visible = false;
					
					__fishControllerBG = new WwAquariumFishController(this, __fishPlaneBG, 1.0);
					__fishControllerFG = new WwAquariumFishController(this, __fishPlaneFG, 1.0);
					
					__decorControllerBG = new WwAquariumDecorController(this, __decorPlaneBG, 1.0);
					__decorControllerBG.newObject(WwAquariumDecorController.TYPE_17, 0, 564);  // sand bg
					
					__decorControllerFG = new WwAquariumDecorController(this, __decorPlaneFG, 1.0);
					__decorControllerFG.newObject(WwAquariumDecorController.TYPE_18, 0, 606);  // sand fg
					
					page = xml_xtra.@clrPg;
				}
			}
			catch (err:Error)
			{
				__debug.msg("initWithXML: Aquarium: Error: " + err, "3");
			}
		}
		
		public function onBackgroundSpriteReady(url:String):void
		{
			this.stage.color = 0xFFFFFF;
			__AquariumMenuController.show();
			__backgroundWrapper.visible = true;
			__AquariumMenuController.showTools();
			__debug.msg("onBackgroundSpriteReady: " + url + ", __backgroundWrapper.x: " + __backgroundWrapper.x, "1");
			
			__UI_AquariumFrame.gotoAndPlay("a");
		}
		
		override public function enterframeEvent(elapsed_time:int, total_seconds:Number):void
		{
			__AquariumMenuController.enterFrameUpdateHandler(elapsed_time, total_seconds);
			__fishControllerFG.enterFrameUpdateHandler(elapsed_time, total_seconds);
			__fishControllerBG.enterFrameUpdateHandler(elapsed_time, total_seconds);
			__decorControllerFG.enterFrameUpdateHandler(elapsed_time, total_seconds);
			__decorControllerBG.enterFrameUpdateHandler(elapsed_time, total_seconds);
		}
		
		public override function acceleromterEvent(event:AccelerometerEvent):void
		{	
			__accelX = int(event.accelerationX * 1000)/1000;
			__accelY = int(event.accelerationY * 1000)/1000;
			__accelZ = int(event.accelerationZ * 1000)/1000;
			
			if (!__accelStarted)
			{
				__accelStarted = true;
				__accelXStart = __accelX;
				__accelYStart = __accelY;
				__accelZStart = __accelZ;
			}
		}
		
		private function movePage(delta:Point):void 
		{
			var cur_x:int = Math.floor(__backgroundWrapper.x + (delta.x * __backgroundWrapper.scaleX));
			var cur_y:int = Math.floor(__backgroundWrapper.y + (delta.y * __backgroundWrapper.scaleX));

			//MAGIC NUMBER
			var min_x:int = (960 + __backgroundWrapperOffsetX) - __backgroundWrapper.width;
			var min_y:int = 640 - __backgroundWrapper.height;
			
			cur_x = Math.max(cur_x, min_x);
			cur_y = Math.max(cur_y, min_y);
			cur_x = Math.min(cur_x, 0 + __backgroundWrapperOffsetX);
			cur_y = Math.min(cur_y, 0);
			
			__backgroundWrapper.x = cur_x;
			__backgroundWrapper.y = cur_y;
				
		}
        
        private function onTouch(event:TouchEvent):void
        {
            // touching the canvas will draw a brush texture. The 'drawBundled' method is not
            // strictly necessary, but it's faster when you are drawing with several fingers
            // simultaneously.
			
			var delta:Point;
			
			__touchEvent = event;
			var touches:Vector.<Touch> = __touchEvent.getTouches(__backgroundWrapper);
			
			if (!uiActive && !WwAlertsManager.instance.alertActive)
			{
				if (touches.length == 3)
	            {
					// one finger touching -> move
	                delta = touches[0].getMovement(__backgroundWrapper);
					//movePage(delta);
	            }            
	            else if (touches.length == 1)
	            {
					//mRenderTexture.drawBundled(drawWithTouches);
				}
				else if (false && touches.length == 2)
	            {
	                // two fingers touching -> rotate and scale
	                var touchA:Touch = touches[0];
	                var touchB:Touch = touches[1];
	                
	                var currentPosA:Point  = touchA.getLocation(__backgroundWrapper);
	                var previousPosA:Point = touchA.getPreviousLocation(__backgroundWrapper);
	                var currentPosB:Point  = touchB.getLocation(__backgroundWrapper);
	                var previousPosB:Point = touchB.getPreviousLocation(__backgroundWrapper);
	                var currentVector:Point  = currentPosA.subtract(currentPosB);
	                var previousVector:Point = previousPosA.subtract(previousPosB);
	                
	
	                // scale
	                var sizeDiff:Number = currentVector.length / previousVector.length;
	                __backgroundWrapper.scaleX *= sizeDiff;
	                __backgroundWrapper.scaleY *= sizeDiff;
					
					__backgroundWrapper.scaleX = Math.min(__backgroundWrapper.scaleX, 3);
					__backgroundWrapper.scaleX = Math.max(__backgroundWrapper.scaleX, 1);
					
					__backgroundWrapper.scaleY = Math.min(__backgroundWrapper.scaleY, 3);
					__backgroundWrapper.scaleY = Math.max(__backgroundWrapper.scaleY, 1);
										
					delta = touches[0].getMovement(__backgroundWrapper);
					movePage(delta);
	            }
			}
        }     
		
		public function set page(url:String):void
		{
			__AquariumMenuController.show(false);
			__backgroundWrapper.visible = false;
			__debug.msg("set: page: " + url);
			mRenderTexture.clear();
			__backgroundSprite.loadImage(url);
			__UI_AquariumFrame.gotoAndStop("a");
			__debug.msg("  __backgroundSprite.x: " + __backgroundSprite.x);
		}
		
		public function gotoMainMenu():void
		{
			__sceneManager.gotoScene("Main");
		}
				
		public function showBackgroundSpriteBitmap(bmd:BitmapData, offset:Point, show:Boolean = true):void
		{
			if (bmd)
			{
				__UI_AquariumBackgroundBitmap.bitmapData = bmd;
			}
			else
			{
				return;
			}
			__UI_AquariumBackgroundBitmap.visible = show;
			
			__UI_AquariumBackgroundBitmap.scaleX = 1.0/WwDeviceInfo.instance.assetScaleFactor;
			__UI_AquariumBackgroundBitmap.scaleY = 1.0/WwDeviceInfo.instance.assetScaleFactor;
			//AQUARIUM this offest is not necessary for full-screen content
			//MAGIC NUMBER
			//__UI_AquariumBackgroundBitmap.x = 32;
			//__UI_AquariumBackgroundBitmap.y = 64;
		}
		
		public function hideBackgroundSpriteBitmap(clear:Boolean=false):void
		{
			__UI_AquariumBackgroundBitmap.visible = false;
			if (clear)
			{
				__UI_AquariumBackgroundBitmap.bitmapData = null;
			}
		}
		
		public function onControlShare(event:Event):void
		{
			
			generateBitmapFromScene();
			
			WwGoViral.instance.postTitle = "Title";
			WwGoViral.instance.postCaption = "Caption";
			WwGoViral.instance.postMessage = "Message";
			WwGoViral.instance.postDescription = "Description";
			WwGoViral.instance.postURL = "URL";
			WwGoViral.instance.postImageURL = "ImageURL";
			//WwGoViral.instance.postName = "Name";
			WwGoViral.instance.postEmailSubject = "Subject";
			WwGoViral.instance.postEmailAddresses = "";
			WwGoViral.instance.postEmailBody = "Body";
			//WwGoViral.instance.twitterMessage = "Twitter Message";
			WwAlertsManager.instance.MM_Share();
			
			WwAlertsManager.instance.AV_Share(onShareCompleted);
		}
		
		public function onShareCompleted():void
		{
			
		}
		
		// FISH MENU
		
		public function onSelectFishType(_type:String):void
		{
			__UIMode = UI_MODE_FISH;
			__UIModeActiveType = _type;
		}
		
		// FISH TOOLS MENU
		
		public function onSelectFishToolsType(_type:String):void
		{
			__UIMode = UI_MODE_FISH_TOOLS;
			__UIModeActiveType = _type;
			
			var _obj:WwAquariumFish
			
			if (__activeFish)
			{
				if (_type == WwAquariumMenuFishTools.FISH_TOOLS_TYPE_6)
				{
					if (__fishControllerFG.owns(__activeFish))
					{
						_obj = __fishControllerFG.removeObject(__activeFish);
						__fishControllerBG.addObject(_obj);
					}
				}
				else if (_type == WwAquariumMenuFishTools.FISH_TOOLS_TYPE_5)
				{
					if (__fishControllerBG.owns(__activeFish))
					{
						_obj = __fishControllerBG.removeObject(__activeFish);
						__fishControllerFG.addObject(_obj);
					}
				}
				else
				{
					__fishControllerFG.onObjectTool(_type);
				}
			}
		}
		
		// DECOR MENU
		
		public function onSelectDecorType(_type:String):void
		{
			__UIMode = UI_MODE_DECOR;
			__UIModeActiveType = _type;
		}
		
		// DECOR TOOLS MENU
		
		public function onSelectDecorToolsType(_type:String):void
		{
			__UIMode = UI_MODE_DECOR_TOOLS;
			__UIModeActiveType = _type;
			
			var _obj:WwAquariumDecor
			
			if (__activeObject)
			{
				if (_type == WwAquariumMenuDecorTools.DECOR_TOOLS_TYPE_6)
				{
					if (__decorControllerFG.owns(__activeObject))
					{
						_obj = __decorControllerFG.removeObject(__activeObject);
						__decorControllerBG.addObject(_obj);
					}
				}
				else if (_type == WwAquariumMenuDecorTools.DECOR_TOOLS_TYPE_5)
				{
					if (__decorControllerBG.owns(__activeObject))
					{
						_obj = __decorControllerBG.removeObject(__activeObject);
						__decorControllerFG.addObject(_obj);
					}
				}
				else
				{
					__decorControllerFG.onObjectTool(_type);
				}
			}
		}
		
		public function set activeFish(_o:WwAquariumFish):void
		{
			__activeFish = _o;
		}
		
		public function set activeObject(_o:WwAquariumDecor):void
		{
			__activeObject = _o;
		}
		
		private function generateBitmapFromScene():void
		{		
			var stage:Stage = Starling.current.stage;
			var stage_width:Number = WwDeviceInfo.instance.stageWidth; //stage.stageWidth;
			var stage_height:Number = WwDeviceInfo.instance.stageHeight; //stage.stageHeight;
			var rs:RenderSupport = new RenderSupport();
			__debug.msg("Aquarium: generateBitmapFromScene: stageWidth: " + stage_width + ", stageHeight: " + stage_height + ", scaleFactor: " + WwDeviceInfo.instance.assetScaleFactor, "1");
			
			var bmd1_size:Point = new Point(stage_width, stage_height);
			var bmd1:BitmapData = new BitmapData(bmd1_size.x, bmd1_size.y, false, 0xAABBCC);
			__debug.msg("  bmd1_size.x: " + bmd1_size.x + ", bmd1_size.y: " + bmd1_size.y, "1");
			
			var rs_scale:Number = 1.0;
			var scaled_stage_width:Number = stage_width * rs_scale;
			var scaled_stage_height:Number = stage_height * rs_scale;
			rs.clear(stage.color, 1.0);
			rs.scaleMatrix(rs_scale, rs_scale);
			rs.setOrthographicProjection(0, 0, scaled_stage_width, scaled_stage_height);
			
			__debug.msg("  rs_scale: " + rs_scale + ", scaled_stage_width: " + scaled_stage_width + ", scaled_stage_height: " + scaled_stage_height, "1");
			
			stage.render(rs, 1.0);
			rs.finishQuadBatch();
			
			Starling.context.drawToBitmapData(bmd1);
			
			//AQUARIUM - biftma should be full-screen 1024x768
			//MAGIC NUMBER - bitmap is always 1024x768, for now
			var bmd2_size:Point = new Point(1024 * WwDeviceInfo.instance.assetScaleFactor, 768 * WwDeviceInfo.instance.assetScaleFactor);
			var bmd2:BitmapData = new BitmapData(bmd2_size.x, bmd2_size.y, false, 0xCC5577);
			//AQUARIUM this offset is not necessary for full-screen - 1024x768 - content
			var bmd2_offset:Point = new Point(0,0); //new Point((bmd2_size.x - bmd1_size.x)/2, (bmd2_size.y - bmd1_size.y)/2);
			var mat:Matrix = new Matrix();
			mat.scale(1.0, 1.0);
			mat.translate( bmd2_offset.x, bmd2_offset.y);
			
			__debug.msg("  bmd2_offset.x: " + bmd2_offset.x + ", bmd2_offset.y: " + bmd2_offset.y , "1");
			
			bmd2.draw(bmd1, mat);
			
			showBackgroundSpriteBitmap(bmd2, bmd2_offset);
			
			__UI_AquariumFrame.visible = false;
			__UI_AquariumFrame.logo.visible = true;
			__UI_AquariumMenu.visible = false;
			
			//MAGIC NUMBER
			WwGoViral.instance.photoBitmapData = new BitmapData(1024,768);
			WwGoViral.instance.photoBitmapData.draw(WwSprite.FLASH_STAGE);
			
			hideBackgroundSpriteBitmap(true);
			
			__UI_AquariumFrame.visible = false;
			__UI_AquariumFrame.logo.visible = false;
			__UI_AquariumMenu.visible = true;			
		}

		public function get uiActive():Boolean
		{
			return __uiActive;
		}

		public function set uiActive(value:Boolean):void
		{
			__uiActive = value;
		}
		
		public function get menuController():WwAquariumMenuController
		{
			return __AquariumMenuController;
		}
		
		public override function dispose():void
		{
			removeChildren();
			removeEventListeners();
			
			WwAquarium.appStage.removeEventListener(MouseEvent.MOUSE_UP, onGlobalMouseUp);
			
			__backgroundWrapper.removeChildren();
			__backgroundWrapper.removeEventListeners();
			__backgroundWrapper = null;
			
			__backgroundSprite.removeEventListeners();
			__backgroundSprite.removeChildren();
			__backgroundSprite = null;
			
			mRenderTexture.dispose();
			
			__fishControllerFG.dispose();
			__decorControllerFG.dispose();
			__fishControllerBG.dispose();
			__decorControllerBG.dispose();
			
			WwSprite.FLASH_STAGE.removeChild(__UI_AquariumMenu);
			WwSprite.FLASH_STAGE.removeChild(__UI_AquariumFrame);
			WwSprite.FLASH_STAGE.removeChild(__fishPlaneFG);
			WwSprite.FLASH_STAGE.removeChild(__decorPlaneFG);
			WwSprite.FLASH_STAGE.removeChild(__fishPlaneBG);
			WwSprite.FLASH_STAGE.removeChild(__decorPlaneBG);
			__UI_AquariumFrame = null;
			__UI_AquariumMenu = null;
			__fishPlaneFG = null;
			__decorPlaneFG = null;
			__fishPlaneBG = null;
			__decorPlaneBG = null;
			
			__AquariumMenuController.dispose();
			__AquariumMenuController = null;
			
			super.dispose();
		}


    }
}