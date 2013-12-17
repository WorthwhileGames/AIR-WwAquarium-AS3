package org.wwlib.flash 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuBackgrounds extends WwWrapperTouchList
	{
		private var __controller:WwAquariumMenuController;
		
		public function WwAquariumMenuBackgrounds(controller:WwAquariumMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			switch (item.index) 
			{
				case 1:
					__controller.aquariumScene.page = "assets/backgrounds/qc_aquarium_bg1.png"
					break;
				case 2:
					__controller.aquariumScene.page = "assets/backgrounds/qc_aquarium_bg2.png"
					break;
				case 3:
					__controller.aquariumScene.page = "assets/backgrounds/qc_aquarium_bg3.png"
					break;
				case 4:
					__controller.aquariumScene.page = "assets/backgrounds/qc_aquarium_bg4.png"
					break;
				default:
			}
		}

		public override function dispose():void
		{
			
		}
	}

}