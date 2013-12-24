package org.wwlib.flash
{
	import flash.desktop.IFilePromise;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import org.wwlib.utils.WwDebug;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumFish
	{
		private const STATE_IDLING:String 	= "idling";
		private const STATE_SLOW:String 	= "slow";
		private const STATE_FAST:String 	= "fast";
		private const STATE_EXCITED:String 	= "excited";
		private const STATE_BEGGING:String 	= "begging";
		private const STATE_EATING:String 	= "eating";
		private const STATE_HEAD_ON:String 	= "head_on";
		private const STATE_TIRED:String 	= "tired";
		private const STATE_SICK:String 	= "sick";
		private const STATE_DANCING:String 	= "dancing";
		
		private const GEAR_TYPE_0:String = "none";
		private const GEAR_TYPE_1:String = "santa_hat";
		private const GEAR_TYPE_2:String = "goggles";
		
		//MAGIC NUMBER
		public const TOP_LEFT_BOUND:Point = new Point(-256, -256);
		public const BOTTOM_RIGHT_BOUND:Point = new Point (1280, 1024);
		
		private var __frameRate:Number;
		private var __frameSeconds:Number;
		private var __secondsPerFrame:Number;
		
		private var __mc:MovieClip;
		private var __scale:Number;
		private var __flipX:Number; //used for horizontal flipping
		private var __fishPlane:MovieClip;
		private var __state:String;
		private var __velocityVector:Point;
		private var __velocityMagnitude:Point;
		private var __acceleration:Point;
		private var __buoyancy:Number;
		
		private var __friciton:Number;
		
		private var __gear:String;
		private var __thoughtBubble:String;
		
		private var __happy:Number;
		private var __healthy:Number;
		private var __hungry:Number;
		private var __excited:Number;
		private var __lonely:Number;
		private var __afraid:Number;
		private var __tired:Number;
		
		
		private var __glowing:Boolean;
		private var __selectedFilters:Array;
		private var __dropShadowFilters:Array;
		private var __glowingFilters:Array;
		
		private var __controller:WwAquariumFishController;
		
		public function WwAquariumFish(_controller, _mc:MovieClip, _fish_plane, _frame_rate:Number=12.0)
		{
			__controller = _controller;
			__mc = _mc;
			__flipX = 1.0;
			scale = __mc.scaleX;
			__fishPlane = _fish_plane;
			__fishPlane.addChild(__mc);
			
			state = STATE_FAST;
			__velocityVector = new Point(-1, 0);
			__velocityMagnitude = new Point(10,0);
			__friciton = .01;
			__frameRate = _frame_rate;
			__frameSeconds = 0;
			__secondsPerFrame = 1.0/__frameRate;
			
			__mc.anim_callback = anim_callback;
			__mc.labels_callback = labels_callback;
			__mc.loop_callback = loop_callback;
			
			__mc.blink_1.visible = false;
			__mc.blink_2.visible = false;
			__mc.blink_3.visible = false;
			
			__mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			__mc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			__selectedFilters = [ new DropShadowFilter(4,45,0,1,10,10, .4), new GlowFilter(0xFFFFFF,1,10,10)];
			__dropShadowFilters = [ new DropShadowFilter(4,45,0,1,10,10, .4)];
			__glowingFilters = [ new GlowFilter(0xFFFFFF,1,10,10)];
			
			__mc.filters = __dropShadowFilters;
		}
		
		public function onMouseDown(e:Event):void
		{
			e.stopImmediatePropagation();
			__mc.startDrag();
			__mc.filters = __selectedFilters;
			__controller.onObjectSelected(this);
		}
		
		public function onMouseUp(e:Event):void
		{
			e.stopImmediatePropagation();
			__mc.stopDrag();
			__mc.filters = __dropShadowFilters;
		}
		
		public function update(elapsed_seconds:Number, total_seconds:Number):void
		{
			updateVelocity();
			__mc.x += __velocityMagnitude.x * __velocityVector.x * elapsed_seconds;
			__mc.y += __velocityMagnitude.y * __velocityVector.y * elapsed_seconds;
			__frameSeconds += elapsed_seconds;
			
			if (__frameSeconds >= __secondsPerFrame)
			{
				__mc.nextFrame();
				__frameSeconds -= __secondsPerFrame;
			}
		}
		
		private function updateVelocity():void
		{
			__velocityMagnitude.x -= (__velocityMagnitude.x * __friciton);
			__velocityMagnitude.y -= (__velocityMagnitude.y * __friciton);
			
			if (__mc.x < TOP_LEFT_BOUND.x)
			{
				__mc.x = TOP_LEFT_BOUND.x;
				flipX();
			}
			if (__mc.x > BOTTOM_RIGHT_BOUND.x)
			{
				__mc.x = BOTTOM_RIGHT_BOUND.x;
				flipX();
			}
		}
		
		public function flipX():void
		{
			__velocityVector.x *= -1.0;
			__flipX *= -1.0;
			__mc.scaleX = __scale * __flipX;
		}
		
		public function anim_callback(_mc:MovieClip, _state:String):void
		{
			switch(_state)
			{
				case STATE_IDLING:
				{
					__velocityMagnitude.x = 10;
					break;
				}
				case STATE_SLOW:
				{
					__velocityMagnitude.x = 20;
					break;
				}
				case STATE_FAST:
				{
					__velocityMagnitude.x = 40;
					break;
				}
				default:
				{
					break;
				}
			}
			
		}
		
		public function loop_callback(_mc:MovieClip, _state:String):void
		{
			__mc.gotoAndStop(_state);
			//WwAudioManager.playSound("bubbles");
		}

		public function labels_callback(_list:Array):void
		{
			WwDebug.instance.msg("Fish: labels_callback: " + _list, "1");
		}
		
		public function get mc():MovieClip
		{
			return __mc;
		}
		
		public function set state(_state:String):void
		{
			try
			{
				__mc.gotoAndStop(_state);
				__state = _state;
			}
			catch (e:Error)
			{
				WwDebug.instance.msg("Fish: set state: " + e, "1");
			}
		}
		
		public function get scale():Number
		{
			return __scale;
		}
		
		public function set scale(s:Number):void
		{
			__scale = s;
			__mc.scaleX = __scale * __flipX;
			__mc.scaleY = __scale;
		}
		
		public function get controller():WwAquariumFishController
		{
			return __controller;
		}
		
		public function dispose():void
		{
			//__fishPlane.removeChild(__mc);
			__fishPlane = null;
			__mc = null;
			__velocityVector = null;
			__velocityMagnitude = null;
			__acceleration = null;
		}
	}
}