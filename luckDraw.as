package  {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.utils.*;
	import com.greensock.*
	import com.greensock.easing.*
	import flash.external.ExternalInterface;
	
	
	public class luckDraw extends Sprite {
		
		private var delayTime:Number = 0
		private var targetTable:Array = []
		private var totalRotaion:Number = 0;

		private var v0:Number = 24
		private var roundNum:Number = 2
		private var aMov:Number = 1/20
		
		private var onStartFunc:String;
		private var onStopFunc:String;


		public function luckDraw() {
			
		}

		public function initUI():void {
			targetTable = []
			for(var i:int = 0; i < 8; i++) {
				targetTable.push(i*45)
			}
			startBtn.addEventListener(MouseEvent.CLICK, onStart)
		}
		
		private function onStart(me:MouseEvent):void {
			ExternalInterface.call(onStartFunc)
			startBtn.removeEventListener(MouseEvent.CLICK, onStart)
			startBtn.enabled = false;
			rotationv0();
		}

		private function rotationv0():void {
			TweenLite.to(pan, 360/(10*v0), {rotation:360, ease:Linear.easeNone ,onComplete:rotationv0});
		}

		/**
		 	delayTime = 0
			v0 = 24
			roundNum = 2
			aMov = 1/20
			*/

		public function setParam(obj:Object):void {
			delayTime = obj.delayTime || delayTime
			v0 = obj.v0 || v0             // 开始转动时的转速
			roundNum = obj.roundNum || 2        // 结束转动后的圈数,默认为2
			aMov = obj.aMov || 1/20

			onStartFunc = obj.onStartFunc
			onStopFunc = obj.onStopFunc

		}
 
		public function setStop(i:int):void {
			ExternalInterface.call('debug','setStop');
			// get destination rotation in index
			var fix:Number = pan.rotation < 0 ? 360 - pan.rotation : pan.rotation
			totalRotaion= -targetTable[i] + 360*roundNum
			TweenLite.to(pan, 0.25/aMov, {rotation:totalRotaion, ease:Circ.easeOut,onComplete:setTimeout,onCompleteParams:[onStop, delayTime]});
		}

		private function onStop():void {
			// call js rotate stop
			ExternalInterface.call('debug','onStop')
			try{
				ExternalInterface.call(onStopFunc)
			}catch(e:Error){}
		}

		public function resetUI():void{
			// reset ui
			startBtn.addEventListener(MouseEvent.CLICK, onStart)
			startBtn.enabled = true;
		}

	}
	
}
