class playerProps{	
	private static var _health:Number;
	private static var _maxHealth = 3;
	private static var _gems:Number;
	private static var _maxGems = 2;
	private static var _receptorIsInvul:Boolean;
	private static var _canMoveAgain:Boolean; // Bool to check if player has already moved after key is pressed; prevents player from moving if the button is held down
	private static var _playerHurtState:Boolean;
	private static var _defaultAnimLabel:String = "Default"; // Labels for the frames in the timeline of the character (named 'receptor' in code)
	private static var _invulAnimLabel:String = "Invul";
	private static var _hurtAnimLabel:String = "Hurt";
	private static var _enemyRhythmRange:Number = 350; // the number of pixels an enemy must be within for an on-beat movement to count as a dodge;
	// provides some "wiggle room" to account for lag
	
	// Getters and setters for the variables above.
	public static function get health():Number {
		return _health;
	};
	
	public static function set health(newHealth:Number):Void {
		_health = newHealth;
	};
	
	public static function get maxHealth():Number {
		return _maxHealth;
	};
	
	public static function get gems():Number {
		return _gems;
	};
	
	public static function set gems(newGems:Number):Void {
		_gems = newGems;
	};
	
	public static function get maxGems():Number {
		return _maxGems;
	};
	
	public static function get receptorIsInvul():Boolean {
		return _receptorIsInvul;
	};
	
	public static function set receptorIsInvul(invulState:Boolean):Void {
		_receptorIsInvul = invulState;
	};
	
	public static function get playerHurtState():Boolean {
		return _playerHurtState;
	};
	
	/*
	 * Sets player hurt state and changes animation accordingly. 
	 * @param {Boolean} newState Whether or not the player is hurt.
	*/
	public static function set playerHurtState(newState:Boolean):Void {
		_playerHurtState = newState;
		
		if (newState == true && (_receptorIsInvul == false)){
			_root['receptor'].gotoAndStop(_hurtAnimLabel);
			var hurtStateAnimation = _root['receptor'].receptorHurtAnim;
			
			hurtStateAnimation.onEnterFrame = function() {
				if (hurtStateAnimation._currentframe == hurtStateAnimation._totalframes){
					_root['receptor'].gotoAndStop(_defaultAnimLabel);
					_playerHurtState = false;
				};	
			};
		};
	};
	
	/*
	 * Retrieves player Movie Clip from the timeline.
	 * @return {MovieClip} The player's Movie Clip.
	*/ 
	public static function get player():MovieClip {
		return _root['receptor'];
	}
	
	/*
	 * Sets player health. Also resets rhythm counter if player was hurt. 
	 * @param {Number} healthDiff The value to add or subtract to/from the player's current health.
	*/
	public static function changeHealth(healthDiff:Number):Void {
		if (!_health){
			_health = 3; // defaulting health to 3 if no val is provided
		};
		
		_health = changeProp(_health, _maxHealth, healthDiff);		
		
		if (healthDiff < 0){
			gameplayLoop.rhythmCounter = 0;
		};
	};
	
	/*
	 * Sets player's gems.
	 * @param {Number} gemDiff The value to add or subtract to/from the player's current power-up count.
	*/
	public static function changeGems(gemDiff:Number):Void {
		if (!_gems){
			_gems = 0; // defaulting gems to 0 if no val is provided
		};
		
		_gems = changeProp(_gems, _maxGems, gemDiff);
	}
	
	/*
	 * Used for changing the player's properties (such as health or power-up count), while taking into account the maximum value (i.e.
	  a player can't have 4 health if the max is 3).
	 * @param {Number} current The current value for the property being altered.
	 * @param {Number} max The maximum value for the property being altered.
	 * @param {Number} difference The value to be added/subtracted to/from the current.
	 * @return {Number} The current value after the property has been changed.
	*/
	public static function changeProp(current:Number, max:Number, difference:Number):Number {
		if ((current + difference) > max){
			current = max;
		} else if ((difference > 0) && (current < max)){
			current += difference;
		} else if ((current + difference) < 0) {
			current = 0;
		} else if ((difference < 0) && (current > 0)){
			current += difference;
		};
		
		return current;
	};
	
	/*
	 * Activates the user's special ability. 1 power-up point recovers health, while 2 gives them brief invulnerability.
	*/ 
	public static function activateAbility():Void {
		if ((_gems == 1) && (_health < _maxHealth)){
			changeHealth(1);
			UI.displayHealth();
			_root['soundManager'].playDing();
			changeGems(-1);
			UI.displayGems();
		} else if (_gems == 2){			
			if (_playerHurtState){
				_playerHurtState = false;				
			};
			
			_root['soundManager'].playHeartbeat();
			receptorIsInvul = true;
			changeGems( -2);				
			_root['receptor'].gotoAndStop(_invulAnimLabel);
			var invulAnimation = _root['receptor'].receptorInvulAnim;
			invulAnimation.onEnterFrame = function() {
				if (invulAnimation._currentframe == invulAnimation._totalframes){
					_root['receptor'].gotoAndStop(_defaultAnimLabel);
					receptorIsInvul = false;
				};	
			};
			UI.displayGems();
		};
	};
	
