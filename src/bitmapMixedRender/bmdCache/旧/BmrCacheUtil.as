package bitmapMixedRender.bmdCache 
{
	import bitmapMixedRender.utils.BDChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.display.BitmapData;
	/**
	 * @Description:位图动画工具
	 * @author Alex
	 * @date 2012/7/19 星期四 0:35
	 */
	public class BmrCacheUtil
	{
		public function BmrCacheUtil()
		{
		}
		
		/**
		 * 创建位图缓存动画，兼容现有两种格式
		 * @param	link
		 * @param	configXml
		 * @return
		 */
		public static function createBmrCacheAnimation(link:String, configXml:XML = null):BmrCacheAnimation
		{
			if (configXml)
			{
				return createBmrCacheAnimationByXml(link, configXml);
			}
			else 
			{
				return createBmrCacheAnimationByMc(link);
			}
		}
		
		/**
		 * 根据指定格式的XML创建位图缓存动画
		 * @param	link
		 * @param	configXml
		 * @return
		 */
		public static function createBmrCacheAnimationByXml(link:String, configXml:XML):BmrCacheAnimation
		{
			//var cacheFrames:Vector.<BmrCacheFrame> = new Vector.<BmrCacheFrame>();
			//var realFrameIndexs:Vector.<uint> = new Vector.<uint>();
			
			var totalFrames:int = configXml.frame.length();
			var realFrameDict:Dictionary = new Dictionary();
			var curIndex:uint = 0;
			
			for (var i:int = 0; i < totalFrames; i++) 
			{
				var frameXml:XML = configXml.frame[i];
				
				var bmdLink:String = frameXml.@link;
				var bmdClass:Class = getDefinitionByName(bmdLink) as Class;
				var sourceBitmapData:BitmapData = new bmdClass() as BitmapData;
				
				var offsetX:Number = Number(frameXml.@offsetX);
				var offsetY:Number = Number(frameXml.@offsetY);
				
				var framesNum:uint = uint(frameXml.@framesNum);
				
				var cacheFrame:BmrCacheFrame = new BmrCacheFrame(sourceBitmapData, offsetX, offsetY);
				//cacheFrames.push(cacheFrame);
				for (var j:int = 0; j < framesNum; j++)
				{
					//realFrameIndexs.push(i);
					realFrameDict[++curIndex] = cacheFrame;
				}
			}
			//trace("realFrameIndexs:" + realFrameIndexs);
			
			//var bmrCacheAnimation:BmrCacheAnimation = new BmrCacheAnimation(link, cacheFrames, realFrameIndexs);
			var bmrCacheAnimation:BmrCacheAnimation = new BmrCacheAnimation(link, totalFrames, realFrameDict);
			BmrCacheManager.getInstance().addCacheAnimation(bmrCacheAnimation);
			
			return bmrCacheAnimation;
		}
		
		/**
		 * 判断两个缓存位图帧是否一致
		 * @param	frame1
		 * @param	frame2
		 * @return
		 */
		public static function checkSameBmrCacheFrame(frame1:BmrCacheFrame, frame2:BmrCacheFrame):Boolean
		{
			if (frame1 == null || frame2 == null)
			{
				return false;
			}
			if (frame1.offsetX != frame2.offsetX || frame1.offsetY != frame2.offsetY) 
			{
				return false;
			}
			return checkSameBitmapData(frame1.sourceBitmapData, frame2.sourceBitmapData);
		}
		
		/**
		 * 判断两个位图数据是否一致
		 * @param	bmd1
		 * @param	bmd2
		 * @return
		 */
		public static function checkSameBitmapData(bmd1:BitmapData, bmd2:BitmapData):Boolean
		{
			if (bmd1 == null || bmd2 == null) 
			{
				return false;
			}
			if (bmd1.compare(bmd2) == 0) 
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		/**
		 * 根据显示对象库连接创建位图缓存动画
		 * @param	link
		 * @return
		 */
		public static function createBmrCacheAnimationByMc(link:String):BmrCacheAnimation
		{
			try
			{
				var mcClass:Class = getDefinitionByName(link) as Class;
				//var sourceMc:MovieClip = new mcClass() as MovieClip;
			}
			catch(e:Error)
			{
				return null;
			}
			
			var bmrCacheAnimation:BmrCacheAnimation = new BmrCacheAnimation(link);
			BmrCacheManager.getInstance().addCacheAnimation(bmrCacheAnimation);
			
			return bmrCacheAnimation;
		}
		
		/**
		 * 根据显示对象库连接创建位图缓存动画(一次性绘制所有帧)
		 * @param	link
		 * @return
		 */
		public static function createBmrCacheAnimationByMcOnce(link:String):BmrCacheAnimation
		{
			//var cacheFrames:Vector.<BmrCacheFrame> = new Vector.<BmrCacheFrame>();
			//var realFrameIndexs:Vector.<uint> = new Vector.<uint>();
			var realFrameDict:Dictionary = new Dictionary();
			var frameLabelDict:Dictionary = new Dictionary();
			
			try
			{
				var mcClass:Class = getDefinitionByName(link) as Class;
				var sourceMc:MovieClip = new mcClass() as MovieClip;
			}
			catch(e:Error)
			{
				return null;
			}
			
			var curFrame:BmrCacheFrame;
			var lastFrame:BmrCacheFrame;
			var lastIndex:int = -1;
			var totalFrames:int = sourceMc.totalFrames;
			for (var i:int = 1; i <= totalFrames ; i++) 
			{
				moveAnimationToFrame(sourceMc, i);
				//trace("sourceMc.currentFrameLabel:" + sourceMc.currentFrameLabel);
				//trace("sourceMc.currentLabel:" + sourceMc.currentLabel);
				curFrame = bmrClip(sourceMc);
				if (checkSameBmrCacheFrame(curFrame, lastFrame))
				{
					//清除重复帧
					curFrame.dispose();
					//trace("重复帧:" + lastIndex);
				}
				else
				{
					lastFrame = curFrame;
					lastIndex++;
					//cacheFrames.push(lastFrame);
					//trace("新帧:" + lastIndex);
				}
				//realFrameIndexs.push(lastIndex);
				realFrameDict[i] = lastFrame;
				
				//记录关键帧标签
				var currentFrameLabel:String = sourceMc.currentFrameLabel;
				if (currentFrameLabel != null && frameLabelDict[currentFrameLabel] == null) 
				{
					frameLabelDict[currentFrameLabel] = i;
				}
			}
			
			//var bmrCacheAnimation:BmrCacheAnimation = new BmrCacheAnimation(link, cacheFrames, realFrameIndexs, frameLabelDict);
			var bmrCacheAnimation:BmrCacheAnimation = new BmrCacheAnimation(link, totalFrames, realFrameDict, frameLabelDict);
			BmrCacheManager.getInstance().addCacheAnimation(bmrCacheAnimation);
			
			return bmrCacheAnimation;
		}
		
		//移动当前mc到某帧
		public static function moveAnimationToFrame(clip:DisplayObjectContainer, frame:int):void
		{
			//if (clip == null || frame <= 1)
			if (clip == null || frame < 1)
			{
				return;
			}
			if (clip is MovieClip)
			{
				var mc:MovieClip = clip as MovieClip;
				//if (mc.totalFrames >= frame)
				//{
					//mc.gotoAndStop(frame);
				//}
				if (frame == 1) 
				{
					mc.stop();
				}
				else 
				{
					if (mc.currentFrame == mc.totalFrames) 
					{
						mc.gotoAndStop(1);
					}
					else 
					{
						mc.nextFrame();
					}
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
		
		//额外边界
		private static const EXTRA_EDGE:Number = 20;
		//将当前帧转化为位图缓存帧
		public static function bmrClip(sourceDisObj:DisplayObject):BmrCacheFrame
		{
			//get bounds
			var bounds:Rectangle = sourceDisObj.getBounds(sourceDisObj);
			//var bounds:Rectangle = sourceDisObj.getRect(sourceDisObj);
			//trace("bounds: " + bounds);
			
			if (bounds.width <= 0 || bounds.height <= 0) 
			{
				//return null;
				return BmrCacheFrame.EMPTY_CACHE_FRAME;
			}
			
			bounds.x = bounds.x - EXTRA_EDGE;
			bounds.y = bounds.y - EXTRA_EDGE;
			bounds.width = bounds.width + EXTRA_EDGE * 2;
			bounds.height = bounds.height + EXTRA_EDGE * 2;
			
			//make sure the frame is at the same bounds as the original
			var mat:Matrix = new Matrix();
			mat.translate( -bounds.x, -bounds.y);
			
			var bmpd:BitmapData;
			
			//create bitmapdata from frame
			bmpd = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
			//bmpd = new BitmapData(bounds.width, bounds.height, true, 0x00ffffff);
			//bmpd = new BitmapData(bounds.width, bounds.height, true, 0xff000000);
			//bmpd = new BitmapData(bounds.width, bounds.height, true, 0x40ffffff);
			
			bmpd.draw(sourceDisObj, mat, null, null, null, true);
			//bmpd.draw(sourceDisObj, mat, null, BlendMode.ERASE, null, true);
			//bmpd.draw(sourceDisObj, mat, sourceDisObj.transform.colorTransform, sourceDisObj.blendMode, null, true);
			//trace("sourceDisObj.blendMode:" + sourceDisObj.blendMode);
			
			//bmpd.threshold(bmpd, bmpd.rect, new Point(), "==", 0xff000000, 0x00ffffff);
			//bmpd.threshold(bmpd, bmpd.rect, new Point(), "==", 0xff000000, 0x00000000);
			//bmpd.threshold(bmpd, bmpd.rect, new Point(), "==", 0xff000000, 0x00ffffff, 0x00ffffff);
			
			//store the frame in an array
			//mat.translate(2 * bounds.x, 2 * bounds.y);
			//mat.translate(bounds.x, bounds.y);
			
			var removeBlackBmpd:BitmapData = BDChannel.removeBlackBG(bmpd, 0);
			bmpd.dispose();
			bmpd = null;
			
			//剪裁处理位图透明区域
			//var minRect:Rectangle = bmpd.getColorBoundsRect(0xffffffff, 0x00000000, false);
			var minRect:Rectangle = removeBlackBmpd.getColorBoundsRect(0xffffffff, 0x00000000, false);
			if (minRect.width <= 0 || minRect.height <= 0) 
			{
				//return null;
				return BmrCacheFrame.EMPTY_CACHE_FRAME;
			}
			
			var destPoint:Point = new Point();
			var minBmd:BitmapData = new BitmapData(minRect.width, minRect.height, true, 0);
			//minBmd.copyPixels(bmpd, minRect, destPoint, null, null, true);
			minBmd.copyPixels(removeBlackBmpd, minRect, destPoint, null, null, true);
			//Matrix (a:Number=1, b:Number=0, c:Number=0, d:Number=1, tx:Number=0, ty:Number=0) …
			//minBmd.draw(bmpd, new Matrix(1, 0, 0, 1, -minRect.x, -minRect.y));
			
			var offsetX:Number = minRect.x + bounds.x;
			var offsetY:Number = minRect.y + bounds.y;
			
			//bmpd.dispose();
			//bmpd = null;
			removeBlackBmpd.dispose();
			removeBlackBmpd = null;
			bounds = null;
			destPoint = null;
			mat = null;
			
			var frame:BmrCacheFrame = new BmrCacheFrame(minBmd, offsetX, offsetY);
			return frame;
		}
	}

}