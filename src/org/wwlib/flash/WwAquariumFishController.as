package org.wwlib.flash
{	
	import flash.display.MovieClip;
	import flash.events.AccelerometerEvent;
	
	import org.wwlib.WwAquarium.fish.fish_type_1;
	import org.wwlib.starling.WwAquariumScene;
	import org.wwlib.utils.WwDebug;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumFishController
	{
		public static const TYPE_1:String = "fish_type_1";	
		public static const TYPE_2:String = "fish_type_2";	
		public static const TYPE_3:String = "fish_type_3";	
		
		private var __debug:WwDebug;
		
		private var __objectPlane:MovieClip;
		private var __objectPlaneScale:Number;
		private var __objectList:Vector.<WwAquariumFish>;
		
		private var __aquariumScene:WwAquariumScene;
		private var __activeObject:WwAquariumFish;

		
		public function WwAquariumFishController(_aquarium_scene:WwAquariumScene, _object_plane:MovieClip, _object_plane_scale:Number)
		{	
			__aquariumScene = _aquarium_scene;
			__objectPlane = _object_plane;
			__objectPlaneScale = _object_plane_scale;
			__objectList = new Vector.<WwAquariumFish>;
			
			__debug = WwDebug.instance;
			
		}
		
		public static function init():void
		{
		}
		
		public function enterFrameUpdateHandler(frame_time:int, total_seconds:Number):void
		{
			var temp_object:WwAquariumFish;
			var elapsed_seconds:Number = frame_time/1000.0;
			for each (temp_object in __objectList)
			{
				temp_object.update(elapsed_seconds, total_seconds);
			}
		}
		
		public function acceleromterEvent(event:AccelerometerEvent):void
		{
		}
		
		public function newObject(_type, _x, _y):void
		{
			var _object_mc:MovieClip;
			switch(_type)
			{
				case TYPE_1:
				{
					_object_mc = new org.wwlib.WwAquarium.fish.fish_type_1() as MovieClip;
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			if (_object_mc)
			{
				_object_mc.x = _x;
				_object_mc.y = _y;
				var _object:WwAquariumFish = new WwAquariumFish(this, _object_mc, __objectPlane);
				__objectList.push(_object);
			}
		}
		
		public function onObjectSelected(_object:WwAquariumFish):void
		{
			WwDebug.instance.msg("DecorController: onObjectSelected: " + _object, "1");
			__activeObject = _object;
			__aquariumScene.activeFish = _object;
			__aquariumScene.menuController.showFishTools();
		}
		
		public function addObject(_object:WwAquariumFish):void
		{
			__objectList.push(_object);
			__objectPlane.addChild(_object.mc);
			
		}
		
		public function removeObject(_object:WwAquariumFish):WwAquariumFish
		{
			var temp_object:WwAquariumFish;
			var index:int = 0;
			
			for each (temp_object in __objectList)
			{
				var index_plus_one:int = (index + 1);
				WwDebug.instance.msg("removeObject: checking: " + index + ": " + temp_object.mc, "1");
				if (temp_object == _object)
				{
					
					WwDebug.instance.msg("removeObject: found: splicing: " + index + ":" + index_plus_one, "1");
					__objectList.splice(index, 1);
					__objectPlane.removeChild(temp_object.mc);
					break;
				}
				index++;
			}
			
			return temp_object;
		}
		
		public function onObjectTool(_type:String):void
		{
			switch(_type)
			{
				case WwAquariumMenuFishTools.FISH_TOOLS_TYPE_1:
				{
					__activeObject.scale *= 1.1;
					break;
				}
				case WwAquariumMenuFishTools.FISH_TOOLS_TYPE_2:
				{
					__activeObject.scale *= 0.9;
					break;
				}
				case WwAquariumMenuFishTools.FISH_TOOLS_TYPE_8:
				{
					__activeObject.mc.gear.gotoAndPlay("santa_hat");
					break;
				}
				case WwAquariumMenuFishTools.FISH_TOOLS_TYPE_9:
				{
					__activeObject.mc.gear.gotoAndPlay("goggles");
					break;
				}
				case WwAquariumMenuFishTools.FISH_TOOLS_TYPE_10:
				{
					__activeObject.mc.gear.gotoAndPlay("none");
					break;
				}
				default:
				{
					break;
				}
			}
			
		}
		
		public function owns(_object:WwAquariumFish):Boolean
		{
			var temp_object:WwAquariumFish;
			for each (temp_object in __objectList)
			{
				if (_object == temp_object)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function dispose():void
		{
			var temp_object:WwAquariumFish;
			for each (temp_object in __objectList)
			{
				temp_object.dispose();
			}
		}
	}
}