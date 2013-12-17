package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import org.wwlib.utils.WwDebug;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuFish extends WwWrapperTouchList
	{

		private var __controller:WwAquariumMenuController;
		private var __types:Dictionary;
		
		public function WwAquariumMenuFish(controller:WwAquariumMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;
			
			__types = new Dictionary();
			//__types[1] = "Yellow Fish";
		}
		
		override public function handleItemPress(item:WwWrapperTouchListItem):void
		{
			super.handleItemPress(item);
		}

		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			__controller.onSelectFishType(item.data as String);
		}
	
		public override function dispose():void
		{
			super.dispose();
			__controller = null;
			__types = null;
		}
	}

}