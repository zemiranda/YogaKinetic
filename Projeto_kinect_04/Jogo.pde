PImage imgDifferences, poseImg, selectedPoses[];
String folder, folders[] = {"easy", "medium", "hard"};
int numPosePixels, numKinectPixels, numWhitePixels, numRedPixels, currentTime, elapsedTimeOutOfPose, lastTimeOutOfPose, elapsedTimeInPose, lastTimeInPose, currentPose;
float dentroDaPose, foraDaPose;
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
  numRedPixels = 0;
  
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
    if (rKinect == 255 && gKinect == 0 && bKinect == 0) numKinectPixels++;

    float diffR = abs(rKinect - rPose);
    float diffG = abs(gKinect - gPose);
    float diffB = abs(bKinect - bPose);

    imgDifferences.pixels[i] = color(diffR, diffG, diffB);

    if (diffR == 255 && diffG == 255 && diffB == 255) numWhitePixels++;
    if (diffR == 255 && diffG == 0 && diffB == 0) numRedPixels++;
  }

  imgDifferences.updatePixels();

  dentroDaPose = numPosePixels == 0 ? 0 : 100 - (100.0 * numWhitePixels / numPosePixels);
  foraDaPose = numKinectPixels == 0 ? 0 : 100.0 * numRedPixels / numKinectPixels;
  
  if (dentroDaPose > 70 && foraDaPose < 70) emPose = true;
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
  
  if (elapsedTimeInPose / 1000 > 5 && currentPose < selectedPoses.length - 1) {
  elapsedTimeInPose = 0;
  currentPose++;
}
  if (elapsedTimeInPose / 1000 > 5 && currentPose >= selectedPoses.length - 1) scene = 1;
}

void drawUI() {
  image(imgDifferences, 0, 0, width, height);
  fill(255, 0, 0);
  textSize(32);
  text("Dentro da pose: " + nf(dentroDaPose, 1, 2) + "%", 0, 32);
  text("Fora da pose: " + nf(foraDaPose, 1, 2) + "%", 0, 64);
  if (emPose == true) {fill(0, 255, 0); text("Correto", 0, 98); text("Time passed: " + elapsedTimeInPose / 1000 + " seconds", 0, 130);}
  else {fill(255, 0, 0); text("Errado", 0, 98); text("Time passed: " + elapsedTimeOutOfPose / 1000 + " seconds", 0, 130);}
  text(currentPose, 0, 162);
}
