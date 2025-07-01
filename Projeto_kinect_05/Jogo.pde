PImage imgDifferences, poseImg, selectedPoses[];
String folder, folders[] = {"easy", "medium", "hard"};
int numPosePixels, numKinectPixels, numWhitePixels, currentTime, elapsedTimeOutOfPose, lastTimeOutOfPose, elapsedTimeInPose, lastTimeInPose, currentPose;
float overlap;
boolean emPose, previousEmPose;

void setupJogo() {
  emPose = false;
  previousEmPose = true;
  elapsedTimeOutOfPose = 0;
  lastTimeOutOfPose = 0;
  elapsedTimeInPose = 0;
  lastTimeInPose = 0;
  imgDifferences = createImage(width, height, RGB);
  
  selectedPoses = new PImage[selectedTime + 1];
  folder = folders[selectedDifficulty];
  for (int i = 0; i <= selectedTime; i++) {
    selectedPoses[i] = loadImage(folder + "/" + nf(i, 2) + ".png");
    selectedPoses[i].resize(width, height);
  }
  currentPose = 0;
}

void drawJogo() {
  calculateOverlap(); 
  timer(); 
  drawUI();
}

void calculateOverlap() {
  poseImg = selectedPoses[currentPose];
  poseImg.loadPixels();
  kinectImage.loadPixels();
  imgDifferences.loadPixels();

  numPosePixels = 0;
  numKinectPixels = 0;
  numWhitePixels = 0;
  
  for (int i = 0; i < poseImg.pixels.length; i++) {
    int poseColor = poseImg.pixels[i];
    int kinectColor = kinectImage.pixels[i];

    float rPose = red(poseColor);
    float gPose = green(poseColor);
    float bPose = blue(poseColor);

    float rKinect = red(kinectColor);
    float gKinect = green(kinectColor);
    float bKinect = blue(kinectColor);

    if (rPose == 255) numPosePixels++;
    if (rKinect == 255) numKinectPixels++;

    float diffR = abs(rKinect - rPose);
    float diffG = abs(gKinect - gPose);
    float diffB = abs(bKinect - bPose);

    imgDifferences.pixels[i] = color(diffR, diffG, diffB);

    if (diffR == 255 && diffG == 255 && diffB == 255) numWhitePixels++;
  }

  imgDifferences.updatePixels();

  overlap = 100.0 * numWhitePixels / (numPosePixels + numKinectPixels);
  
  if (overlap < 50) emPose = true;
  else emPose = false;
}

void timer() {
  currentTime = millis();

  if (emPose != previousEmPose) {
    if (emPose) {
      lastTimeInPose = currentTime;
    } else {
      lastTimeOutOfPose = currentTime;
      elapsedTimeInPose = 0; // reset when exiting pose
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
  
  if (elapsedTimeOutOfPose / 1000 > 15) {setupWin(); scene = 3;}
  
  if (elapsedTimeInPose / 1000 > 5 && currentPose < selectedPoses.length - 1) {
  elapsedTimeInPose = 0;
  elapsedTimeOutOfPose = 0;
  currentPose++;
}
  if (elapsedTimeInPose / 1000 > 5 && currentPose >= selectedPoses.length - 1) {setupDefeat(); scene = 4;}
}

void drawUI() {
  image(imgDifferences, 0, 0, width, height);
  fill(255, 0, 0);
  textSize(32);
  text("Overlap: " + nf(overlap, 1, 2) + "%", 0, 32);
  if (emPose == true) {fill(0, 255, 0); text("Correto", 0, 64); text("Time passed: " + elapsedTimeInPose / 1000 + " seconds", 0, 98);}
  else {fill(255, 0, 0); text("Errado", 0, 64); text("Time passed: " + elapsedTimeOutOfPose / 1000 + " seconds", 0, 98);}
  text(currentPose, 0, 130);
}
