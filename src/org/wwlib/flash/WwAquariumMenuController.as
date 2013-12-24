package org.wwlib.flash 
{
	
	import org.wwlib.WwAquarium.ui.UI_AquariumMenu;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.wwlib.starling.WwAquariumScene;
	import org.wwlib.utils.WwDebug;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAquariumMenuController 
	{
		private var __debug:WwDebug;
		private var __aquariumScene:WwAquariumScene;
		
		private var __menu_mc:UI_AquariumMenu;
		private var __bg_mc:MovieClip;
		
		private var __back_mc:MovieClip;
		private var __home_mc:MovieClip;
		private var __backgrounds_mc:MovieClip;
		private var __tools_mc:MovieClip;
		private var __fish_mc:MovieClip;
		private var __decor_mc:MovieClip;
		private var __decor_tools_mc:MovieClip;
		private var __gear_mc:MovieClip;
		
		
		private var __btn_home:WwWrapperButtonMC;
		private var __btn_back:WwWrapperButtonMC;
		private var __menu:WwAquariumMenu;
		
		private var __toolsTouchList:WwAquariumMenuTools;
		private var __fishTouchList:WwAquariumMenuFish;
		private var __backgroundsTouchList:WwAquariumMenuBackgrounds;
		private var __decorTouchList:WwAquariumMenuDecor;
		private var __decorToolsTouchList:WwAquariumMenuDecorTools;
		private var __gearTouchList:WwAquariumMenuFishTools;
		private var __activeTouchlist:WwWrapperTouchList
		
		
		public function WwAquariumMenuController(aquarium_scene:WwAquariumScene, menu:UI_AquariumMenu)
		{
			__debug = WwDebug.instance;
			__aquariumScene = aquarium_scene;
			__menu_mc = menu;
			
			if (__menu_mc)
			{
				__bg_mc				= __menu_mc["bg"];
				
				__back_mc 			= __menu_mc["btn_back"];
				__home_mc			= __menu_mc["btn_home"];
				__backgrounds_mc	= __menu_mc["backgrounds"];
				__tools_mc			= __menu_mc["tools"];
				__fish_mc			= __menu_mc["fish"];
				__decor_mc			= __menu_mc["decor"];
				__decor_tools_mc	= __menu_mc["decor_tools"];
				__gear_mc			= __menu_mc["gear"];
				
				
				__btn_home = new WwWrapperButtonMC(__home_mc, backHomeHandler);
				__btn_back = new WwWrapperButtonMC(__back_mc, backHomeHandler);
				
				__back_mc.visible = false;
				__tools_mc.visible = false;
				__fish_mc.visible = false;
				__backgrounds_mc.visible = false;
				
				__menu = new WwAquariumMenu(this, __menu_mc, "menu");
				//MAGIC NUMBER
				__menu.dragRect = new Rectangle(864, 64, 130, 0);
				
				__toolsTouchList = new WwAquariumMenuTools(this, __tools_mc,"tool_", 4);
				__fishTouchList = new WwAquariumMenuFish(this, __fish_mc,"fish_type_", 2);
				__backgroundsTouchList = new WwAquariumMenuBackgrounds(this, __backgrounds_mc,"background_", 4);
				__decorTouchList = new WwAquariumMenuDecor(this, __decor_mc,"decor_type_", 16);
				__decorToolsTouchList = new WwAquariumMenuDecorTools(this, __decor_tools_mc,"decor_tools_type_", 7);
				__gearTouchList = new WwAquariumMenuFishTools(this, __gear_mc,"fish_tools_type_", 11);
				
				showTools();
			}
		}
		
		public function onGlobalMouseUp(e:Event):void
		{
			if (__menu_mc)
			{
				__menu.stopDrag(e);
				__activeTouchlist.onMouseUp(e);
			}
		}
		
		public function enterFrameUpdateHandler(elapsed_time:int, total_seconds:Number):void
		{
			if (__menu_mc)
			{
				__activeTouchlist.enterFrameUpdateHandler(elapsed_time, total_seconds);
				//__colorsTouchList.enterFrameUpdateHandler(elapsed_time, total_seconds);
				//__pagesTouchList.enterFrameUpdateHandler(elapsed_time, total_seconds);
			}
		}
		
		private function backHomeHandler(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			
			//__debug.msg("backHomeHandler: " + mc.name, "2");
			
			if (e.type == MouseEvent.MOUSE_UP)
			{
				switch (mc.name) 
				{
					case "btn_home":
						__aquariumScene.gotoMainMenu();
						//onControlShare(null);
						break;
					case "btn_back":
						showTools();
						break;
					default:
				}
			}
		}
		
		public function show(flag:Boolean=true):void
		{
			if (__menu_mc)
			{
				__menu_mc.visible = flag;
			}
		}

		public function showTools():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __toolsTouchList;
				__backgrounds_mc.visible = false;
				__tools_mc.visible = true;
				__fish_mc.visible = false;
				__decor_mc.visible = false;
				__decor_tools_mc.visible = false;
				__gear_mc.visible = false;
				__back_mc.visible = false;
				__home_mc.visible = true;
			}
		}
		
		public function showBackgrounds():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __backgroundsTouchList;
				__backgrounds_mc.visible = true;
				__tools_mc.visible = false;
				__fish_mc.visible = false;
				__decor_mc.visible = false;
				__decor_tools_mc.visible = false;
				__gear_mc.visible = false;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function showFish():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __fishTouchList;
				__backgrounds_mc.visible = false;
				__tools_mc.visible = false;
				__fish_mc.visible = true;
				__decor_mc.visible = false;
				__decor_tools_mc.visible = false;
				__gear_mc.visible = false;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function showDecor():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __decorTouchList;
				__backgrounds_mc.visible = false;
				__tools_mc.visible = false;
				__fish_mc.visible = false;
				__decor_mc.visible = true;
				__decor_tools_mc.visible = false;
				__gear_mc.visible = false;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function showDecorTools():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __decorToolsTouchList;
				__backgrounds_mc.visible = false;
				__tools_mc.visible = false;
				__fish_mc.visible = false;
				__decor_mc.visible = false;
				__decor_tools_mc.visible = true;
				__gear_mc.visible = false;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function showFishTools():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __gearTouchList;
				__backgrounds_mc.visible = false;
				__tools_mc.visible = false;
				__fish_mc.visible = false;
				__decor_mc.visible = false;
				__decor_tools_mc.visible = false;
				__gear_mc.visible = true;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function onControlShare(event:Event):void
		{
			__aquariumScene.onControlShare(null);
		}
		
		public function onSelectFishType(_type:String):void
		{
			__aquariumScene.onSelectFishType(_type);
			showFishTools();
		}
		
		public function onSelectDecorType(_type:String):void
		{
			__aquariumScene.onSelectDecorType(_type);
			showDecorTools();
		}
		
		public function onSelectDecorToolsType(_type:String):void
		{
			__aquariumScene.onSelectDecorToolsType(_type);
			if (_type == WwAquariumMenuDecorTools.DECOR_TOOLS_TYPE_7) //delete fish
			{
				__aquariumScene..activeObject = null;
				showDecor();
			}
		}
		
		public function onSelectFishToolsType(_type:String):void
		{
			__aquariumScene.onSelectFishToolsType(_type);
			if (_type == WwAquariumMenuFishTools.FISH_TOOLS_TYPE_7) //delete fish
			{
				__aquariumScene.activeFish = null;
				showFish();
			}
		}
		
		public function get aquariumScene():WwAquariumScene
		{
			return __aquariumScene;
		}
		
		public function dispose():void
		{
			if (__menu_mc)
			{
				__toolsTouchList.dispose();
				__backgroundsTouchList.dispose();
				__fishTouchList.dispose();
				__decorTouchList.dispose();
				__gearTouchList.dispose();
				__btn_home.dispose();
				__btn_back.dispose();
				__menu.dispose();
				
				__btn_home = null;
				__btn_back = null;
				__menu = null;
				__toolsTouchList = null;
				__backgroundsTouchList = null;
				__fishTouchList = null;
				__decorTouchList = null;
				__gearTouchList = null;
			}
		}
	}

}