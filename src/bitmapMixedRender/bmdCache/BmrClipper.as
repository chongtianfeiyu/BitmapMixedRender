package bitmapMixedRender.bmdCache 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * BmrCacheFrame裁剪工具
	 * @author Alex
	 */
	public class BmrClipper 
	{
		public function BmrClipper() 
		{
		}
		
		public static function bmrClip(sourceSpr:DisplayObject, offsetX:Number = 0, offsetY:Number = 0):BmrCacheFrame
		{
			//get bounds
			var bounds:Rectangle = sourceSpr.getRect(sourceSpr);
			//trace("bounds: " + bounds);
			
			if (bounds.width <= 0 || bounds.height <= 0) 
			{
				return null;
			}
			//make sure the frame is at the same bounds as the original
			var mat:Matrix = new Matrix();
			mat.translate( -bounds.x, -bounds.y);
			
			var bmpd:BitmapData;
			
			//create bitmapdata from frame
			bmpd = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
			
			bmpd.draw(sourceSpr, mat, null, null, null, true);
			
			//store the frame in an array
			//mat.translate(2 * bounds.x, 2 * bounds.y);
			mat.translate(bounds.x, bounds.y);
			
			bounds.x += offsetX;
			bounds.y += offsetY;
			
			//剪裁处理位图透明区域
			var minRect:Rectangle = bmpd.getColorBoundsRect(0xffffffff, 0x00000000, false);
			if (minRect.width <= 0 || minRect.height <= 0) 
			{
				return null;
			}
			
			var destPoint:Point = new Point();
			var minBmd:BitmapData = new BitmapData(minRect.width, minRect.height, true, 0);
			minBmd.copyPixels(bmpd, minRect, destPoint, null, null, true);
			//Matrix (a:Number=1, b:Number=0, c:Number=0, d:Number=1, tx:Number=0, ty:Number=0) …
			//minBmd.draw(bmpd, new Matrix(1, 0, 0, 1, -minRect.x, -minRect.y));
			
			minRect.x += bounds.x;
			minRect.y += bounds.y;
			
			//trace("minRect:" + minRect);
			bmpd.dispose();
			bmpd = null;
			bounds = null;
			destPoint = null;
			mat = null;
			
			var frame:BmrCacheFrame = new BmrCacheFrame(minBmd, minRect, mat);
			
			return frame;
		}
	}

}