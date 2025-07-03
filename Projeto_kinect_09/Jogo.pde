PImage selectedPoses[];
String folder, folders[] = {"easy", "medium", "hard"};
int currentPose;

void setupJogo() {
  resetPose();
  gameMusic();
  
  selectedPoses = new PImage[selectedTime + 1];
  folder = folders[selectedDifficulty];
  for (int i = 0; i <= selectedTime; i++) {
    selectedPoses[i] = loadImage("soloposes/" + folder + "/" + nf(i, 2) + ".png");
    selectedPoses[i].resize(width, height);
  }
  currentPose = 0;
}

void drawJogo() {
  timer();
  calculateOverlap(); 
  noiseVolume();
  drawGameUI();
}

void timer() { 
  currentTime = millis() - int(totalTransitionTimeMs);
  
  if (emPose != previousEmPose) {
    if (emPose) {
      lastTimeInPose = currentTime;
    } else {
      lastTimeOutOfPose = currentTime;
      elapsedTimeInPose = 0;
    }
    previousEmPose = emPose;
  }

  if (emPose) {
    elapsedTimeInPose += currentTime - lastTimeInPose;
    lastTimeInPose = currentTime;
  } else {
    elapsedTimeOutOfPose += currentTime - lastTimeOutOfPose;
    lastTimeOutOfPose = currentTime;
  }
  
  if (elapsedTimeOutOfPose / 1000 > 15) {playFail(); setupDefeat(); scene = 3;}
  
  if (elapsedTimeInPose / 1000 > 5 && currentPose < selectedPoses.length - 1) {
  resetPose();
  playPass();
  currentPose++;
}
  if (elapsedTimeInPose / 1000 > 5 && currentPose >= selectedPoses.length - 1) {playPass(); setupWin(); scene = 4;}
}
