package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuTools extends WwWrapperTouchList
	{

		private var __controller:WwAquariumMenuController;
		private var __types:Dictionary;
		
		public function WwAquariumMenuTools(controller:WwAquariumMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;

			
			__types = new Dictionary();
			__types[1] = "Share";
			__types[2] = "Backgrounds";
			__types[3] = "Fish";
			__types[4] = "Decor";
			
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			switch(item.index)
			{
				case 1:
				{
					__controller.onControlShare(null);
					break;
				}
				case 2:
				{
					__controller.showBackgrounds();
					break;
				}
				case 3:
				{
					__controller.showFish();
					break;
				}
				case 4:
				{
					__controller.showDecor();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public override function dispose():void
		{

		}
	}

}