	/*
	 * Manages functionality related to the animation that plays when the user moves from one lane to another. 
	 * @param {MovieClip} receptor The player object on the main timeline.
	 * @param {Number} keyCode The key the user pressed, representing the direction they moved.
	*/ 
	public static function playReceptorGhostAnim(receptor:MovieClip, keyCode:Number){
		if (keyCode == 38){
			if (receptor._y == levelProps.topRoadY){			
				spawnReceptorGhostAnim(receptor, "Skip");
			} else if ((receptor._y == levelProps.midRoadY) ||
					  (receptor._y == levelProps.lowRoadY)){
				spawnReceptorGhostAnim(receptor, "Up");
			};
		} else if (keyCode == 40){
			if ((receptor._y == levelProps.topRoadY) ||
				(receptor._y == levelProps.midRoadY)){
				spawnReceptorGhostAnim(receptor, "Down");
			} else if (receptor._y == levelProps.lowRoadY){
				spawnReceptorGhostAnim(receptor, "Skip");
			};		
		};		
	};
	
	/*
	 * Spawns the animation when the user moves from one lane to another.
	 * @param {MovieClip} receptor The player object on the main timeline.
	 * @param {String} direction The direction the player is moving, determining which animation to play.
	*/
	public static function spawnReceptorGhostAnim(receptor:MovieClip, direction:String):Void {
		var libraryGhostName:String = "receptorGhost" + direction;		
		var ghost = _root.attachMovie(libraryGhostName, libraryGhostName, _root.getNextHighestDepth());
		utilities.setEquivalentPosition(ghost, receptor);
		
		ghost.onEnterFrame = function() {
			utilities.deleteEnterFrameAndMC(this, true);			
		};			
	};	
	
	/*
	 * Moves player from one lane to the next based on their input (hitting "up" from the top lane transports them to the bottom lane and vice-versa).
	 * @param {Number} keyCode The key the player hit.
	*/
	public static function movePlayer(keyCode:Number){
		if (keyCode == 38){
			if (player._y == levelProps.topRoadY){
				player._y = levelProps.lowRoadY;
			} else if (player._y == levelProps.midRoadY){
				player._y = levelProps.topRoadY;
			} else if (player._y == levelProps.lowRoadY){
				player._y = levelProps.midRoadY;
			};
		} else if (keyCode == 40){
			if (player._y == levelProps.topRoadY){
				player._y = levelProps.midRoadY;
			} else if (player._y == levelProps.midRoadY){
				player._y = levelProps.lowRoadY;
			} else if (player._y == levelProps.lowRoadY){
				player._y = levelProps.topRoadY;
			};		
		};	
	};
	
	/*
	 * Functionality for the rhythm feature, checking if a user A) moved on the beat, and B) if they did so to dodge an enemy.
	 * @param {MovieClip} receptor The player object on the main timeline.
	*/
	public static function rhythmCheck(receptor:MovieClip){
		var timeSinceBeat = levelProps.timer - levelProps.msOfLastBeat;
		
		for (var i = 0; i < gameplayLoop.onScreenItems.length; i++){
			if (gameplayLoop.onScreenItems[i].thisItemType <= levelProps.enemySpawnNoMax){
				if (gameplayLoop.onScreenItems[i]._y == player._y){
					if (Math.abs(gameplayLoop.onScreenItems[i]._x - player._x) <= _enemyRhythmRange){
						if (timeSinceBeat <= gameplayLoop.rhythmThreshold){
							gameplayLoop.rhythmCounter++;
							break;
						};
					};					
				};			
			};		
		};
	};
	
	/*
	 * Initializes code for the player's controls.
	 * @param {MovieClip} receptor The player object on the main timeline.
	 * @param {Object} listener Event listener on the main timeline; listens for user input.
	*/ 
	public static function playerInit(receptor:MovieClip, listener:Object):Void {
		_canMoveAgain = true;
		_receptorIsInvul = false;
		
		listener.onKeyDown = function():Void {
			if ((Key.getCode() == 38 || Key.getCode() == 40) && 
				(_canMoveAgain == true)){
				playReceptorGhostAnim(receptor, Key.getCode());
				rhythmCheck();
				movePlayer(Key.getCode());				
				_canMoveAgain = false;
			};
			if (Key.getCode() == 32){
				activateAbility();
			};		 
		};
	 
		 listener.onKeyUp = function():Void {
			if (Key.getCode() == 38 || Key.getCode() == 40){
				_canMoveAgain = true;
			};
		 };
	 };	
};