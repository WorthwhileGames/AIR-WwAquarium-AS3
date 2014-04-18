package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.sensors.Accelerometer;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import org.wwlib.WwColoring.anim.StageOuterBlocker;
	import org.wwlib.flash.WwAlertsManager;
	import org.wwlib.flash.WwAppBG;
	import org.wwlib.flash.WwAudioManager;
	import org.wwlib.starling.WwSprite;
	import org.wwlib.utils.WwDebug;
	import org.wwlib.utils.WwDeviceInfo;
	import org.wwlib.utils.WwGoViral;
	import org.wwlib.utils.WwParseManager;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	[SWF(backgroundColor="#FFFFFF", width="1024", height="768", frameRate="59")]
	public class WwAquarium extends Sprite
	{
		//private var mStarling:Starling;
		
		private var __debug:WwDebug;
		private var __deviceInfo:WwDeviceInfo;
		private var __appFlashStage:MovieClip;
		private var __appFlashAlertsStage:MovieClip;
		private var __appDebugStage:MovieClip;
		
		private var __accelerometer:Accelerometer;
		private var __accelZ:Number;
		private var __activateDebug:Boolean = false;
		
		private var __prevTime:int;
		private var __frameTime:int;
		private var __totalSeconds:Number;
		private var __frameRate:Number;
		
		public static var appStage:Stage;
		public static var stageOuterBlocker:StageOuterBlocker;
		
		/** Embedded the default app image for immediate display. */
		[Embed(source="/Default-Landscape.png")]
		private var __defaultAppImageClass:Class;
		private var __defaultAppBitmap:Bitmap;
		private var __appStateManager:QcAppStateManager;
		//private var __parseManager:WwParseManager;
		
		public function WwAquarium()
		{
			super();
			
			appStage = stage;
			appStage.color = 0xFFFFFF;
			appStage.scaleMode = StageScaleMode.NO_SCALE;
			appStage.align = StageAlign.TOP_LEFT;
			
			__appFlashStage = new MovieClip();
			__appFlashAlertsStage = new MovieClip();
			__appDebugStage = new MovieClip();
			
			stage.addChild(__appFlashStage);
			stage.addChild(__appFlashAlertsStage);
			stage.addChild(__appDebugStage);
			
			__defaultAppBitmap = new __defaultAppImageClass() as Bitmap;
			WwAppBG.init(__appFlashStage, __defaultAppBitmap);
			WwAppBG.show();
			
			stageOuterBlocker = new StageOuterBlocker();
			stageOuterBlocker.mouseChildren = false;
			stageOuterBlocker.mouseEnabled = false;
			__appDebugStage.addChild(stageOuterBlocker);
			
			__deviceInfo = WwDeviceInfo.init();
			WwDebug.init(__appDebugStage);
			__debug = WwDebug.instance;
			
			
			__debug.msg("os: " + __deviceInfo.os,"3");
			__debug.msg("devStr: " + __deviceInfo.devString,"3");
			__debug.msg("device: " + __deviceInfo.device,"3");
			__debug.msg("bgX: " + __deviceInfo.stageX,"3");
			__debug.msg("bgY: " + __deviceInfo.stageY,"3");
			__debug.msg("bgWidth: " + __deviceInfo.stageWidth,"3");
			__debug.msg("bgHeight: " + __deviceInfo.stageHeight,"3");
			__debug.msg("canvasX: " + __deviceInfo.canvasX,"3");
			__debug.msg("canvasY: " + __deviceInfo.canvasY,"3");
			__debug.msg("resolutionX: " + __deviceInfo.resolutionX,"3");
			__debug.msg("resolutionY: " + __deviceInfo.resolutionY,"3");
			__debug.msg("isDebugger: " + __deviceInfo.isDebugger,"3");
			__debug.msg("screenDPI: " + __deviceInfo.screenDPI,"3");			
			__debug.show = true;
			
			WwSprite.FLASH_STAGE = __appFlashStage;
			WwSprite.FLASH_STAGE.scaleX =  __deviceInfo.assetScaleFactor;
			WwSprite.FLASH_STAGE.scaleY =  __deviceInfo.assetScaleFactor;
			WwSprite.FLASH_STAGE.x =  __deviceInfo.stageX;
			WwSprite.FLASH_STAGE.y =  __deviceInfo.stageY;
			
			__appFlashAlertsStage.scaleX =  __deviceInfo.assetScaleFactor;
			__appFlashAlertsStage.scaleY =  __deviceInfo.assetScaleFactor;
			__appFlashAlertsStage.x =  __deviceInfo.stageX;
			__appFlashAlertsStage.y =  __deviceInfo.stageY;
			
			__appDebugStage.scaleX =  __deviceInfo.assetScaleFactor;
			__appDebugStage.scaleY =  __deviceInfo.assetScaleFactor;
			__appDebugStage.x =  __deviceInfo.stageX;
			__appDebugStage.y =  __deviceInfo.stageY;
			
			WwSprite.__baseScaleFactor = __deviceInfo.assetScaleFactor;
			__debug.msg("assetScaleFactor: " + __deviceInfo.assetScaleFactor,"3");
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			__accelZ = 0;
			__accelerometer = new Accelerometer();
			__accelerometer.addEventListener(AccelerometerEvent.UPDATE, accelerometerUpdateHandler);
			
			// GoViral Manager
			WwGoViral.init();
			
			// Alerts Manager
			WwAlertsManager.init(__appFlashAlertsStage);
			
			// Audio Manager
			WwAudioManager.init();

			// Handler for inter-app events
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			
			// App State Manager
			__appStateManager = QcAppStateManager.init(this, __appFlashStage);
			
		}
		
		private function onInvoke(event:InvokeEvent):void
		{
			__debug.msg("onInvoke: " + event.arguments, "1");
		}
		
		/*
		private function onContextCreated(event:Event):void
		{
			// set framerate to 30 in software mode
			
			if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
				Starling.current.nativeStage.frameRate = 30;
		}
		*/
		
		private function onEnterFrame(event:Event):void
		{
			if (__appStateManager)
			{
				var total_milliseconds:int = getTimer();
				__frameTime = total_milliseconds - __prevTime;
				__prevTime = total_milliseconds;
				__frameRate = 1000.0 / __frameTime;
				__totalSeconds = total_milliseconds / 1000.0;
				__appStateManager.enterFrameUpdateHandler(__frameTime, __totalSeconds);
				WwDebug.fps = __frameRate;
			}
		}
		
		public function accelerometerUpdateHandler(event:AccelerometerEvent):void
		{
			if (__appStateManager)
			{
				__appStateManager.accelerometerUpdateHandler(event);
				
				// Hide debug panel expect when device is inverted
				/*
				__accelZ = int(event.accelerationZ * 1000)/1000;
				__activateDebug = (__accelZ < -0.8);
				__debug.show =__activateDebug;
				*/
			}
		}

	}
}