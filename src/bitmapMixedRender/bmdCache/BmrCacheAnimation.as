package bitmapMixedRender.bmdCache 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * 位图缓存动画
	 * @author Alex
	 */
	public class BmrCacheAnimation 
	{
		//链接
		private var _link:String;
		//总帧数
		private var _totalFrames:int;
		//真实帧字典
		private var _realFrameDict:Dictionary;
		//关键帧标签字典
		private var _frameLabelDict:Dictionary;
		//
		private var _sourceMc:MovieClip;
		
		public function BmrCacheAnimation(link:String, totalFrames:int = 0, realFrameDict:Dictionary = null, frameLabelDict:Dictionary = null) 
		{
			//trace("BmrCacheAnimation()");
			//trace("link:" + link);
			_link = link;
			_totalFrames = totalFrames;
			//trace("_totalFrames:" + _totalFrames);
			_realFrameDict = realFrameDict;
			_frameLabelDict = frameLabelDict;
			//
			if (_totalFrames == 0)
			{
				var mcClass:Class = getDefinitionByName(link) as Class;
				_sourceMc = new mcClass() as MovieClip;
				BmrCacheUtil.moveAnimationToFrame(_sourceMc, 1);
				_totalFrames = _sourceMc.totalFrames;
				//trace("_totalFrames:" + _totalFrames);
				_realFrameDict = new Dictionary();
				_frameLabelDict = new Dictionary();
			}
		}
		
		/**
		 * 得到缓存帧内容
		 * @param	frame
		 * @return
		 */
		public function getCacheFrame(frame:int):BmrCacheFrame
		{
			//trace("BmrCacheAnimation/getCacheFrame()");
			//trace("frame:" + frame);
			//return _realFrameDict[frame];
			if(_realFrameDict != null){
			var cacheFrame:BmrCacheFrame = _realFrameDict[frame];
			if (cacheFrame == null) 
			{
				drawUtilFrame(frame);
				cacheFrame = _realFrameDict[frame];
			}
			else 
			{
			}
			}
			return cacheFrame;
		}
		
		private var _lastFrameIndex:int = 0;
		//绘制到指定帧
		private function drawUtilFrame(frame:int):void
		{
			//trace("BmrCacheAnimation/drawUtilFrame()");
			//trace("frame:" + frame);
			if (_sourceMc == null) 
			{
				return;
			}
			
			var lastFrameIndex:int;
			if (_realFrameDict[1] == null)
			{
				lastFrameIndex = 0;
			}
			else 
			{
				//lastFrameIndex = _sourceMc.currentFrame;
				lastFrameIndex = _lastFrameIndex;
			}
			//trace("lastFrameIndex:" + lastFrameIndex);
			var lastFrame:BmrCacheFrame = _realFrameDict[lastFrameIndex];
			var curFrame:BmrCacheFrame;
			for (var i:int = lastFrameIndex + 1; i <= frame; i++)
			{
				BmrCacheUtil.moveAnimationToFrame(_sourceMc, i);
				curFrame = BmrCacheUtil.bmrClip(_sourceMc);
				
				if (BmrCacheUtil.checkSameBmrCacheFrame(curFrame, lastFrame))
				{
					//清除重复帧
					curFrame.dispose();
					//trace("重复帧:" + i);
				}
				else
				{
					lastFrame = curFrame;
					//trace("新帧:" + i);
				}
				_realFrameDict[i] = lastFrame;
				
				//记录关键帧标签
				var currentFrameLabel:String = _sourceMc.currentFrameLabel;
				if (currentFrameLabel != null && _frameLabelDict[currentFrameLabel] == null) 
				{
					_frameLabelDict[currentFrameLabel] = i;
				}
			}
			_lastFrameIndex = frame;
			//最后一帧Draw完之后清除原始MC
			if (frame >= _totalFrames) 
			{
				_sourceMc.stop();
				_sourceMc = null;
			}
		}
		
		/**
		 * 根据帧数或者帧标签得到真实帧数
		 * @param	frame
		 * @return 0表示无此帧
		 */
		public function getFrameNum(frame:Object):int
		{
			if (frame is int)
			{
				return frame as int;
			}
			else
			{
				if (_frameLabelDict == null)
				{
					return 0;
				}
				var frameNum:int = int(_frameLabelDict[frame]);
				return frameNum;
			}
		}
		
		/**
		 * 清除
		 */
		public function dispose():void
		{
			//BmrCacheManager.getInstance().deleteCacheAnimation(_link);
			if (_realFrameDict != null)
			{
				for (var i:int = 1; i <= _totalFrames; i++) 
				{
					var frame:BmrCacheFrame = _realFrameDict[i];
					if (frame) 
					{
						frame.dispose();
					}
					delete _realFrameDict[i];
				}
				_realFrameDict = null;
			}
			if (_frameLabelDict != null) 
			{
				_frameLabelDict = null;
			}
		}
		
		//getter & setter
		public function get link():String 
		{
			return _link;
		}
		
		public function get totalFrames():int 
		{
			return _totalFrames;
		}
	}
}