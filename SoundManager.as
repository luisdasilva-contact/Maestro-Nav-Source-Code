/*
 * Manages linkage to sounds in the .fla's library, and plays sounds accordingly.
 */ 

class SoundManager {
	private var _soundLibrary:Array = new Array;
	private var _menuIsPlaying:Boolean = false;
	private var _mainIsPlaying:Boolean = false;
	private var _encoreIsPlaying:Boolean = false;
	private var _soundLibraryLinkage:Array = ["menuLoop", "mainTheme", "snap", "blip",
		"glitch", "crack", "cough", "ding", "heartbeat", "encore"];	
	
	function SoundManager(){
		init();
	};
	
	public function init(){
		for (var i = 0; i < _soundLibraryLinkage.length; i++){
			var currentSound = new Sound();
			currentSound.attachSound(_soundLibraryLinkage[i]);
			_soundLibrary.push(currentSound);	
		};
	};

	function getSoundByIndex(indexVal:Number):Sound{
		return _soundLibrary[indexVal];
		
	};
	
	function get menuLoop():Sound {
		return _soundLibrary[0];
	};
	
	function get mainTheme():Sound {
		return _soundLibrary[1];
	};
	
	function get encore():Sound {
		return _soundLibrary[9];
	};
	
	function toggleMenuLoop():Void {
		if (_menuIsPlaying){
			_soundLibrary[0].stop();
			_menuIsPlaying = false;
		} else {
			_soundLibrary[0].start();
			_menuIsPlaying = true;
		};
	};	
	
	function toggleMainTheme():Void {
		if (_mainIsPlaying){
			_soundLibrary[1].stop();
			_mainIsPlaying = false;
		} else {
			_soundLibrary[1].start();
			_mainIsPlaying = true;
		};
	};

	function toggleEncore():Void {
		if (_encoreIsPlaying){
			_soundLibrary[9].stop();
			_encoreIsPlaying = false;
		} else {
			_soundLibrary[9].start();
			_encoreIsPlaying = true;
		};
	};

	function changeMainThemeVol(volVal:Number):Void {
		if (_mainIsPlaying){
			_soundLibrary[1].setVolume(volVal);
		};
	};

	public function playSnap():Void {
		_soundLibrary[2].start();
	};
	
	public function playBlip():Void {
		_soundLibrary[3].start();
	};
	
	function playGlitch():Void {
		_soundLibrary[4].start();
	};
	
	function playCrack():Void {
		_soundLibrary[5].start();
	};
	
	function playCough():Void {
		_soundLibrary[6].start();
	};
	
	function playDing():Void {
		_soundLibrary[7].start();
	};
	
	function playHeartbeat():Void {
		_soundLibrary[8].start();
	};
};