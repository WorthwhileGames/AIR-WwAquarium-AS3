package org.wwlib.flash
{	
	import flash.display.MovieClip;
	import flash.events.AccelerometerEvent;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.getDefinitionByName;
	
	import org.wwlib.WwAquarium.decor.decor_type_1;
	import org.wwlib.WwAquarium.decor.decor_type_10;
	import org.wwlib.WwAquarium.decor.decor_type_11;
	import org.wwlib.WwAquarium.decor.decor_type_12;
	import org.wwlib.WwAquarium.decor.decor_type_13;
	import org.wwlib.WwAquarium.decor.decor_type_14;
	import org.wwlib.WwAquarium.decor.decor_type_15;
	import org.wwlib.WwAquarium.decor.decor_type_16;
	import org.wwlib.WwAquarium.decor.decor_type_17;
	import org.wwlib.WwAquarium.decor.decor_type_18;
	import org.wwlib.WwAquarium.decor.decor_type_2;
	import org.wwlib.WwAquarium.decor.decor_type_3;
	import org.wwlib.WwAquarium.decor.decor_type_4;
	import org.wwlib.WwAquarium.decor.decor_type_5;
	import org.wwlib.WwAquarium.decor.decor_type_6;
	import org.wwlib.WwAquarium.decor.decor_type_7;
	import org.wwlib.WwAquarium.decor.decor_type_8;
	import org.wwlib.WwAquarium.decor.decor_type_9;
	import org.wwlib.starling.WwAquariumScene;
	import org.wwlib.utils.WwDebug;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumDecorController
	{
		public static const TYPE_1:String = "decor_type_1";	
		public static const TYPE_2:String = "decor_type_2";	
		public static const TYPE_3:String = "decor_type_3";
		public static const TYPE_4:String = "decor_type_4";	
		public static const TYPE_5:String = "decor_type_5";	
		public static const TYPE_6:String = "decor_type_6";	
		public static const TYPE_7:String = "decor_type_7";	
		public static const TYPE_8:String = "decor_type_8";	
		public static const TYPE_9:String = "decor_type_9";	
		public static const TYPE_10:String = "decor_type_10";	
		public static const TYPE_11:String = "decor_type_11";	
		public static const TYPE_12:String = "decor_type_12";	
		public static const TYPE_13:String = "decor_type_13";	
		public static const TYPE_14:String = "decor_type_14";	
		public static const TYPE_15:String = "decor_type_15";
		public static const TYPE_16:String = "decor_type_16";
		public static const TYPE_17:String = "decor_type_17";
		public static const TYPE_18:String = "decor_type_18";
		
		//DEPENDENCIES make sure copiler includes classes that will be instantiated dynamically
		private var __type_1_dependency:org.wwlib.WwAquarium.decor.decor_type_1;
		private var __type_2_dependency:org.wwlib.WwAquarium.decor.decor_type_2;
		private var __type_3_dependency:org.wwlib.WwAquarium.decor.decor_type_3;
		private var __type_4_dependency:org.wwlib.WwAquarium.decor.decor_type_4;
		private var __type_5_dependency:org.wwlib.WwAquarium.decor.decor_type_5;
		private var __type_6_dependency:org.wwlib.WwAquarium.decor.decor_type_6;
		private var __type_7_dependency:org.wwlib.WwAquarium.decor.decor_type_7;
		private var __type_8_dependency:org.wwlib.WwAquarium.decor.decor_type_8;
		private var __type_9_dependency:org.wwlib.WwAquarium.decor.decor_type_9;
		private var __type_10_dependency:org.wwlib.WwAquarium.decor.decor_type_10;
		private var __type_11_dependency:org.wwlib.WwAquarium.decor.decor_type_11;
		private var __type_12_dependency:org.wwlib.WwAquarium.decor.decor_type_12;
		private var __type_13_dependency:org.wwlib.WwAquarium.decor.decor_type_13;
		private var __type_14_dependency:org.wwlib.WwAquarium.decor.decor_type_14;
		private var __type_15_dependency:org.wwlib.WwAquarium.decor.decor_type_15;
		private var __type_16_dependency:org.wwlib.WwAquarium.decor.decor_type_16;
		private var __type_17_dependency:org.wwlib.WwAquarium.decor.decor_type_17;
		private var __type_18_dependency:org.wwlib.WwAquarium.decor.decor_type_18;
		
		private var __debug:WwDebug;
		
		private var __objectPlane:MovieClip;
		private var __objectPlaneScale:Number;
		private var __objectList:Vector.<WwAquariumDecor>;
		
		private var __aquariumScene:WwAquariumScene;
		private var __activeObject:WwAquariumDecor;

		public function WwAquariumDecorController(_aquarium_scene:WwAquariumScene, _object_plane:MovieClip, _object_plane_scale:Number)
		{	
			__aquariumScene = _aquarium_scene;
			__objectPlane = _object_plane;
			__objectPlaneScale = _object_plane_scale;
			__objectList = new Vector.<WwAquariumDecor>;
			__activeObject = null;

			__debug = WwDebug.instance;
			
		}
		
		public static function init():void
		{
		}
		
		public function enterFrameUpdateHandler(frame_time:int, total_seconds:Number):void
		{
			var temp_object:WwAquariumDecor;
			var elapsed_seconds:Number = frame_time/1000.0;
			for each (temp_object in __objectList)
			{
				temp_object.update(elapsed_seconds, total_seconds);
			}
		}
		
		public function acceleromterEvent(event:AccelerometerEvent):void
		{
		}
		
		public function newObject(_type:String, _x:Number, _y:Number):void
		{
			var _object_mc:MovieClip;
			
			try
			{
				var objectClassName:String = "org.wwlib.WwAquarium.decor." + _type;
				WwDebug.instance.msg("DecorController: addObject: objectClassName: " + objectClassName, "1");
				var objectClass:Class = getDefinitionByName(objectClassName) as Class;
				
				_object_mc = new objectClass() as MovieClip;
				
				if (_object_mc)
				{
					_object_mc.x = _x;
					_object_mc.y = _y;
					var _object:WwAquariumDecor = new WwAquariumDecor(this, _object_mc, __objectPlane);
					__objectList.push(_object);
				}
			} 
			catch(e:Error) 
			{
				WwDebug.instance.msg("  DecorController: addObject: " + e, "1");
			}
			
		}
		
		public function onObjectSelected(_object:WwAquariumDecor):void
		{
			WwDebug.instance.msg("DecorController: onObjectSelected: " + _object, "1");
			__activeObject = _object;
			__aquariumScene.activeObject = _object;
			__aquariumScene.menuController.showDecorTools();
		}
		
		public function addObject(_object:WwAquariumDecor):void
		{
			__objectList.push(_object);
			__objectPlane.addChild(_object.mc);
			
		}
		
		public function removeObject(_object:WwAquariumDecor):WwAquariumDecor
		{
			var temp_object:WwAquariumDecor;
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
				case WwAquariumMenuDecorTools.DECOR_TOOLS_TYPE_1:
				{
					__activeObject.scale *= 1.1;
					break;
				}
				case WwAquariumMenuDecorTools.DECOR_TOOLS_TYPE_2:
				{
					__activeObject.scale *= 0.9;
					break;
				}
					
				default:
				{
					break;
				}
			}
			
		}
		
		public function owns(_object:WwAquariumDecor):Boolean
		{
			var temp_object:WwAquariumDecor;
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
			var temp_object:WwAquariumDecor;
			for each (temp_object in __objectList)
			{
				temp_object.dispose();
			}
			__activeObject = null;
		}
	}
}