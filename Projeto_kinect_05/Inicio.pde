PImage imgDifferencesStart, poseStart, start;
int numPosePixelsStart, numKinectPixelsStart, numWhitePixelsStart, currentTimeStart, elapsedTimeInPoseStart, lastTimeInPoseStart;
float overlapStart;
boolean emPoseStart, previousEmPoseStart;

void setupInicio(){
  emPoseStart = false;
  previousEmPoseStart = true;
  elapsedTimeInPoseStart = 0;
  lastTimeInPoseStart = 0;
  imgDifferencesStart = createImage(width, height, RGB); 
  
  start = new PImage(300, 300, RGB);
  poseStart = new PImage(width, height, RGB);
  start = loadImage("start.png");
  poseStart = loadImage("startPose.png");
  poseStart.resize(width, height);
}

void drawInicio(){
  calculateOverlapStart(); 
  timerStart(); 
  drawUIStart(); 
}

void calculateOverlapStart(){
  poseStart.loadPixels();
  kinectImage.loadPixels();
  imgDifferencesStart.loadPixels();

  numPosePixelsStart = 0;
  numKinectPixelsStart = 0;
  numWhitePixelsStart = 0;
  
  for (int i = 0; i < poseStart.pixels.length; i++) {
    int poseColorStart = poseStart.pixels[i];
    int kinectColorStart = kinectImage.pixels[i];

    float rPoseStart = red(poseColorStart);
    float gPoseStart = green(poseColorStart);
    float bPoseStart = blue(poseColorStart);

    float rKinectStart = red(kinectColorStart);
    float gKinectStart = green(kinectColorStart);
    float bKinectStart = blue(kinectColorStart);

    if (rPoseStart == 255) numPosePixelsStart++;
    if (rKinectStart == 255) numKinectPixelsStart++;

    float diffRStart = abs(rKinectStart - rPoseStart);
    float diffGStart = abs(gKinectStart - gPoseStart);
    float diffBStart = abs(bKinectStart - bPoseStart);

    imgDifferencesStart.pixels[i] = color(diffRStart, diffGStart, diffBStart);

    if (diffRStart == 255 && diffGStart == 255 && diffBStart == 255) numWhitePixelsStart++;
  }

  imgDifferencesStart.updatePixels();

  overlapStart = 100.0 * numWhitePixelsStart / (numPosePixelsStart + numKinectPixelsStart);
  
  if (overlapStart < 50) emPoseStart = true;
  else emPoseStart = false;
}

void timerStart(){
  currentTimeStart = millis(); //<>//

  if (emPoseStart != previousEmPoseStart) {
    if (emPoseStart) {
      lastTimeInPoseStart = currentTimeStart;
    } else {
      elapsedTimeInPoseStart = 0; // reset when exiting pose
    }
    previousEmPoseStart = emPoseStart;
  }

  if (emPoseStart) {
    elapsedTimeInPoseStart += currentTimeStart - lastTimeInPoseStart;
    lastTimeInPoseStart = currentTimeStart;
  }
    
  if (elapsedTimeInPoseStart / 1000 > 5) {setupMenu(); scene = 1;}
}

void drawUIStart(){
  image(imgDifferencesStart, 0, 0, width, height);
  fill(255, 0, 0);
  textSize(32);
  text("Overlap: " + nf(overlapStart, 1, 2) + "%", 0, 32);
  if (emPoseStart == true) {fill(0, 255, 0); text("Correto", 0, 64); text("Time passed: " + elapsedTimeInPoseStart / 1000 + " seconds", 0, 98);}
  else {fill(255, 0, 0); text("Errado", 0, 64);}
  
  image(start, (width/2)-150, (height/2)-150);
}
