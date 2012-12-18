package 
{
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
	
	/**
	 * 测试文档类
	 * @author Alex
	 */
	public class Main extends Sprite 
	{
		//[Embed(source="../bin/assets.swf", symbol="horse")]
		//private var horseClass : Class;
		//private var horse : Sprite = new horseClass();
		
		//[Embed(source="../bin/assets.swf", symbol="man")]
		//private var manClass : Class;
		
		//[Embed(source="../bin/Test.swf", symbol="sprite84")]
		//private var mcClass : Class;
		//[Embed(source="../bin/Test1.swf", symbol="sprite84")]
		//private var mcClass : Class;
		//[Embed(source="../bin/assets.swf", symbol="mc")]
		//private var mcClass:Class;
		
		//[Embed(source="../lib/tile_01.png")]
		//private var Tile01:Class;
		
		//[Embed(source="../lib/tile_02.png")]
		//private var Tile02:Class;
		
		[Embed(source="/assets/spriteSheet.png")]
        protected var textureAtlasBitmap:Class;

        [Embed(source="/assets/sheetDetail.xml", mimeType="application/octet-stream")]
        protected var textureAtlasXML:Class;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			//else addEventListener(Event.ADDED_TO_STAGE, initMain);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//var url:String = "assets.swf";
			var url:String = "Test.swf";
			//var url:String = "Test1.swf";
			//var url:String = "kakaLib.swf";
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
			
			initBmrCanvas();
			
			//add a performance meter
			//var meter:PerformanceMeter = new PerformanceMeter();
			//addChild(meter);
		}
		
		private var bmrCanvas:BmrSprite;
		private var bmrSpr:BmrSprite;
		private function initBmrCanvas():void 
		{
			/**
			 *  BmrCanvas
			 */
			bmrCanvas = new BmrSprite();
			bmrCanvas.mouseChildren = false;
			bmrCanvas.mouseEnabled = false;
			this.addChild(bmrCanvas);
			//initSpr();
			//initSpr1();
			initSpr2();
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function initSpr():void 
		{
			
			var animationClassArray:Array = [ { name:"sprite60", x: -78, y: -139 },
											  { name:"sprite84", x: -26, y: -54 },
											  { name:"sprite207", x: -53, y: -199 },
											  { name:"sprite252", x: -28, y: -60 } ];
			/*
			var animationClassArray:Array = [ { name:"item_0", x: 0, y: 0 },
											  { name:"item_1", x: 0, y: 0 },
											  { name:"item_2", x: 0, y: 0 },
											  { name:"item_3", x: 0, y: 0 },
											  { name:"item_4", x: 0, y: 0 },
											  { name:"item_5", x: 0, y: 0 },
											  { name:"item_6", x: 0, y: 0 } ];
			*/
			var colNum:uint = 5;
			var rowNum:uint = 5;
			bmrCanvas.x = 400 / colNum;
			bmrCanvas.y = 300 / rowNum;
			for(var i:int = 0; i < rowNum; i++)
			{
				for(var j:int = 0; j < colNum; j++)
				{
					//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite60", -78, -139);
					//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite84", -26, -54);
					//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite207", -53, -199);
					//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite252", -28, -60);
					var randomObj:Object = animationClassArray[Math.floor(Math.random() * animationClassArray.length)];
					//var bmrAnimation:BmrAnimation = new BmrAnimation(randomObj.name, randomObj.x, randomObj.y, true);
					var bmrAnimation:BmrAnimation = BmrFactory.createBmrAnimation(randomObj.name, randomObj.x, randomObj.y, true);
					bmrAnimation.x = 800 * j / colNum;
					bmrAnimation.y = 600 * i / rowNum;
					bmrAnimation.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
					bmrCanvas.addChild(bmrAnimation);
					
					//bmrAnimation.addEventListener(BmrMouseEvent.MOUSE_DOWN, bmrCanvasMouseDownHandler);
					/**
					 * 附加测试属性，可能会改变渲染方式所以可能会加重CPU负担
					 */
					//bmrAnimation.visible = false;
					//bmrAnimation.alpha = Math.random();
					//bmrAnimation.rotation = Math.round(360 * Math.random());
					//bmrAnimation.scaleX = bmrAnimation.scaleY = Math.random();
					
					//鼠标事件
					//bmrAnimation.mouseEnabled = true;
					//显示渲染区域，类似于显示重绘区域
					//bmrAnimation.showRect = true;
				}
			}
			/*
			for (var i:int = 0; i < 100; i++)
			{
				//var bmrAnimation:BmrAnimation = new BmrAnimation("Main_mcClass");
				var bmrAnimation:BmrAnimation = new BmrAnimation("sprite60", -78, -139);
				//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite84", -26, -54);
				//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite207", -53, -199);
				//var bmrAnimation:BmrAnimation = new BmrAnimation("sprite252", -28, -60);
				//var bmrAnimation:BmrAnimation = new BmrAnimation(animationClassNames[Math.floor(animationClassNames.length * Math.random())]);
				bmrAnimation.x = 400 * Math.random();
				bmrAnimation.z = 300 * Math.random();
				//bmrAnimation.x = 100 * i;
				//bmrAnimation.x = 400;
				//bmrAnimation.y = 300;
				bmrAnimation.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
				//bmrAnimation.play();
				bmrCanvas.addChild(bmrAnimation);
			}
			*/
			/*
			for (i = 0; i < 11; i++) 
			{
				bmrSpr = new BmrSprite("Main_horseClass");
				bmrSpr.x = 400;
				bmrSpr.y = 60 * i;
				bmrCanvas.addChild(bmrSpr);
				if (i == 5) 
				{
					var man:BmrSprite = new BmrSprite("Main_manClass");
					//var man:BmrSprite = new BmrSprite("Main_horseClass");
					man.x = -30;
					man.y = -40;			
					bmrSpr.addChild(man);
				}
				//trace(bmrSpr.numChildren);
			}
			*/
		}
		
		private function initSpr1():void 
		{
			var animationClassArray:Array = [ { name:"item_0", x: 0, y: 0 },
											  { name:"item_1", x: 0, y: 0 },
											  { name:"item_2", x: 0, y: 0 },
											  { name:"item_3", x: 0, y: 0 },
											  { name:"item_4", x: 0, y: 0 },
											  { name:"item_5", x: 0, y: 0 },
											  { name:"item_6", x: 0, y: 0 } ];
			for (var i:int = 0; i < animationClassArray.length; i++) 
			{
				var randomObj:Object = animationClassArray[i];
				//var bmrAnimation:BmrAnimation = new BmrAnimation(randomObj.name, randomObj.x, randomObj.y, true);
				var bmrAnimation:BmrAnimation = BmrFactory.createBmrAnimation(randomObj.name, randomObj.x, randomObj.y, true);
				bmrAnimation.x = 800 * i / 7;
				bmrAnimation.y = 100;
				bmrAnimation.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
				bmrCanvas.addChild(bmrAnimation);
			}
		}
		
		private function initSpr2():void 
		{
			var atlasBitmap:Bitmap = new textureAtlasBitmap() as Bitmap;
			var atlasXML:XML = new XML(new textureAtlasXML());
			
			var bmrAnimation:BmrAnimation = BmrFactory.createBmrAnimationBySpriteSheet(atlasBitmap.bitmapData, atlasXML, true);
			bmrAnimation.x = 400;
			bmrAnimation.y = 300;
			bmrAnimation.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
			bmrCanvas.addChild(bmrAnimation);
			bmrA = bmrAnimation;
			
			var bmrAnimation1:BmrAnimation = BmrFactory.createBmrAnimationBySpriteSheet(atlasBitmap.bitmapData, atlasXML, true);
			bmrAnimation1.x = 400;
			bmrAnimation1.y = 300;
			//bmrAnimation1.rotation = 180;
			//bmrAnimation1.scaleX = -1;
			bmrAnimation1.scaleY = -1;
			bmrAnimation1.gotoAndPlay(uint(Math.random() * bmrAnimation.totalFrames + 1));
			//bmrCanvas.addChild(bmrAnimation1);
		}
		
		private var bmrA:BmrAnimation;
		private function enterFrameHandler(e:Event):void
		{
			//bmrSpr.x++;
			//trace("-----------------------------");
			//floorCanvas.render();
			//bmrCanvas.render();
			
			//bmrA.rotation += 2;
			
			BmrAnimaionManager.getInstance().updateAll();
		}
		
	}
}