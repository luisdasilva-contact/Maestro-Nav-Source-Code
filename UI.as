/* 
 * Class of static properties and functions related to the user interface, including menus and gameplay display.
*/

class UI {
	private static var _transitionFrame:Number = 11; // The frame in which the transition animation completely covers the screen; utilized by other functions which need to run background processes behind the scenes.
	private static var _healthIcons:Array = [];
	private static var _gemHolster:Array = [];
	private static var _gemIcons:Array = [];
	private static var _mobileUIResizeVal:Number = 1.5; // The scale-down factor of mobile gameplay elements in comparison to desktop
	private static var _mobileGameplayButtons:Array = ['mobileUpArrow', 'mobileDownArrow', 'mobileAbilityButton'];
	private static var _isMobile:Boolean = false;
	private static var _rhythmTextField:TextField;
	private static var rhythmTextFieldPrefix:String = "Rhythm: ";
	private static var _tutorialPages = ['Intro','tut2', 'tut3']; // Frame labels for the tutorial pages
	
	// Getters and setters for the variables above.
	public static function get transitionFrame():Number {
		return _transitionFrame;
	};
	
	public static function get healthIcons():Array {
		return _healthIcons;
	};
	
	public static function get gemIcons():Array {
		return _gemIcons;
	};
	
	public static function get gemHolster():Array {
		return _gemHolster;
	};
	
	public static function get mobileUIResizeVal():Number {
		return _mobileUIResizeVal;
	}
	
	public static function get isMobile():Boolean {
		return _isMobile;
	}
	
	public static function set isMobile(mobile:Boolean):Void {
		_isMobile = mobile;
	}
	
	public static function setRhythmValue(newVal:Number){
		_rhythmTextField.text = ""; // need this line because of a glitch in ruffle where a text field must be cleared before setting new text
		_rhythmTextField.text = rhythmTextFieldPrefix + newVal;
	}
	
	/*
	 * Initializes the "Play!" button in the main menu. Retrieves necessary elements directly from the stage. 
	 * Dev note: Grabbing the soundManager from the stage instead of implementing as a class variable because I wanted to keep UI.as
	   static, but a class's instance variables may only be initialized to compile-time constant expressions. Additionally, I didn't
	   want to be managing multiple instances of the SM, so I chose to only refer to one as a "master" manager.
	*/
	public static function playGameButtonInit():Void {
		var playGameButton = _root['playGame'];
		var rootSM = _root['soundManager'];
		
		playGameButton.onEnterFrame = function():Void {
			if (this._currentframe == this._totalframes){
				this.stop();
			};
		};
		
		playGameButton.onRelease = function():Void {
			var transitionMC = _root.attachMovie('swipeTransition', 'swipeTransitionInst', _root.getNextHighestDepth());
			transitionMC.onEnterFrame = function(){
				utilities.goToAfterTransition("Intro", transitionMC, _transitionFrame);
				_root['playGameButtonClickInst'].removeMovieClip();
				_root['playGameButtonHoverInst'].removeMovieClip();
			};
			rootSM.playSnap();
		};
		
		playGameButton.onRollOver = function():Void {
			rootSM.playBlip();			
			var hoverMC = _root.attachMovie('playGameButtonHover', 'playGameButtonHoverInst', _root.getNextHighestDepth());
		};	
		
		playGameButton.onRollOut = function():Void {			
			_root['playGameButtonHoverInst'].removeMovieClip();
		};	
		
		playGameButton.onPress = function():Void {			
			var clickMC = _root.attachMovie('playGameButtonClick', 'playGameButtonClickInst', _root.getNextHighestDepth());
		};	
	};
	
	/*
	 * Initializes the "Next" button on the tutorial's first page. Retrieves button directly from the stage. 
	*/
	public static function tutNextButtonInit(currentTutPage:Number):Void {
		var tutNextButton = _root['tutNext'];
		
		tutNextButton.onRelease = function():Void {
				gotoAndStop(_tutorialPages[currentTutPage + 1]);
				_root['soundManager'].playSnap();				
		};
	};
	
	/*
	 * Initializes the "Start Game" button across several pages, like the intro or game over screen. Retrieves button directly from the stage. 
	*/
	public static function startGameButtonInit(buttonTitle:String):Void {
		var startGameButton = _root[buttonTitle];
		
		startGameButton.onRelease = function() {
			var transitionMC = _root.attachMovie('swipeTransition', 'swipeTransitionInst', _root.getNextHighestDepth());
			transitionMC.onEnterFrame = function(){
				utilities.goToAfterTransition("Game", transitionMC, _transitionFrame);
			};			
			_root['soundManager'].playSnap();
		};
	};
	
