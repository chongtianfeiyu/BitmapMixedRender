package bitmapMixedRender.manager 
{
	import bitmapMixedRender.bmdCache.BmrCacheAnimation;
	import bitmapMixedRender.bmdCache.BmrCacheManager;
	import bitmapMixedRender.display.BmrAnimation;
	import bitmapMixedRender.display.BmrNativeAnimation;
	/**
	 * BmrAnimaion管理类
	 * @author Alex
	 */
	public class BmrAnimaionManager 
	{
		private static var _instance:BmrAnimaionManager;
		private var items:Vector.<BmrAnimation>;
		
		public function BmrAnimaionManager(param_singletonblocker:SingletonBlocker):void
		{
			if (param_singletonblocker == null) 
			{
				throw new Error("Singleton -> use getinstance instead!");
			}			
			items = new Vector.<BmrAnimation>();
		}
		
		public static function getInstance():BmrAnimaionManager 
		{
			if (_instance == null) 
			{
				_instance = new BmrAnimaionManager(new SingletonBlocker());
			}
			return _instance;
		}
		
		public function create(link:String, smoothing:Boolean = false, autoUpdate:Boolean = false, isNativeMc:Boolean = false):BmrAnimation
		{
			if (isNativeMc) 
			{
				return new BmrNativeAnimation(link);
			}
			var cacheAnimation:BmrCacheAnimation = BmrCacheManager.getInstance().getCacheAnimation(link);
			if (cacheAnimation)
			{
				return new BmrAnimation(cacheAnimation, smoothing, autoUpdate);
			}
			else 
			{
				return null;
			}
		}
		
		public function add(item:BmrAnimation):void
		{
			var index:int = searchIndex(item);
			if (index != -1) 
			{
				trace("位图动画队列中已有此动画！");
				return;
			}
			items.push(item);
		}
		
		public function remove(item:BmrAnimation):void
		{
			var index:int = searchIndex(item);
			if (index == -1) 
			{
				trace("位图动画队列中没有此动画！");
				return;
			}
			items.splice(index, 1);
		}
		
		public function searchIndex(item:BmrAnimation):int
		{
			if (item == null) 
			{
				return -1;
			}
			for (var i:int = 0; i < items.length; i++) 
			{
				var curItem:BmrAnimation = items[i];
				if (curItem == item) 
				{
					return i;
				}
			}
			return -1;
		}
		
		public function updateAll():void
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				var item:BmrAnimation = items[i];
				item.updateFrame();
			}
		}
	}

}
internal class SingletonBlocker{}