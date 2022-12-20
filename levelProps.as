/*
 * Class of static properties and functions related to the level the user is currently in, including object locations and spawn timers.  
*/
class levelProps {	
	private static var _timer:Number; // timer is the number of milliseconds the level has been running.
	private static var _BPM:Number; // beats per minute of current track.
	private static var _itemSpeed:Number;
	private static var _topRoadY:Number;
	private static var _midRoadY:Number;
	private static var _lowRoadY:Number;	
	private static var _collidedItemCounter:Number; // Tracks the number of items the user has collided with. Used to provide unique instance names to collision animations.
	private static var _currentLevelNo:Number; 
	private static var _gameStarted:Boolean = false;
	private static var _gameTimeAtStart:Number; // number of MS that passed between the .swf opening and the level beginning
	private static var _msOfLastBeat:Number; // exact time from the start of the level, given in milliseconds, of the last beat
	private static var _enemySpawnNoMax:Number = 9; // in the gameplay loop, items 1 through this number will spawn an enemy
	private static var _spawnX:Number = 1280; // Where items will spawn on the screen.	
	
	
	// Getters and setters for the variables above.
	public static function get timer():Number {
		return _timer;
	};
	
	public static function set timer(newTime:Number):Void {
		_timer = newTime;
	};
	
	public static function get BPM():Number {
		return _BPM;
	};
	
	public static function set BPM(newBPM:Number):Void {
		_BPM = newBPM;
	};
	
	public static function get itemSpeed():Number {
		return _itemSpeed;
	};	
	
	public static function set itemSpeed(newSpeed:Number):Void {
		_itemSpeed = itemSpeed;
	};	
	
	public static function get topRoadY():Number {
		return _topRoadY;
	};
	
	public static function set topRoadY(newY:Number):Void {
		_topRoadY = newY;
	};
	
	public static function get midRoadY():Number {
		return _midRoadY;
	};
	
	public static function set midRoadY(newY:Number):Void {
		_midRoadY = newY;
	};
	
	public static function get lowRoadY():Number {
		return _lowRoadY;
	};
	
	public static function set lowRoadY(newY:Number):Void {
		_lowRoadY = newY;
	};
	
	public static function get collidedItemCounter():Number {
		return _collidedItemCounter;
	};
	
	public static function set collidedItemCounter(newCollidedVal:Number):Void {
		_collidedItemCounter = newCollidedVal;
	};
	
	public static function get currentLevelNo():Number {
		return _currentLevelNo;
	};
	
	public static function set currentLevelNo(levelNo:Number):Void {
		_currentLevelNo = levelNo;
	};
	
	public static function get gameStarted():Boolean {
		return _gameStarted;
	};
	
	public static function set gameStarted(started:Boolean):Void{
		_gameStarted = started;
	};
	
	public static function get gameTimeAtStart():Number {
		return _gameTimeAtStart;
	};
	
	public static function set gameTimeAtStart(newStartTime:Number):Void{
		_gameTimeAtStart = newStartTime;
	};
	
	public static function get msOfLastBeat():Number {
		return _msOfLastBeat;
	};
	
	public static function set msOfLastBeat(newMSOfLastBeat:Number):Void{
		_msOfLastBeat = newMSOfLastBeat;
	};
	
	public static function get spawnX():Number {
		return _spawnX;
	};
	
	public static function get enemySpawnNoMax():Number {
		return _enemySpawnNoMax;
	};
	
	
	
	/*
	 * Sets variables specific to each level.  
	 * @param {Number} topRoadY The Y position on-screen of the top road/lane.
	 * @param {Number} midRoadY The Y position on-screen of the middle road/lane.
	 * @param {Number} lowRoadY The Y position on-screen of the bottom road/lane.
	*/
	public static function initializeLevel(topRoadY:Number, midRoadY:Number, lowRoadY:Number):Void {		
		_topRoadY = topRoadY;
		_midRoadY = midRoadY;
		_lowRoadY = lowRoadY;
		
		if (_currentLevelNo == 1){
			_root.soundManager.toggleMainTheme();
			_BPM = 140;
			_itemSpeed = 7;
		} else if (_currentLevelNo == 2){
			_root.soundManager.toggleEncore();
			_BPM = 143;
			_itemSpeed = 8;
		};
		
		playerProps.health = 3;
		playerProps.gems = 0;
		playerProps.playerHurtState = false;
		
		_collidedItemCounter = 0;
		_timer = 0;
		_gameTimeAtStart = getTimer();
		_msOfLastBeat = 0;
		gameStarted = true;		
	};
	