	/*
	 * Initializes a button to go back to the main menu; currently used on the last frame of the game when the user beats the encore. 
	*/
	public static function backToMenuButtonInit(buttonTitle:String):Void {
		var backToMenuButton = _root[buttonTitle];
		
		backToMenuButton.onRelease = function() {
			var transitionMC = _root.attachMovie('swipeTransition', 'swipeTransitionInst', _root.getNextHighestDepth());
			transitionMC.onEnterFrame = function(){
				utilities.goToAfterTransition("Menu", transitionMC, _transitionFrame);
			};		
			_root['soundManager'].playSnap();
		};
	};
	
	/*
	 * Displays the user's current health during gameplay.
	*/
	public static function displayHealth():Void {
		var diffBetweenHealthAndDisplay = _healthIcons.length - playerProps.health;
		
		if (diffBetweenHealthAndDisplay > 0){
			for (var i = 0; i < diffBetweenHealthAndDisplay; i++){
				var iconToRemove = _healthIcons.pop();
				removeMovieClip(iconToRemove);			
			};
		} else if (diffBetweenHealthAndDisplay < 0){
			var loopVal = Math.abs(diffBetweenHealthAndDisplay);
			
			if (levelProps.gameStarted == false){
				var healthIconInst = _root.attachMovie('healthIcon','healthIconInst' + (_healthIcons.length + 1),_root.getNextHighestDepth());
				_healthIcons.push(healthIconInst);				
				if (_isMobile){
					healthIconInst._width = healthIconInst._width / mobileUIResizeVal;
					healthIconInst._height = healthIconInst._height/ mobileUIResizeVal;					
				};
			};	
			
			for (var i = 0; i < loopVal; i++){
				var instName = 'healthIcon' + (_healthIcons.length + 1);
				_root.attachMovie('healthIcon',instName,_root.getNextHighestDepth());
				_healthIcons.push(_root[instName]);
				
				if (_isMobile){
					_root[instName]._width = _root[instName]._width / _mobileUIResizeVal ;
					_root[instName]._height = _root[instName]._height / _mobileUIResizeVal ;
					_root[instName]._x = _root['healthIcon' + (_healthIcons.length - 1)]._x + 35;
				} else {
				_root[instName]._x = _root['healthIcon' + (_healthIcons.length - 1)]._x + 75;
				};
			};
		};		
	};
	
	/*
	 * Displays the grayed-out power-up tokens on the gameplay UI, representing the user's maximum potential number of power-up tokens. 
	*/
	public static function displayGemHolster():Void {
		var prevGemX:Number;
		for (var i = 0; i < playerProps.maxGems; i++){
			_root.attachMovie('gemUIHolster', 'gemUIHolster' + (i+1),_root.getNextHighestDepth());
			if (prevGemX){				
				if (_isMobile){
					_root['gemUIHolster'+(i+1)]._x = prevGemX + 75;
					_root['gemUIHolster'+(i+1)]._width = _root['gemUIHolster'+(i+1)]._width / _mobileUIResizeVal ;
					_root['gemUIHolster'+(i+1)]._height = _root['gemUIHolster'+(i+1)]._height / _mobileUIResizeVal ;
					
				} else {
				_root['gemUIHolster'+(i+1)]._x = prevGemX + 150;
				}
			} else {
				if (_isMobile){
					_root['gemUIHolster'+(i+1)]._x = 150;
					prevGemX = _root['gemUIHolster'+(i+1)]._x;
					_root['gemUIHolster'+(i+1)]._width = _root['gemUIHolster'+(i+1)]._width / _mobileUIResizeVal ;
					_root['gemUIHolster'+(i+1)]._height = _root['gemUIHolster'+(i+1)]._height / _mobileUIResizeVal ;
				
				} else {
					_root['gemUIHolster'+(i+1)]._x = 300;
					prevGemX = _root['gemUIHolster'+(i+1)]._x;
				}
			};
			UI.gemHolster.push(_root['gemUIHolster' + (i + 1)]);			
		};
	};
	
