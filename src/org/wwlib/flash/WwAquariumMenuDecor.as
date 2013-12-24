package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuDecor extends WwWrapperTouchList
	{

		private var __controller:WwAquariumMenuController;
		private var __types:Dictionary;
		
		public function WwAquariumMenuDecor(controller:WwAquariumMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;

			
			__types = new Dictionary();
			__types[1]  = "Tall Plant";
			__types[2]  = "Algae Rock";
			__types[3]  = "Anchor";
			__types[4]  = "Castle";
			__types[5]  = "Grass Clump";
			__types[6]  = "Small Eel Gras";
			__types[7]  = "Large Eel Grass";
			__types[8]  = "Plant 1";
			__types[9] = "Plant 2";
			__types[10] = "Single Post";
			__types[11] = "Posts";
			__types[12] = "Rock Bridge 1";
			__types[13] = "Rock Bridge 2";
			__types[14] = "Dive Helmet";
			__types[15] = "Founders Trophy";
			__types[16] = "Christmas Tree";
			__types[17] = "Peastone";
			__types[18] = "Sand BG";
			__types[19] = "Sand FG";
			
		}
		
		override public function handleItemPress(item:WwWrapperTouchListItem):void
		{
			super.handleItemPress(item);
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			__controller.onSelectDecorType(item.data as String);
		}
		
		public override function dispose():void
		{
			super.dispose();
			__controller = null;
			__types = null;
		}
	}

}