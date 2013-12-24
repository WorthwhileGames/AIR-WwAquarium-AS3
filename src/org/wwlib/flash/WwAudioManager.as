package org.wwlib.flash
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import org.wwlib.WwAquarium.audio.applause;
	import org.wwlib.WwAquarium.audio.bubbles1;
	import org.wwlib.WwAquarium.audio.bubbles2;
	import org.wwlib.WwAquarium.audio.bubbles3;
	import org.wwlib.WwAquarium.audio.bubbles4;
	import org.wwlib.WwAquarium.audio.bubblesLoop1;
	import org.wwlib.WwAquarium.audio.bubblesLoop2;
	import org.wwlib.WwAquarium.audio.chime;
	import org.wwlib.WwAquarium.audio.click1;
	import org.wwlib.WwAquarium.audio.clickFast;
	import org.wwlib.WwAquarium.audio.mainMenuSting;
	import org.wwlib.WwAquarium.audio.mainMenuTag;
	import org.wwlib.WwAquarium.audio.setupLoop;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAudioManager
	{
		private static var audioDictionary:Dictionary;
		private static var clickSound:Sound;
		private static var clickFastSound:Sound;
		private static var applauseSound:Sound;
		private static var chimeSound:Sound;
		private static var mainMenuAudioTag:Sound;
		private static var mainMenuAudioSting:Sound;
		private static var setupLoopSound:Sound;
		private static var bassFillSound:Sound;
		private static var soundChannel:SoundChannel;
		
		private static var bubblesSound1:Sound;
		private static var bubblesSound2:Sound;
		private static var bubblesSound3:Sound;
		private static var bubblesSound4:Sound;
		private static var bubblesLoopSound1:Sound;
		private static var bubblesLoopSound2:Sound;
		
		public function WwAudioManager()
		{

		}
		
		public static function init():void
		{
			clickSound = new click1();
			clickFastSound = new clickFast();
			applauseSound = new applause();
			chimeSound = new chime();
			mainMenuAudioTag = new mainMenuTag();
			mainMenuAudioSting = new mainMenuSting();
			setupLoopSound = new setupLoop();
			bubblesSound1 = new bubbles1();
			bubblesSound2 = new bubbles2();
			bubblesSound3 = new bubbles3();
			bubblesSound4 = new bubbles4();
			bubblesLoopSound1 = new bubblesLoop1();
			bubblesLoopSound2 = new bubblesLoop2();
		}
		
		public static function playSound(id:String):SoundChannel
		{
			//var soundChannel:SoundChannel = null;
			if (soundChannel)
			{
				soundChannel.stop();
			}
			
			switch(id)
			{
				case "bubblesLoop":
				{
					soundChannel = bubblesLoopSound1.play(0, 100);
					soundChannel = bubblesLoopSound2.play(0, 100);
					break;
				}
				case "bubbles":
				{
					var rnd:int = Math.random() * 3;
					switch(rnd)
					{
						case 0:
						{
							soundChannel = bubblesSound1.play();
							break;
						}
						case 1:
						{
							soundChannel = bubblesSound2.play();
							break;
						}
						case 2:
						{
							soundChannel = bubblesSound3.play();
							break;
						}
						case 3:
						{
							soundChannel = bubblesSound4.play();
							break;
						}
							
						default:
						{
							break;
						}
					}
					
					break;
				}
				case "click":
				{
					soundChannel = clickSound.play();
					break;
				}
				case "click_fast":
				{
					soundChannel = clickFastSound.play();
					break;
				}
				case "applause":
				{
					soundChannel = applauseSound.play();
					break;
				}
				case "chime":
				{
					soundChannel = chimeSound.play();
					break;
				}
				case "mainMenu":
				{
					soundChannel = mainMenuAudioSting.play();
					var st:SoundTransform = new SoundTransform(.4);
					soundChannel.soundTransform = st;
					break;
				}
				case "setupLoop":
				{
					soundChannel = setupLoopSound.play(0, 3);
					break;
				}
				default:
				{
					break;
				}
			}
			
			return soundChannel;
		}
		
		public static function playMouseDown():void
		{
			clickFastSound.play();
		}
		
		public static function playMouseUp():void
		{
			clickSound.play();
		}
		
		public static function stopCurrentSound():void
		{
			if (soundChannel)
			{
				soundChannel.stop();
			}
		}
	}
}