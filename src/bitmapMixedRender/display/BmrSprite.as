package bitmapMixedRender.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import bitmapMixedRender.bmdCache.BmrCacheFrame;
	
	/**
	 * 位图Sprite类
	 * @author Alex
	 */
	public class BmrSprite extends Sprite 
	{
		public var bmrCacheFrame:BmrCacheFrame;
		protected var _offsetX:Number;
		protected var _offsetY:Number;
		
		protected var _bmrBitmap:Bitmap;
		
		/**
		 * BmrSprite 构造函数
		 * @param	className 显示对象类名
		 * @param	offsetX 对注册点进行x轴offsetX像素平移
		 * @param	offsetY 对注册点进行y轴offsetY像素平移
		 */
		public function BmrSprite(className:String = "", smoothing:Boolean = false):void
		{
			super();
			_bmrBitmap = new Bitmap();
			_bmrBitmap.smoothing = smoothing;
			this.addChild(_bmrBitmap);
			_bmrBitmap.bitmapData = null;
		}
		
		public function updateBmrBitmapPos():void
		{
			if (bmrCacheFrame == null) 
			{
				return;
			}
			_bmrBitmap.bitmapData = bmrCacheFrame.sourceBitmapData;
			_bmrBitmap.x = bmrCacheFrame.boundsRect.x;
			_bmrBitmap.y = bmrCacheFrame.boundsRect.y;
		}
		
		public function dispose():void
		{
			bmrCacheFrame = null;
			//removeChild(_bmrBitmap);
			while (numChildren > 0) 
			{
				removeChildAt(0);
			}
		}
	}

}