﻿/*
 * Class containing the level design of each level. 
 * 1, 2, and 3 will spawn Bad Vibes on the top, middle, and low lanes respectively.
 * 4, 5, and 6 will spawn Stereo Junk on the top, middle, and low lanes respectively.
 * 7 will spawn a Bad Vibe on the top and low lanes at the same time.
 * 8 will spawn a Bad Vibe on the top and mid lanes at the same time.
 * 9 will spawn a Bad Vibe on the mid and low lanes at the same time.
 * 10, 11, and 12 will spawn power-ups on the top, middle, and low lanes respectively.
*/
class SpawnOrder {
	private static var _level:Array = new Array(		
		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,								
		0, 0, 0, 0, 0, 0, 0, 0, 
		0, 0, 0, 0, 0, 0, 0, 0,							
		1, 1, 1, 1, 2, 2, 2, 2,  
		3, 3, 3, 3, 2, 1, 2, 1,							
		2, 0, 0, 0, 3, 3, 3, 3,	
		11, 0, 0, 0, 1, 1, 2, 2,
		1, 2, 3, 0, 0, 0, 0, 0, 
		1, 0, 1, 0, 2, 2, 2, 2,
		3, 3, 1, 1, 3, 3, 0, 0,
		2, 2, 2, 2, 1, 0, 1, 0, 
		11, 2, 2, 1, 2, 2, 3, 3,
		1, 0, 2, 1, 2, 2, 3, 3,
		3, 1, 1, 0, 2, 0, 3, 0, 
		2, 2, 2, 2, 0, 1, 3, 1, 
		1, 2, 2, 1, 1, 1, 3, 3,
		2, 0, 2, 0, 2, 0, 2, 0,
		1, 3, 1, 0, 0, 2, 0, 0, 
		3, 0, 1, 1, 2, 2, 3, 3, 
		1, 1, 1, 1, 3, 3, 3, 1,
		1, 1, 3, 3, 1, 1, 0, 0, 
		3, 3, 3, 3, 2, 2, 3, 3,
		2, 2, 3, 3, 2, 2, 0, 0, 
		1, 1, 2, 2, 1, 1, 2, 2, 
		1, 1, 2, 2, 0, 0, 3, 3,
		2, 2, 0, 0, 1, 1, 1, 1,
		3, 3, 2, 0, 1, 0, 3, 0, 
		10, 0, 0, 0, 0, 0, 0, 0, 
		0, 0, 0, 0, 0, 0, 0, 0,
		11, 0, 0, 0, 0, 0, 0, 0, 
		0, 0, 0, 0, 0, 0, 0, 0, 
		4, 0, 0, 0, 0, 0, 0, 0,
		5, 0, 0, 0, 0, 0, 0, 0, 
		6, 0, 0, 0, 0, 1, 0, 0,
		1, 1, 1, 1, 2, 2, 2, 1,
		4, 0, 0, 0, 0, 3, 2, 0, 
		4, 0, 0, 5, 0, 0, 6, 0,
		4, 0, 0, 0, 5, 0, 0, 0,
		6, 0, 4, 0, 2, 0, 2, 0,
		6, 0, 0, 12, 0, 3, 4, 0,
		2, 5, 0, 0, 2, 2, 2, 0,
		4, 2, 0, 1, 2, 5, 0, 3,
		2, 0, 3, 1, 0, 2, 0, 1,
		4, 3, 0, 1, 5, 0, 0, 3,
		4, 0, 0, 1, 6, 0, 0, 3,
		5, 0, 1, 0, 5, 0, 0, 3, 
		1, 0, 6, 0, 0, 2, 0, 1,								 
		1, 11, 0, 0, 5, 0, 0, 6, 
		0, 0, 2, 0, 1, 1, 2, 2, 
		0, 0, 4, 5, 0, 0, 5, 0, 
		3, 5, 0, 0, 10, 0, 0, 0, 
		10, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 3, 2, 1, 1, 
		1, 2, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 3, 2, 1,
		2, 2, 2, 0, 0, 0, 0, 0, 
		1, 0, 1, 0, 3, 0, 2, 0,
		6, 0, 2, 0, 3, 1, 3, 3, 
		11, 5, 0, 1, 2, 2, 4, 5,
		0, 1, 2, 0, 3, 3, 1, 0, 
		0, 2, 1, 0, 2, 2, 0, 0, 
		3, 3, 2, 0, 0, 1, 1, 0, 
		2, 3, 10, 0, 1, 1, 3, 6, 
		0, 2, 10, 0, 0, 0, 0, 0, 
		1, 0, 1, 2, 3, 0, 1, 0, 
		2, 3, 0, 1, 0, 2, 3, 0,		 
		1, 2, 0, 3, 0, 1, 1, 2,
		0, 2, 4, 0, 1, 0, 0, 0, 
		2, 0, 2, 1, 2, 0, 3, 1,
		11, 2, 2, 0, 3, 0, 3, 0, 
		3, 2, 0, 1, 2, 0, 3, 3,
		0, 1, 4, 2, 0, 5, 0, 1,
		0, 1, 2, 0, 3, 0, 4, 2,
		2, 1, 0, 3, 0, 1, 0, 4,
		3, 3, 3, 1, 0, 2, 3, 0,  
		0, 1, 1, 2, 3, 0, 2, 0, 
		0, 1, 1, 2, 1, 2, 2, 3, 
		3, 3, 1, 2, 1, 2, 2, 3,
		3, 3, 1, 2, 1, 2, 2, 3,
		3, 3, 1, 2, 1, 2, 2, 3,
		3, 10, 0, 0, 0, 0, 0, 0, 
		10, 11, 12, 0, 0, 0, 0, 0,
		10, 11, 12, 0, 0, 0, 0, 0, 
		10, 11, 12, 0, 0, 4, 5, 6,
		10, 0, 0, 0, 0, 0, 0, 0,
		11, 0, 0, 0, 0, 0, 0, 0, 
		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0
	);
								 
