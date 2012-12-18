package 
{
	import bitmapMixedRender.bmdCache.BmrCacheAnimation;
	import bitmapMixedRender.bmdCache.BmrCacheManager;
	import bitmapMixedRender.display.BmrAnimation;
	import bitmapMixedRender.display.BmrFactory;
	import bitmapMixedRender.display.BmrSprite;
	import bitmapMixedRender.manager.BmrAnimaionManager;
	import com.flashdynamix.utils.SWFProfiler;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 测试文档类
	 * @author Alex
	 */
	public class NewMain extends Sprite 
	{
		public function NewMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			//else addEventListener(Event.ADDED_TO_STAGE, initMain);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var url:String = "role_nvyao_xinshouzhuang_run.swf";
			var request:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			loader.load(request, new LoaderContext(false, ApplicationDomain.currentDomain));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, initMain);
		}
		
		private function initMain(e:Event = null):void 
		{
			trace("initMain");
			e.target.removeEventListener(Event.COMPLETE, initMain);
			
			stage.frameRate = 30;
			stage.scaleMode = StageScaleMode.NO_SCALE;
            //stage.quality = StageQuality.LOW;
			
			var bg:Bitmap = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xCCDADF));
			this.addChild(bg);
			
			SWFProfiler.init(stage, this);
			SWFProfiler.start();
			
			var loader:Loader = e.target.loader as Loader;
			var xml:XML = loader.content["animationDetailXml"] as XML;
			
			//new BmrCacheAnimation("role_nvyao_xinshouzhuang_run", xml);
			
			loader.unload();
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//initSpr();
			initSpr1();
			//initSpr2();
		}
		
		private function initSpr():void 
		{
			var mcClass:Class = getDefinitionByName("role_nvyao_xinshouzhuang_run") as Class;
			var mc:MovieClip = new mcClass() as MovieClip;
			mc.x = 300;
			mc.y = 300;
			this.addChild(mc);
			
			var bmrAnimation:BmrAnimation = BmrAnimaionManager.getInstance().create("role_nvyao_xinshouzhuang_run", false, true, false);
			bmrAnimation.x = 500;
			bmrAnimation.y = 300;
			//bmrAnimation.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
			bmrAnimation.play();
			this.addChild(bmrAnimation);
			bmrA = bmrAnimation;
		}
		
		private function initSpr1():void 
		{
			for (var i:int = 0; i < 1000; i++) 
			{
				var bmrAnimation:BmrAnimation = BmrAnimaionManager.getInstance().create("role_nvyao_xinshouzhuang_run", false, true, false);
				bmrAnimation.x = 800 * Math.random();
				bmrAnimation.y = 600 * Math.random();
				bmrAnimation.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
				this.addChild(bmrAnimation);
			}
		}
		
		private function initSpr2():void 
		{
			for (var i:int = 0; i < 1000; i++) 
			{
				var mcClass:Class = getDefinitionByName("role_nvyao_xinshouzhuang_run") as Class;
				var mc:MovieClip = new mcClass() as MovieClip;
				mc.x = 800 * Math.random();
				mc.y = 600 * Math.random();
				mc.gotoAndPlay(uint(Math.random() * mc.totalFrames + 1));
				this.addChild(mc);
			}
		}
		
		private var bmrA:BmrAnimation;
		private function enterFrameHandler(e:Event):void
		{
			//trace("-----------------------------");
			//bmrA.rotation += 2;
			
			//BmrAnimaionManager.getInstance().updateAll();
		}
		
	}
}