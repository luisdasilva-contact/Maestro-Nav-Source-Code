/*
 * Class representing variables related to the gameplay loop, independent of level-specific functionalities. 
*/

class gameplayLoop {
	private static var itemToSpawn:Number; // In gameplay loop, determines which one of 12 possible items is being spawned. See SpawnOrder.as for more details.
	private static var gameLost:Boolean;
	private static var gameWon:Boolean;
	private static var spawnOrder:Array; // Array holding the item spawning order for a level.
	private static var _onScreenItems:Array;
	private static var _rhythmCounter:Number; // Counter for the game's rhythm feature.
	private static var _setIntervalID:Number; // ID of the setInterval function that controls the game's rhythm.
	private static var _rhythmThreshold = 300; // "Wiggle room" for user to move on beat and still earn a rhythm point, given in MS.
	private static var _rhythmReward = 20; // Number of rhythm points required to earn a power-up, at which point the counter resets to 0.
	private static var _frameReference = 12; // slowed down footage, found that the 'thump' from the beat actually occurs halfway through the actual beat
	
	// Getters and setters for the variables above.
	public static function get rhythmThreshold():Number {
		return _rhythmThreshold;
	};
	
	public static function get frameReference():Number {
		return _frameReference;
	};
	
	public static function get rhythmCounter():Number {
		return _rhythmCounter;
	};
	
	public static function get setIntervalID():Number {
		return _setIntervalID;
	};
	
	public static function get onScreenItems():Array {
		return _onScreenItems;
	};
	
	public static function set onScreenItems(newItems:Array){
		_onScreenItems = newItems;
	};
	
	/*
	 * Set the rhythm counter to a specified value. Also contains functionality to reset counter to 0 and reward player with a power-up if they reach
	   the rhythm reward threshold.
	 * @param {Number} newRhythmVal The new value for the rhythm counter.
	*/
	public static function set rhythmCounter(newRhythmVal:Number):Void {
		_rhythmCounter = newRhythmVal;
		
		if (_rhythmCounter >= _rhythmReward){
			_rhythmCounter = 0;
			playerProps.changeGems(1);
			UI.displayGems();
			_root['soundManager'].playDing();
		};
		
		UI.setRhythmValue(_rhythmCounter);
	};		
	
	/*
	 * Initiates variables and functionality related to gameplay.  
	*/
	public static function initializeGameplay():Void {		
		if (!levelProps.currentLevelNo){ // if levelNo not set from main, default to 1st
			levelProps.currentLevelNo = 1;
		};
		
		gameLost = false;
		gameWon = false;
		_rhythmCounter = 0;
		spawnOrder = [];
		itemToSpawn = 0;
		_onScreenItems = [];
		
		_root.soundManager.toggleMenuLoop();
		levelProps.initializeLevel(_root['topRoad']._y, _root['midRoad']._y, _root['lowRoad']._y);
		
		UI.initializeGameplayUI();	
			
		playerProps.player.gotoAndStop(1);			
		Key.addListener(_root.listener);
		playerProps.player._y = levelProps.topRoadY;
	
		
		
		if (levelProps.currentLevelNo == 1){
			spawnOrder = SpawnOrder.level;
		} else {
			spawnOrder = SpawnOrder.level2;
		};
		
		_setIntervalID = setInterval(gameplayLoop.spawnLevelItems, (60 / levelProps.BPM) * 1000);
		
		_root.onEnterFrame = function(){
			gameplayLoop.funcsEveryFrame();
		};
	};
	
	
	 
	/*
	 * Functionality to run each frame during gameplay. Includes checking if the user won or lost, as well as spawning items.
	*/
	public static function funcsEveryFrame():Void {		
		levelProps.timer = getTimer() - levelProps.gameTimeAtStart;
		
		if (playerProps.health == 0){
			gameLost = true;
		};
		
		if (!(gameLost) && !(gameWon)){
			if (itemToSpawn >= spawnOrder.length){
				gameWon = true;
			};			
		} else {
			// Clearing out remaining on-screen items in the event the user has lost.
			clearInterval(_setIntervalID);
			for (var i:Number = 0; i < onScreenItems.length; i++){
				var itemToRemove = onScreenItems[i];
				itemToRemove.removeMovieClip();				
			};
			
			onScreenItems = [];			
			var endScreenFrame:String;
			
			if (levelProps.currentLevelNo == 1){
				_root.soundManager.toggleMainTheme();
			} else if (levelProps.currentLevelNo == 2){
				_root.soundManager.toggleEncore();
			};
			
			_root.soundManager.toggleMenuLoop();
			
			if (gameWon == true){
				if (levelProps.currentLevelNo == 1){
					endScreenFrame = "WonFirst";
				} else {
					endScreenFrame = "WonSecond";
				};							
			} else if (gameLost == true){
				if (levelProps.currentLevelNo == 1){
					endScreenFrame = "LostFirst";					
				} else {
					endScreenFrame = "LostSecond";
				}				
			};
			
			_root.attachMovie('swipeTransition', 'swipeTransitionGameEnd', _root.getNextHighestDepth());
			_root['swipeTransitionGameEnd'].onEnterFrame = function() {
				utilities.goToAfterTransition(endScreenFrame, _root['swipeTransitionGameEnd'], UI.transitionFrame, UI.unloadUI());
			};
			delete _root.onEnterFrame;
		};		
	};
		
