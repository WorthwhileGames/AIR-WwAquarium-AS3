package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuDecorTools extends WwWrapperTouchList
	{
		public static const DECOR_TOOLS_TYPE_1:String = "decor_tools_type_1";
		public static const DECOR_TOOLS_TYPE_2:String = "decor_tools_type_2";
		public static const DECOR_TOOLS_TYPE_3:String = "decor_tools_type_3";
		public static const DECOR_TOOLS_TYPE_4:String = "decor_tools_type_4";
		public static const DECOR_TOOLS_TYPE_5:String = "decor_tools_type_5";
		public static const DECOR_TOOLS_TYPE_6:String = "decor_tools_type_6";
		public static const DECOR_TOOLS_TYPE_7:String = "decor_tools_type_7";

		private var __controller:WwAquariumMenuController;
		private var __types:Dictionary;
		
		public function WwAquariumMenuDecorTools(controller:WwAquariumMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;

			
			__types = new Dictionary();
			__types[1]  = "Scale up";
			__types[2]  = "Scale Down";
			__types[3]  = "Left";
			__types[4]  = "Right";
			__types[5]  = "Layer Up";
			__types[6]  = "Layer Down";
			__types[7]  = "Delete";
		}
		
		override public function handleItemPress(item:WwWrapperTouchListItem):void
		{
			super.handleItemPress(item);
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			__controller.onSelectDecorToolsType(item.data as String);
		}
		
		public override function dispose():void
		{
			super.dispose();
			__controller = null;
			__types = null;
		}
	}

}