	/*
	 * Sets the behavior for any items that have been spawned, including movement across the screen and behavior upon
	   colliding with the player. This behavior will run each frame.
	 * @param {MovieClip} gameplayElement The item that will take on this behavior.
	*/
	public static function spawnedGameplayElementBehavior(gameplayElement:MovieClip):Void {
		gameplayElement._x -= _itemSpeed;		
		var hitPlayer = false;
		
		if (gameplayElement.thisItemType >= 7 && gameplayElement.thisItemType <= 9){
			/* using the "x, y, shapeFlag" hitTest opposed to target hitTest to account for enemies with gaps (i.e.
		 enemy type where an enemy is on the top lane and bottom lane at the same time)*/
			if (gameplayElement.hitTest(playerProps.player._x + playerProps.player._width, playerProps.player._y, true)){
				hitPlayer = true;
			};
		} else {
			if ((gameplayElement.hitTest(playerProps.player))){
				hitPlayer = true;
			};
		};	
		
		if (hitPlayer){
			_collidedItemCounter++;
			removeItemFromOnScreenList(gameplayElement);
			
			if ((gameplayElement.thisItemType <= _enemySpawnNoMax) && (playerProps.receptorIsInvul !== true) &&
				 (playerProps.playerHurtState !== true)) { // hit by enemy
				_root['soundManager'].playCough();
				playerProps.changeHealth(-1); 
				UI.displayHealth();
				playerProps.playerHurtState = true;
				spawnHitAnim('badVibeHit', gameplayElement);
			} else if ((gameplayElement.thisItemType <= _enemySpawnNoMax) &&
				 ((playerProps.receptorIsInvul == true) || (playerProps.playerHurtState == true))){ 
				spawnHitAnim('gemHit', gameplayElement);
			} else if (gameplayElement.thisItemType > _enemySpawnNoMax) {
				playerProps.changeGems(1);
				UI.displayGems();
				_root['soundManager'].playDing();
				spawnHitAnim('gemHit', gameplayElement);
			};
				gameplayElement.removeMovieClip();		
		} else if (gameplayElement._x <= -(gameplayElement._width)){
				removeItemFromOnScreenList(gameplayElement);
				gameplayElement.removeMovieClip();
		};
	};
	
	/*
	 * Spawns the collision animation when the player touches an item (i.e. a power-up or enemy). 
	 * @param {String} element Title of the animation to pull from the .fla library.
	 * @param {MovieClip} gameplayElement The item which the hit animation will play on top of.
	 * 
	*/
	public static function spawnHitAnim(element:String, gameplayElement:MovieClip):Void {
		var elemWithCounter:String = element + _collidedItemCounter;
		_root.attachMovie(element, elemWithCounter, _root.getNextHighestDepth());
		_root[elemWithCounter].onEnterFrame = function() {
			utilities.deleteEnterFrameAndMC(this, true);
		};
		utilities.setEquivalentPosition(_root[elemWithCounter], gameplayElement);		
	};
	
	/*
	 * Sets an offset for the smoke animation for Bad Vibes, creating visual variety when many are next to each other.
	 * @param {MovieClip} bv the Bad Vibe movie clip.
	 * @param {Boolean} isDouble If the Bad Vibe is stacked on top of another (case 7-9 in spawn code).
	 */ 
	public static function setBVSmokeOffset(bv, isDouble):Void{
		if (isDouble){
			if (bv.bvGapTop){
				utilities.randomizeMCStartFrame(bv.bvGapTop.bvSmokeInst);
				utilities.randomizeMCStartFrame(bv.bvGapLow.bvSmokeInst);
			} else if (bv.bvNoGapTop){
				utilities.randomizeMCStartFrame(bv.bvNoGapTop.bvSmokeInst);
				utilities.randomizeMCStartFrame(bv.bvNoGapMid.bvSmokeInst);
			};
		} else {
			var smoke = bv.bvSmokeInst;
			utilities.randomizeMCStartFrame(bv.bvSmokeInst);
		};
	};
	
	/*
	 * Scans the list of items on-screen, searching for one matching the title of the Movie Clip that is passed in. If it is found,
	   it is removed from the list.
	 * @param {Movie Clip} item The Movie Clip which will have its title searched for in the list of on-screen items.
	 * 
	*/
	public static function removeItemFromOnScreenList(item:MovieClip):Void {
		for (var i = 0; i < gameplayLoop.onScreenItems.length; i++){
			if (item._name == gameplayLoop.onScreenItems[i]._name){
				gameplayLoop.onScreenItems.splice(i, 1);
				return;
			};
		};
	};	
};