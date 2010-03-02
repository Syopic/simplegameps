import LevelStorage;
import GlobalStorage;
//
class Gameplay extends MovieClip {
	private static var currentLevel:Number;
	private static var gameplay_mc:MovieClip;
	private static var pondSkater_mc:MovieClip;
	private static var bonusesContainer_mc:MovieClip;
	private static var marksContainer_mc:MovieClip;
	private static var level_mc:MovieClip;
	private static var go_mc:Button;
	private static var intros_mc:MovieClip;
	//
	private static var isGame:Boolean = false;
	private static var isGO:Boolean = false;
	private static var speed:Number = 0;
	private static var angle:Number = 0;
	private static var isRotation:Boolean = false;
	private static var distantion:Number = 0;
	private static var dAngle:Number = 5;
	private static var dSpeed:Number = 0.03;
	private static var psScale:Number = 75;
	private static var dx:Number = 0;
	private static var dy:Number = 0;
	private static var scaleTo:Number = 100;
	private static var dScale:Number = 2;
	//
	private static var zoomDelay:Number = 0;
	private static var invisibleDelay:Number = 0;
	//
	private static var slowerIncrese:Number = 0;
	private static var bonusIncrese:Number = 0;
	private static var slowerPos_array = new Array();
	private static var bonusPlaces_array = new Array();
	//
	private static var mouseWheelListener:Object = new Object();
	//
	public static function init(mc:MovieClip):Void {
		gameplay_mc = mc;
		pondSkater_mc = mc["pondSkater_mc"];
		bonusesContainer_mc = mc["bonuses_mc"];
		marksContainer_mc = mc["marks_mc"];
		intros_mc = _root["intros_mc"];
		go_mc = mc["go_mc"];
		//
		
		
		//
		pondSkater_mc._visible = false;
		go_mc._visible = false;
		Mouse.removeListener(mouseWheelListener);
		// lifes
		for (var i:Number = 0; i<10; i++) {
			_root.infoPanel_mc.attachMovie("lifeInd", "lifeInd"+i, _root.infoPanel_mc.getNextHighestDepth(), {_x:515-i*30, _y:390});
		}
		updateLifes();
	}
	//
	public static function initLevel(levelNum:Number):Void {
		level_mc._x=0;
		level_mc._y=0;
		isGame = false;
		pondSkater_mc.insidePS_mc._rotation=0;
		
		currentLevel = levelNum;
		showIntro();
		//
		speed = 0;
		angle = 0;
		distantion = 0;
		slowerPos_array = LevelStorage["slowerPos"+levelNum+"_array"];
		bonusPlaces_array = LevelStorage["bonusPlaces"+levelNum+"_array"];
		scaleGameplayTo(250);
	}
	//
	private static function showIntro():Void {
		//trace(currentLevel);
		intros_mc.gotoAndStop("intro"+currentLevel);
		intros_mc.gameplayInstance = Gameplay;
	}
	//
	private static function onHideIntro():Void {
		intros_mc.gotoAndStop(1);
		go_mc._visible = true;
		go_mc["go_btn"].onPress = function() {
			go_mc._visible = false;
			runLevel();
			isGame = true;
		};
	}
	//
	private static function scaleGameplayTo(scaleVal:Number):Void {
		gameplay_mc._xscale = scaleVal;
		gameplay_mc._yscale = scaleVal;
	}
	//
	private static function runLevel():Void {
		gameplay_mc.gotoAndStop("level"+currentLevel);
		level_mc = gameplay_mc["level_mc"];
		// show ps
		pondSkater_mc._visible = true;
		pondSkater_mc._yscale = psScale;
		putSlower();
		putBonus();
		//
		// MouseWheel init
		mouseWheelListener.onMouseWheel = function(delta) {
			scaleGameplayTo(gameplay_mc._xscale+delta);
		};
		Mouse.addListener(mouseWheelListener);
		//
		pondSkater_mc.onMouseDown = function() {
			this.gotoAndPlay(1);
			this.insidePS_mc.gotoAndPlay("turn");
			isRotation = true;
		};
		pondSkater_mc.onMouseUp = function() {
			isRotation = false;
		};
		pondSkater_mc.onEnterFrame = function() {
			if (isGame) {
				//
				if (dSpeed<0 && speed<5) {
					dSpeed = -dSpeed;
				}
				if (dSpeed<0) {
					speed += dSpeed*20;
				} else {
					speed += dSpeed;
				}
				//
				distantion += speed;
				if (isRotation) {
					angle = angle-dAngle;
					this.insidePS_mc._rotation = angle;
				}
				//  
				dx = speed*Math.sin(Math.PI/180*angle);
				dy = speed*(-Math.cos(Math.PI/180*angle))*(psScale/100);
				//
				invisibleDelay--;
				if (invisibleDelay == 0) {
					invisibleDelay--;
					pondSkater_mc._visible = true;
					_root.infoPanel_mc.invisibleInd._alpha=20;
				}
				// 
				zoomDelay--;
				if (zoomDelay == 0) {
					zoomDelay--;
					scaleTo = 100;
					_root.infoPanel_mc.zoomInd._alpha=20;
				}
				//  
				bonusesContainer_mc._x = marksContainer_mc._x=level_mc._x -= dx;
				bonusesContainer_mc._y = marksContainer_mc._y=level_mc._y -= dy;
				showMarks();
				// detect collisions
				
				var hitsNum:Number = LevelStorage.levelHitsNum_array[currentLevel-1];
				
				
				for (var i:Number = 1; i<hitsNum+1; i++) {
					if (level_mc["h"+i].hitTest(this._parent._x, this._parent._y, 1)){
						isGO=true;
						isGame=false;
						scaleTo=250;
						dScale=10;
						
						//colissionHandler();
						zoomDelay=0;
						_root.infoPanel_mc.zoomInd._alpha=20;
						_root.infoPanel_mc.invisibleInd._alpha=20;
					}
				}
				
				//
				if (this.hitTest(bonusesContainer_mc["slower"])) {
					dSpeed = -Math.abs(dSpeed);
					putSlower();
				}
				var bonusesPlacesNum:Number = bonusPlaces_array.length;
				for (var i:Number = 0; i<bonusesPlacesNum+1; i++) {
					if (this.hitTest(bonusesContainer_mc["bonus"+i]) && !bonusesContainer_mc["bonus"+i]["isCheck"]) {
						var bonusType:String = bonusesContainer_mc["bonus"+i].bonusType;
						//trace(bonusType);
						if (bonusType == "stop") {
							speed =-Math.abs(speed)/5;
						}
						if (bonusType == "zoomIn") {
							zoomDelay = GlobalStorage.allBonusDelay;
							scaleTo = 150;
							_root.infoPanel_mc.zoomInd._alpha=100;
						}
						if (bonusType == "zoomOut") {
							zoomDelay = GlobalStorage.allBonusDelay;
							scaleTo = 50;
							_root.infoPanel_mc.zoomInd._alpha=100;
						}
						if (bonusType == "life") {
							GlobalStorage.lifes++;
							updateLifes();
						}
						if (bonusType == "invisible") {
							invisibleDelay = GlobalStorage.allBonusDelay;
							pondSkater_mc._visible = false;
							_root.infoPanel_mc.invisibleInd._alpha=100;
						}
						bonusesContainer_mc["bonus"+i]["isCheck"] = true;
						bonusesContainer_mc["bonus"+i].play();
					}
				}
				//        
				updateInfoPanel();
			}
			//
			if (isGame || isGO) {
				if (isGO && Math.round(gameplay_mc._xscale) >= scaleTo){
					colissionHandler();
				} 
				if (Math.round(gameplay_mc._xscale) != scaleTo) {
					
					if (gameplay_mc._xscale>scaleTo) {
						scaleGameplayTo(gameplay_mc._xscale-dScale);
					} else {
						scaleGameplayTo(gameplay_mc._xscale+dScale);
					}
				}
				
			}
		};
	}
	//
	private static function showMarks():Void {
		if (isRotation) {
			marksContainer_mc.attachMovie("mark", "mark"+marksContainer_mc.getNextHighestDepth(), marksContainer_mc.getNextHighestDepth(), {_x:-level_mc._x+pondSkater_mc._x+(random(10)-5), _y:-level_mc._y+pondSkater_mc._y+(random(10)-5)});
		}
		if (random(5) == 0) {
			marksContainer_mc.attachMovie("mark2", "mark"+marksContainer_mc.getNextHighestDepth(), marksContainer_mc.getNextHighestDepth(), {_x:-level_mc._x+pondSkater_mc._x+(random(600)-300), _y:-level_mc._y+pondSkater_mc._y+(random(600)-300)});
		}
	}
	//
	private static function putSlower():Void {
		bonusesContainer_mc["slower"].removeMovieClip();
		bonusesContainer_mc.attachMovie("slower", "slower", 1, {_x:slowerPos_array[slowerIncrese][0], _y:slowerPos_array[slowerIncrese][1]});
		slowerIncrese++;
		if (slowerIncrese>=slowerPos_array.length) {
			slowerIncrese = 0;
		}
		putBonus();
	}
	//
	private static function putBonus():Void {
		var bName:String = LevelStorage.bonusesNames_array[random(LevelStorage.bonusesNames_array.length)];
		bonusIncrese = random(bonusPlaces_array.length);
		bonusesContainer_mc.attachMovie(bName, "bonus"+bonusIncrese, bonusIncrese+10, {_x:bonusPlaces_array[bonusIncrese][0], _y:bonusPlaces_array[bonusIncrese][1], bonusType:bName});
	}
	//
	private static function updateInfoPanel():Void {
		_root.infoPanel_mc.score_tf.text = Math.round(distantion);
		//
		//           
		var g_bonus:Object = {x:0, y:0};
		bonusesContainer_mc["slower"].localToGlobal(g_bonus);
		var halfX:Number = 275;
		var halfY:Number = 210;
		//
		if (g_bonus.x>=0 && g_bonus.x<=550 && g_bonus.y>=0 && g_bonus.y<=420) {
			_root.infoPanel_mc.indicator_mc._visible = false;
		} else {
			_root.infoPanel_mc.indicator_mc._visible = true;
			//
			var dpx:Number = g_bonus.x-halfX;
			var dpy:Number = g_bonus.y-halfY;
			//top bottom
			if (g_bonus.x>0 && g_bonus.x<550) {
				if (g_bonus.y<0) {
					_root.infoPanel_mc.indicator_mc._y = 0;
					_root.infoPanel_mc.indicator_mc._x = halfX-dpx*halfY/dpy;
				} else {
					_root.infoPanel_mc.indicator_mc._y = 420;
					_root.infoPanel_mc.indicator_mc._x = halfX+dpx*halfY/dpy;
				}
			} else if (g_bonus.y>0 && g_bonus.y<420) {
				if (g_bonus.x<0) {
					_root.infoPanel_mc.indicator_mc._y = halfY-dpy*halfX/dpx;
					_root.infoPanel_mc.indicator_mc._x = 0;
				} else {
					_root.infoPanel_mc.indicator_mc._y = halfY+dpy*halfX/dpx;
					_root.infoPanel_mc.indicator_mc._x = 550;
				}
			} else if (g_bonus.x<0 && g_bonus.y<0) {
				if (dpx/dpy>(g_bonus.x)/(g_bonus.y)) {
					_root.infoPanel_mc.indicator_mc._y = 0;
					_root.infoPanel_mc.indicator_mc._x = halfX-dpx*halfY/dpy;
				} else {
					_root.infoPanel_mc.indicator_mc._y = halfY-dpy*halfX/dpx;
					_root.infoPanel_mc.indicator_mc._x = 0;
				}
			} else if (g_bonus.x<0 && g_bonus.y>420) {
				if (Math.abs(dpx/dpy)>Math.abs((g_bonus.x)/(g_bonus.y-420))) {
					_root.infoPanel_mc.indicator_mc._y = 420;
					_root.infoPanel_mc.indicator_mc._x = halfX+dpx*halfY/dpy;
				} else {
					_root.infoPanel_mc.indicator_mc._y = halfY-dpy*halfX/dpx;
					_root.infoPanel_mc.indicator_mc._x = 0;
				}
			} else if (g_bonus.x>550 && g_bonus.y>420) {
				if (dpx/dpy>(g_bonus.x-550)/(g_bonus.y-420)) {
					_root.infoPanel_mc.indicator_mc._y = 420;
					_root.infoPanel_mc.indicator_mc._x = halfX+dpx*halfY/dpy;
				} else {
					_root.infoPanel_mc.indicator_mc._x = 550;
					_root.infoPanel_mc.indicator_mc._y = halfY+dpy*halfX/dpx;
				}
			} else if (g_bonus.x>550 && g_bonus.y<0) {
				if (Math.abs(dpx/dpy)>Math.abs((g_bonus.x-550)/(g_bonus.y))) {
					_root.infoPanel_mc.indicator_mc._y = 0;
					_root.infoPanel_mc.indicator_mc._x = halfX-dpx*halfY/dpy;
				} else {
					_root.infoPanel_mc.indicator_mc._x = 550;
					_root.infoPanel_mc.indicator_mc._y = halfY+dpy*halfX/dpx;
				}
			}
		}
	}
	//
	private static function updateLifes():Void {
		for (var i:Number = 0; i<10; i++) {
			if (i>=GlobalStorage.lifes) {
				_root.infoPanel_mc["lifeInd"+i]._visible = false;
			} else {
				_root.infoPanel_mc["lifeInd"+i]._visible = true;
			}
		}
	}
	
	private static function colissionHandler(): Void
	{
			
			GlobalStorage.lifes--;
			initLevel(currentLevel);
			updateLifes();
			scaleTo=100;
			isGO=false;
			dScale=2;
		}
}