	private static var _level2:Array = new Array(
		0, 0, 0, 
		1, 0, 2, 0, 3, 0, 2, 0, 
		1, 0, 3, 0, 2, 0, 1, 0, 
		1, 0, 2, 0, 1, 0, 4, 0, 
		5, 0, 6, 0, 5, 0, 5, 0, 
		11, 0, 6, 0, 5, 0, 4, 0, 
		5, 0, 2, 0, 6, 0, 1, 0,  
		1, 1, 2, 2, 3, 1, 2, 3, 
		2, 0, 4, 0, 6, 0, 4, 0, 							 
		7, 11, 0, 6, 1, 0, 2, 2, 
		1, 1, 6, 0, 3, 1, 2, 1, 
		2, 2, 3, 2, 2, 1, 2, 3,
		4, 2, 0, 0, 7, 3, 1, 2, 
		10, 9, 0, 7, 0, 8, 4, 3, 
		0, 6, 2, 0, 1, 0, 6, 2, 
		0, 1, 3, 3, 5, 0, 1, 0, 
		9, 0, 7, 3, 5, 1, 0, 3, 
		7, 0, 2, 0, 3, 0, 1, 0, 
		2, 0, 2, 0, 1, 0, 1, 0,
		10, 0, 9, 0, 9, 0, 3, 0, 
		0, 0, 0, 0, 2, 3, 2, 1,
		1, 2, 2, 0, 1, 1, 2, 2,
		1, 1, 1, 0, 7, 1, 2, 3,
		7, 3, 1, 2, 9, 2, 3, 1, 
		7, 3, 2, 1, 8, 2, 1, 2, 
		9, 3, 2, 11, 1, 3, 7, 7, 
		3, 2, 11, 3, 2, 3, 1, 1,
		3, 2, 3, 2, 3, 2, 1, 2, 
		3, 2, 3, 2, 3, 2, 1, 2,
		3, 2, 3, 2, 3, 2, 9, 0,
		2, 1, 2, 1, 2, 1, 2, 3, 
		3, 2, 11, 3, 1, 2, 3, 2, 
		1, 2, 2, 1, 2, 3, 2, 2,
		8, 11, 2, 2, 3, 3, 1, 0,
		1, 1, 2, 2, 3, 3, 2, 1,
		4, 0, 5, 0, 6, 0, 6, 0,
		6, 0, 5, 0, 4, 0, 6, 0,
		1, 1, 2, 2, 3, 3, 6, 0, 
		1, 0, 2, 0, 3, 0, 2, 0,
		4, 2, 2, 5, 3, 6, 0, 6, 
		1, 0, 2, 5, 1, 4, 3, 6,
		4, 3, 4, 0, 6, 2, 5, 0, 
		5, 3, 5, 0, 6, 0, 4, 0, 
		5, 3, 2, 3, 2, 1, 2, 2, 
		5, 3, 3, 2, 1, 2, 1, 2,						 
		4, 3, 3, 2, 2, 1, 3, 3,
		5, 3, 3, 1, 2, 2, 1, 2,  
		5, 1, 2, 2, 10, 2, 0, 1,
		6, 0, 1, 2, 3, 3, 2, 3, 
		4, 11, 2, 1, 1, 2, 3, 1,
		5, 1, 2, 2, 1, 0, 3, 3,
		9, 3, 1, 8, 2, 2, 3, 1,      
		8, 1, 2, 3, 7, 1, 3, 10,
		9, 0, 8, 2, 10, 8, 1, 2, 
		8, 2, 1, 7, 1, 3, 2, 3, 
		7, 0, 2, 3, 1, 2, 9, 0,
		0, 9, 2, 1, 2, 0, 8, 0, 
		9, 2, 1, 2, 3, 2, 1, 2, 
		0, 9, 11, 8, 2, 9, 0, 7, 
		0, 4, 5, 0, 6, 2, 0, 3, 
		1, 3, 2, 1, 2, 3, 2, 3, 
		2, 3, 1, 2, 3, 1, 1, 7, 
		1, 2, 2, 0, 8, 8, 1, 2, 
		9, 9, 2, 1, 0, 9, 9, 3, 
		7, 7, 1, 2, 0, 7, 7, 1, 10, // this measure has extra beat
		1, 2, 1, 3, 2, 1, 1, 0, 
		2, 1, 1, 3, 1, 2, 3, 7,
		11, 7, 0, 8, 0, 7, 1, 0,
		1, 2, 2, 1, 3, 2, 1, 8,
		2, 3, 2, 4, 2, 1, 3, 9, 
		3, 2, 2, 4, 3, 1, 3, 11, 
		2, 1, 1, 3, 2, 3, 3, 7, 
		4, 2, 1, 3, 2, 1, 3, 9, 
		6, 1, 1, 2, 3, 1, 3, 7, 
		4, 2, 2, 3, 5, 1, 2, 8, 
		5, 3, 2, 1, 5, 3, 2, 8,
		4, 3, 3, 5, 3, 2, 1, 7, 
		4, 3, 3, 6, 1, 4, 2, 10,
		4, 2, 5, 1, 1, 3, 7, 11, 
		1, 3, 2, 5, 1, 2, 3, 12, 
		7, 3, 3, 0, 1, 2, 3, 11, 
		7, 0, 0, 0, 0, 0, 0, 0, 
		0, 0, 0, 0, 0, 0, 0, 0	
	);								 
	
	static function get level():Array {
		return _level;		
	};
	
	static function get level2():Array {
		return _level2;
	};
};