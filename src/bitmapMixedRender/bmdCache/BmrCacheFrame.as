package bitmapMixedRender.bmdCache 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * 位图缓存单位
	 * @author Alex
	 */
	public class BmrCacheFrame 
	{
		//空帧
		public static const EMPTY_CACHE_FRAME:BmrCacheFrame = new BmrCacheFrame(null);
		
		//private var _index:uint;
		private var _offsetX:Number;
		private var _offsetY:Number;
		//private var _framesNum:uint;
		//private var _link:String;
		private var _sourceBitmapData:BitmapData;
		
		/**
		 * BmrCacheFrame 构造函数
		 * @param	sourceBitmapData 位图数据
		 * @param	boundsRect 位图矩形边框数据，注册点信息包含在里面了!
		 * @param	matrix 保存初始变换矩阵（无缩放、无旋转）
		 */
		public function BmrCacheFrame(sourceBitmapData:BitmapData, offsetX:Number = 0, offsetY:Number = 0):void
		{
			_sourceBitmapData = sourceBitmapData;
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		/**
		 * 清除
		 */
		public function dispose():void
		{
			if (_sourceBitmapData != null) 
			{
				_sourceBitmapData.dispose();
				_sourceBitmapData = null;
				_offsetX = 0;
				_offsetY = 0;
			}
		}
		
		//getter & setter
		public function get sourceBitmapData():BitmapData 
		{
			return _sourceBitmapData;
		}
		
		public function get offsetX():Number 
		{
			return _offsetX;
		}
		
		public function get offsetY():Number 
		{
			return _offsetY;
		}
		
	}

}