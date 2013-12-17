package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuFishTools extends WwWrapperTouchList
	{
		public static const FISH_TOOLS_TYPE_1:String = "fish_tools_type_1";
		public static const FISH_TOOLS_TYPE_2:String = "fish_tools_type_2";
		public static const FISH_TOOLS_TYPE_3:String = "fish_tools_type_3";
		public static const FISH_TOOLS_TYPE_4:String = "fish_tools_type_4";
		public static const FISH_TOOLS_TYPE_5:String = "fish_tools_type_5";
		public static const FISH_TOOLS_TYPE_6:String = "fish_tools_type_6";
		public static const FISH_TOOLS_TYPE_7:String = "fish_tools_type_7";
		public static const FISH_TOOLS_TYPE_8:String = "fish_tools_type_8";
		public static const FISH_TOOLS_TYPE_9:String = "fish_tools_type_9";
		public static const FISH_TOOLS_TYPE_10:String = "fish_tools_type_10";
		public static const FISH_TOOLS_TYPE_11:String = "fish_tools_type_11";
		
		private var __controller:WwAquariumMenuController;
		private var __types:Dictionary;
		
		public function WwAquariumMenuFishTools(controller:WwAquariumMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;

			
			__types = new Dictionary();
			__types[8] = "Santa Hat";
			__types[9] = "Goggles";
			__types[10] = "Food";
			__types[11] = "Glow Food";
			
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			__controller.onSelectFishToolsType(item.data as String);
		}
		
		public override function dispose():void
		{
			super.dispose();
			__controller = null;
			__types = null;
		}
	}

}