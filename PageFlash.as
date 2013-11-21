package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.utils.*;
	import com.greensock.*
	import com.greensock.easing.*
	import flash.external.ExternalInterface;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.media.Sound;
	
	
	public class PageFlash extends Sprite {
		
		private var targetTable:Array = []
		private var totalRotaion:Number = 0;

		private var ld:luckDraw

		public function PageFlash() {
			Security.allowDomain("*");  
			Security.allowInsecureDomain("*");
			if(stage){
				init();
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, init)
			}
		}

		private function init(e:Event = null):void {
			if(e){
				removeEventListener(Event.ADDED_TO_STAGE, init)
			}
			initJS();
			initUI();
			targetTable = []
			for(var i:int = 0; i < 8; i++) {
				targetTable.push(i*45)
			}
		}

		private function initJS():void {
			if(ExternalInterface){
				ExternalInterface.addCallback('setParam', setParam)
				ExternalInterface.addCallback('setStop', setStop)
				ExternalInterface.addCallback('resetUI', resetUI)
			}
		}
		private var funcs:Object = {};
		private var s:Sound = new CSound();
		private function initUI():void {
			ld = t_luckDraw;
			ld.initUI();
			handMc.visible =false;
			
			function __mouseDown(me:MouseEvent):void {
				me.currentTarget.gotoAndPlay('down');
				handMc.scaleX = handMc.scaleY = 0.8;
			}
			function __mouseUp(me:MouseEvent):void {
				me.currentTarget.gotoAndPlay('up');
				handMc.scaleX = handMc.scaleY = 1;
			}
			function __mouseClick(me:MouseEvent):void {
				s.play();
				var b_name:String = me.currentTarget.name;
				ExternalInterface.call('debug', funcs[b_name+"Func"] + '         '+ b_name+"Func" )
				ExternalInterface.call(funcs[b_name+"Func"])
			}
			function __mouseOver(me:MouseEvent):void {
				Mouse.hide();
				handMc.visible = true;
				me.currentTarget.gotoAndPlay('down');
				handMc.x = mouseX+15
				handMc.y = mouseY+15
				me.updateAfterEvent();
			}
			function __mouseOut(me:MouseEvent):void {
				Mouse.show();
				handMc.visible = false;
				me.currentTarget.gotoAndPlay('up');
				handMc.x = mouseX+15
				handMc.y = mouseY+15
			}

			for(var i:int = 1; i < 5; i++){
				this['btn'+i].addEventListener(MouseEvent.MOUSE_DOWN, __mouseDown)
				this['btn'+i].addEventListener(MouseEvent.MOUSE_UP, __mouseUp)
				this['btn'+i].addEventListener(MouseEvent.CLICK, __mouseClick)
				this['btn'+i].addEventListener(MouseEvent.MOUSE_OVER, __mouseOver)
				this['btn'+i].addEventListener(MouseEvent.MOUSE_OUT, __mouseOut)
			}

			stage.addEventListener(Event.ENTER_FRAME, function __(e:Event):void {
				if(handMc.visible){
					handMc.x = mouseX+15
					handMc.y = mouseY+15
				}
			})
		}
		
		/**
		 	delayTime = 0
			v0 = 24
			roundNum = 2
			aMov = 1/20
			*/

		private function setParam(obj:Object):void {
			ld.setParam(obj)
			funcs["btn1Func"] = obj.jiaoshou
			funcs["btn2Func"] = obj.feichuan
			funcs["btn3Func"] = obj.huojian
			funcs["btn4Func"] = obj.taikongren
		}
 
		private function setStop(i:int):void {
			// get destination rotation in index
			ld.setStop(i)
		}

		private function resetUI():void{
			// reset ui
			ld.resetUI();
		}

	}
	
}