	/*
	 * Displays the user's current number of power-ups. 
	*/
	public static function displayGems():Void {		
		var diffBetweenGemsAndDisplay = _gemIcons.length - playerProps.gems;
		if (diffBetweenGemsAndDisplay > 0){
			for (var i = 0; i < diffBetweenGemsAndDisplay; i++){
				var iconToRemove = _gemIcons.pop();
				removeMovieClip(iconToRemove);			
			};
		} else if (diffBetweenGemsAndDisplay < 0){
			var loopVal = Math.abs(diffBetweenGemsAndDisplay);	
			
			for (var i = 0; i < loopVal; i++){
				
				var holsterSpaceToReference = _gemIcons.length + 1;
				var instName = 'gemIcon' + holsterSpaceToReference;
				_root.attachMovie('gemIcon',instName, _root.getNextHighestDepth());
				_gemIcons.push(_root[instName]);
				
				if (isMobile){
					_root[instName]._width = _root[instName]._width / _mobileUIResizeVal ;
					_root[instName]._height = _root[instName]._height / _mobileUIResizeVal ;
				};
				
				utilities.setEquivalentPosition(_root[instName], _root['gemUIHolster' + holsterSpaceToReference]);				
			};
		};	
	};
	
	/*
	 * Displays the rhythm counter.
	*/ 
	public static function displayRhythmCounter():Void {
		_root.createTextField("rhythmCounterInstc", _level0.getNextHighestDepth(), 650, 7, 400, 100);
		
		_root["rhythmCounterInstc"].textColor = 0xebe8d3;
		_root["rhythmCounterInstc"].text = rhythmTextFieldPrefix + gameplayLoop.rhythmCounter;
		
		var myTextFormat:TextFormat = new TextFormat();
		myTextFormat.size = 35;
		myTextFormat.font = "K2D";
		
		_root["rhythmCounterInstc"].setTextFormat(myTextFormat);
		_root["rhythmCounterInstc"].setNewTextFormat(myTextFormat);
		
		if (_isMobile){
			_root["rhythmCounterInstc"]._xscale = _root["rhythmCounterInstc"]._xscale / _mobileUIResizeVal;
			_root["rhythmCounterInstc"]._yscale = _root["rhythmCounterInstc"]._yscale / _mobileUIResizeVal;
			_root["rhythmCounterInstc"]._x = 350;
		};
		
		_rhythmTextField = _root["rhythmCounterInstc"];
	};
	
	/*
	 * Initializes all gameplay UI. 
	*/
	public static function initializeGameplayUI():Void {
		displayGemHolster();
		displayGems();		
		displayHealth();
		displayRhythmCounter();		
		
		if (_isMobile){
			initializeMobileButtons();
			levelProps.topRoadY -= 50;
			_root['topRoad']._y -= 50;
			levelProps.midRoadY -= 50;
			_root['midRoad']._y -= 50;
			levelProps.lowRoadY -= 50;
			_root['lowRoad']._y -= 50;
		};		
	};
	
	/*
	 * Unloads UI after a user has completed a level (win or loss). 
	*/
	public static function unloadUI():Void {
		for (var i = 0; i < _healthIcons.length; i++){
			var iconToRemove = _healthIcons.pop();
			removeMovieClip(iconToRemove);	
		};	
		
		for (var i = 0; i < _gemHolster.length; i++){
			var iconToRemove = _gemHolster.pop();
			removeMovieClip(iconToRemove);
		};
		
		if (_gemIcons.length > 0){
			for (var i = 0; i < _gemIcons.length; i++){
				var iconToRemove = _gemIcons.pop();
				removeMovieclip(iconToRemove);
			};
		};	
		
		_root["rhythmCounterInstc"].removeTextField();		
		
		if (isMobile){
			for (var i = 0; i < _mobileGameplayButtons.length; i++){
				var itemToUnload = _mobileGameplayButtons[i];
				removeMovieClip(_root[itemToUnload]);
			};
		};		
	};
	
	/*
	 * If the user is on mobile, initializes mobile buttons for touch control.
	 */ 
	public static function initializeMobileButtons(){
		var player = playerProps.player;
		
		for (var i = 0; i < _mobileGameplayButtons.length; i++){
			var buttonToSpawn = _mobileGameplayButtons[i];
			_root.attachMovie(buttonToSpawn, buttonToSpawn, _root.getNextHighestDepth());
			
			if (buttonToSpawn == 'mobileUpArrow'){
				_root[buttonToSpawn].onPress = function() {
					playerProps.playReceptorGhostAnim(player, 38);
					playerProps.movePlayer(38);				
					_root['soundManager'].playSnap();
				};
			} else if (buttonToSpawn == 'mobileDownArrow'){
				_root[buttonToSpawn].onPress = function() {
					playerProps.playReceptorGhostAnim(player, 40);
					playerProps.movePlayer(40);				
					_root['soundManager'].playSnap();
				};
			} else if (buttonToSpawn == 'mobileAbilityButton'){
				_root[buttonToSpawn].onPress = function() {
					playerProps.activateAbility();
					_root['soundManager'].playSnap();
				};
			};
		};
	};
};