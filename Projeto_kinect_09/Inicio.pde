void setupInicio(){
  resetPose();
  menuMusic();
}

void drawInicio(){
  timerStart();
  calculateOverlap(); 
  drawStartUI(); 
}

void timerStart(){
  if (transitioning) return;
  
  currentTime = millis(); //<>//

  // Detect pose transitions
  if (emPose != previousEmPose) {
    if (!emPose) {
      // Just exited pose → reset timer
      elapsedTimeInPose = 0;
    } else {
      // Just entered pose → initialize lastTimeInPose
      lastTimeInPose = currentTime;
    }
    previousEmPose = emPose;
  }

  // Only accumulate if player is in pose
  if (emPose) {
    elapsedTimeInPose += currentTime - lastTimeInPose;
    lastTimeInPose = currentTime;
  }
    
  if (elapsedTimeInPose / 1000 > 3) {playStart(); setupMenu(); transition(); nextScene = 1;}
}
