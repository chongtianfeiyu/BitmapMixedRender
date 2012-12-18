package bitmapMixedRender.display 
{
	import bitmapMixedRender.bmdCache.BmrCacheFrame;
	import bitmapMixedRender.bmdCache.BmrCacheManager;
	import bitmapMixedRender.bmdCache.BmrClipper;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Bmr素材生成工程
	 * @author Alex
	 */
	public class BmrFactory 
	{
		public function BmrFactory() 
		{
		}
		
		/**
		 * 根据元件名创建BmrSprite
		 * @param	className
		 * @param	offsetX
		 * @param	offsetY
		 * @param	smoothing
		 * @return
		 */
		public static function createBmrSprite(className:String = "", offsetX:Number = 0, offsetY:Number = 0, smoothing:Boolean = false):BmrSprite
		{
			var bmrSprite:BmrSprite = new BmrSprite(className, smoothing);
			var bmrCacheFrame:BmrCacheFrame;
			if (BmrCacheManager.getInstance().isCached(className))
			{
				//trace("isCached");
				bmrCacheFrame = BmrCacheManager.getInstance().getFrame(className);
			}
			else 
			{
				var sprClass:Class = getDefinitionByName(className) as Class;
				var sourceSpr:DisplayObject = new sprClass() as DisplayObject;
				bmrCacheFrame = BmrClipper.bmrClip(sourceSpr, offsetX, offsetY);
				BmrCacheManager.getInstance().putFrame(className, bmrCacheFrame);
				sourceSpr = null;
			}
			bmrSprite.bmrCacheFrame = bmrCacheFrame;
			bmrSprite.updateBmrBitmapPos();
			return bmrSprite;
		}
		
		/**
		 * 根据元件名创建BmrAnimation
		 * @param	className
		 * @param	offsetX
		 * @param	offsetY
		 * @param	smoothing
		 * @return
		 */
		public static function createBmrAnimation(className:String = "", offsetX:Number = 0, offsetY:Number = 0, smoothing:Boolean = false):BmrAnimation
		{
			var bmrAnimation:BmrAnimation = new BmrAnimation(className, smoothing);
			var bmrCacheFrames:Vector.<BmrCacheFrame>;
			if (BmrCacheManager.getInstance().isCached(className)) 
			{
				//trace("isCached");
				bmrCacheFrames = BmrCacheManager.getInstance().getAnimation(className);
			}
			else 
			{
				var mcClass:Class = getDefinitionByName(className) as Class;
				var sourceMc:MovieClip = new mcClass() as MovieClip;
				var totalFrames:uint = sourceMc.totalFrames;
				//trace("totalFrames:" + totalFrames);
				bmrCacheFrames = new Vector.<BmrCacheFrame>(totalFrames, true);
				BmrCacheManager.getInstance().putAnimation(className, bmrCacheFrames);
				
				for (var i:int = 1; i <= totalFrames ; i++) 
				{
					moveAnimationToFrame(sourceMc, i);
					var frame:BmrCacheFrame = BmrClipper.bmrClip(sourceMc, offsetX, offsetY);
					//bmrCacheFrames.push(frame);
					bmrCacheFrames[i - 1] = frame;
				}
				sourceMc = null;
			}
			bmrAnimation.totalFrames = bmrCacheFrames.length;
			bmrAnimation.bmrCacheFrames = bmrCacheFrames;
			bmrAnimation.bmrCacheFrame = bmrCacheFrames[0];
			bmrAnimation.updateBmrBitmapPos();
			return bmrAnimation;
		}
		
		private static function moveAnimationToFrame(clip:DisplayObjectContainer, frame:int):void
		{
			if (clip is MovieClip)
			{
				var mc:MovieClip = clip as MovieClip;
				if (mc.totalFrames >= frame)
				{
					mc.gotoAndStop(frame);
				}
			}
			for (var i:int = 0; i < clip.numChildren; i++)
			{
				var child:DisplayObjectContainer = clip.getChildAt(i) as DisplayObjectContainer;
				if (child)
				{
					moveAnimationToFrame(child, frame);
				}
			}
		}
		
		/**
		 * 根据精灵表创建BmrAnimation
		 * @param	atlasBmd
		 * @param	atlasXML
		 * @return
		 */
		public static function createBmrAnimationBySpriteSheet(atlasBmd:BitmapData, atlasXML:XML, smoothing:Boolean = false):BmrAnimation
		{
			var bmrAnimation:BmrAnimation = new BmrAnimation("", smoothing);
			var bmrCacheFrames:Vector.<BmrCacheFrame> = new Vector.<BmrCacheFrame>();
			for (var i:int = 0; i < atlasXML.SubTexture.length(); i++) 
			{
				var subXml:XML = atlasXML.SubTexture[i];
				//trace(subXml.@name);
				var clipX:Number = Number(subXml.@x);
				var clipY:Number = Number(subXml.@y);
				var frameWidth:Number = Number(subXml.@width);
				var frameHeight:Number = Number(subXml.@height);
				var frameX:Number = Number(subXml.@frameX);
				var frameY:Number = Number(subXml.@frameY);
				var frameBmd:BitmapData = new BitmapData(frameWidth, frameHeight, true, 0);
				var sourceRect:Rectangle = new Rectangle(clipX, clipY, frameWidth, frameHeight);
				var destPoint:Point = new Point();
				frameBmd.copyPixels(atlasBmd, sourceRect, destPoint, null, null, true);
				sourceRect.x = -frameX;
				sourceRect.y = -frameY;
				var frame:BmrCacheFrame = new BmrCacheFrame(frameBmd, sourceRect, null);
				bmrCacheFrames.push(frame);
			}
			bmrAnimation.totalFrames = bmrCacheFrames.length;
			bmrAnimation.bmrCacheFrames = bmrCacheFrames;
			bmrAnimation.bmrCacheFrame = bmrCacheFrames[0];
			bmrAnimation.updateBmrBitmapPos();
			return bmrAnimation;
		}
	}

}