	/*
	 * Spawns items for the level on a counter. If the array runs out of items to spawn, game is won. Function also checks user's
	  health to determine if they lost.
	*/
	public static function spawnLevelItems():Void {	
		levelProps.msOfLastBeat = levelProps.timer;
		
		switch(spawnOrder[itemToSpawn]){
			case(1):
				_root.attachMovie('badVibe', 'item' + itemToSpawn, _root.getNextHighestDepth());
				levelProps.setBVSmokeOffset(_root['item' + itemToSpawn], false);
				_root['item' + itemToSpawn]._y = levelProps.topRoadY;
				break;
			case(2):				
				_root.attachMovie('badVibe', 'item' + itemToSpawn, _root.getNextHighestDepth());
				levelProps.setBVSmokeOffset(_root['item' + itemToSpawn], false);
				_root['item' + itemToSpawn]._y = levelProps.midRoadY;
				break;
			case(3):
				_root.attachMovie('badVibe', 'item' + itemToSpawn, _root.getNextHighestDepth());
				levelProps.setBVSmokeOffset(_root['item' + itemToSpawn], false);
				_root['item' + itemToSpawn]._y = levelProps.lowRoadY;
				break;
			case(4):
				_root.attachMovie('stereoJunk', 'item' + itemToSpawn, _root.getNextHighestDepth());
				_root['item' + itemToSpawn]._y = levelProps.topRoadY;
				break;
			case(5):
				_root.attachMovie('stereoJunk', 'item' + itemToSpawn, _root.getNextHighestDepth());
				_root['item' + itemToSpawn]._y = levelProps.midRoadY;
				break;
			case(6):
				_root.attachMovie('stereoJunk', 'item' + itemToSpawn, _root.getNextHighestDepth());
				_root['item' + itemToSpawn]._y = levelProps.lowRoadY;						
				break;
			case(7): 
				_root.attachMovie('BadVibeDoubleWithGap', 'item' + itemToSpawn,	_root.getNextHighestDepth());
				levelProps.setBVSmokeOffset(_root['item' + itemToSpawn], true);
				_root['item' + itemToSpawn]._y = levelProps.topRoadY;					
				break;
			case(8):
				_root.attachMovie('BadVibeDoubleNoGap', 'item' + itemToSpawn, _root.getNextHighestDepth());	
				levelProps.setBVSmokeOffset(_root['item' + itemToSpawn], true);
				_root['item' + itemToSpawn]._y = levelProps.topRoadY;	
				break;
			case(9):
				_root.attachMovie('BadVibeDoubleNoGap', 'item' + itemToSpawn, _root.getNextHighestDepth());		
				levelProps.setBVSmokeOffset(_root['item' + itemToSpawn], true);
				_root['item' + itemToSpawn]._y = levelProps.midRoadY;	
				break;	
			case(10):
				_root.attachMovie('gem', 'item' + itemToSpawn, _root.getNextHighestDepth());
				_root['item'+itemToSpawn]._y = levelProps.topRoadY;
				break;	
			case(11):
				_root.attachMovie('gem', 'item' + itemToSpawn, _root.getNextHighestDepth());
				_root['item'+itemToSpawn]._y = levelProps.midRoadY;						
				break;	
			case(12):
				_root.attachMovie('gem', 'item' + itemToSpawn, _root.getNextHighestDepth());
				_root['item'+itemToSpawn]._y = levelProps.lowRoadY;						
				break;	
		};
		
		_root['item'+itemToSpawn].gotoAndStop(1);
		
		if (spawnOrder[itemToSpawn] !== 0){
			_root['item'+itemToSpawn]._x = levelProps.spawnX;
			_root['item' + itemToSpawn].thisItemType = spawnOrder[itemToSpawn];
			
			_root['item' + itemToSpawn].onEnterFrame = function() {
				levelProps.spawnedGameplayElementBehavior(this);					
			};
			onScreenItems.push(_root['item' + itemToSpawn]);
		};
		
		itemToSpawn++;
	};
};
