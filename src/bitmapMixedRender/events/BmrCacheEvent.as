package bitmapMixedRender.events 
{
	import flash.events.Event;
	
	/**
	 * 位图缓存事件
	 * @author Alex
	 */
	public class BmrCacheEvent extends Event 
	{
		public static const SLICE_COMPLETE:String = "sliceComplete";
		
		public function BmrCacheEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
	}

}