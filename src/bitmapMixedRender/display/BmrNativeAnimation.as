package bitmapMixedRender.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	/**
	 * 位图原生动画类
	 * @author Alex
	 */
	public class BmrNativeAnimation extends BmrAnimation 
	{
		protected var _nativeMc:MovieClip;
		public function BmrNativeAnimation(link:String)
		{
			try
			{
				var mcClass:Class = getDefinitionByName(link) as Class;
				_nativeMc = new mcClass() as MovieClip;
			}
			catch(e:Error)
			{
				_nativeMc = new MovieClip();
			}
			
			this.addChild(_nativeMc);
			this.mouseChildren = false;
			this.mouseEnabled = false;
			//this.play();
			this._isPlay = true;
		}
		
		/**
		 * 更新帧
		 */
		override public function updateFrame():void
		{
		}
		
		/**
		 * 渲染
		 */
		override protected function render():void
		{
		}
		
		//更新播放状态
		override protected function updatePlayStatus():void
		{
		}
		
		override protected function enterFrameHandler(e:Event):void 
		{
		}
		
		/**
		 * 清除
		 */
		override public function dispose():void
		{
			if (_nativeMc) 
			{
				_nativeMc.stop();
				_nativeMc = null;
			}
			while (numChildren > 0) 
			{
				removeChildAt(0);
			}
		}
		
		/**
		 * 套用MovieClip的API
		 */
		override public function get currentFrame():int 
		{
			return _nativeMc.currentFrame;
		}
		
		override public function get totalFrames():int
		{
			return _nativeMc.totalFrames;
		}
		
		override public function get isPlay():Boolean 
		{ 
			return _isPlay; 
		}
		
		override public function gotoAndPlay(frame:Object):void
		{
			_isPlay = true;
			_nativeMc.gotoAndPlay(frame);
		}
		
		override public function gotoAndStop(frame:Object):void
		{
			_isPlay = false;
			_nativeMc.gotoAndStop(frame);
		}
		
		override public function nextFrame():void
		{
			_isPlay = false;
			_nativeMc.nextFrame();
		}
		
		override public function play():void
		{
			_isPlay = true;
			_nativeMc.play();
		}
		
		override public function prevFrame():void
		{
			_isPlay = false;
			_nativeMc.prevFrame();
		}
		
		override public function stop():void
		{
			_isPlay = false;
			_nativeMc.stop();
		}
	}
}