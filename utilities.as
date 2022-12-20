/*
 * Class of Flash and Actionscript 2-related utilities, reusable for content outside of this game. 
*/

class utilities {	
	/*
	 * Delete's a Movie Clip's onEnterFrame function, and deletes the movieclip from the program.
	 * @param {MovieClip} mc The Movie Clip to manipulate.
	 * @param {Boolean} [onComplete] Optional parameter to execute this function only when the Movie Clip's animation has completed.
	*/
	public static function deleteEnterFrameAndMC(mc, onComplete):Void {
		if ((onComplete && (mc._currentframe == mc._totalframes)) || (!onComplete)){
			delete mc.onEnterFrame;
			removeMovieClip(mc);
		};
	};
	
	/*
	 * A frame is given for the program to go to. In addition, a Movie Clip is given to serve as an animated screen transition 
	   (i.e. fade, screen wipe). At a specified frame in the transition animation, the program transitions to the "go to" frame, 
	   enabling a smooth transition. An optional function can also be provided to execute during the "blackout" portion of the transition.
	 * @param {Number|String} frameToGoTo  A number or string representing the destination frame.
	 * @param {MovieClip} transitionMC The MovieClip containing the transition animation.
	 * @param {Number|String} transitionFrame A number or string representing the "blackout" portion of the screen transition.
	 * @param {Function} [functionDuringTransition] An optional function to execute during the "blackout" portion of the transition.
	*/
	public static function goToAfterTransition(frameToGoTo, transitionMC, transitionFrame, functionDuringTransition):Void {
		if (transitionMC._currentframe == transitionFrame){	
			if (functionDuringTransition){
				functionDuringTransition();
			};			
			_root.gotoAndStop(frameToGoTo);	
		} else if (transitionMC._currentframe == transitionMC._totalframes){
			removeMovieClip(_root['swipeTransitionInst']);
			deleteEnterFrameAndMC(transitionMC);
		};
	};
	
	/*
	 * Sets a target MovieClip to have the same x and y position as another MovieClip.
	 * @param {Movie Clip} targetMC the Movie Clip that will have its coordinates set to sourceMC.
	 * @param {Movie Clip} sourceMC the Movie Clip that will provide the coordinate values for targetMC.
	*/
	public static function setEquivalentPosition(targetMC, sourceMC):Void {
		targetMC._x = sourceMC._x;
		targetMC._y = sourceMC._y;
	};	

	/*
	 * For a Movie Clip, randomly selects a frame to start the animation on. Typically used for looping animations such as flames or smoke.
	 * @param {Movie Clip} The Movie Clip that will have its start frame randomized.
	 */ 
	public static function randomizeMCStartFrame(mc):Void{
		var offset:Number = Math.floor((Math.random() * mc._totalframes) + 1);
		mc._gotoAndPlay(offset);
	};
};