import kinect4WinSDK.Kinect;
Kinect kinect;
PImage kinectImage, poseImg, imgDifferences;
int pix, poseColor, kinectColor, numPosePixels, numKinectPixels, numWhitePixels, currentTime, elapsedTimeInPose, lastTimeInPose, elapsedTimeOutOfPose, lastTimeOutOfPose;
float alpha, rPose, gPose, bPose, rKinect, gKinect, bKinect, diffR, diffG, diffB, overlap;
boolean emPose, previousEmPose;

void setupKinect() {
  kinect = new Kinect(this);
  kinectImage = new PImage(width, height, ARGB);  
  imgDifferences = createImage(width, height, ARGB);
}

void drawKinect() {
  kinectImage.copy(kinect.GetMask(), 0, 0, width, height, 0, 0, width, height);
  kinectImage.loadPixels();

  // Percorrer todos os pixels da PImage kinectImage
  for (int i = 0; i < kinectImage.pixels.length; i++) {
    // Vai buscar o valor alpha da cor do pixel
    pix = kinectImage.pixels[i];
    // Se o valor da intensidad de alpha for igual a 0, então o pixel pretence ao fundo
    if ((pix >>> 24) == 0) {
      // Coloca a cor preta no pixel
      kinectImage.pixels[i] = color(0, 0, 0, 0);
    } else { // Caso contrário, o pixel pertence ao um corpo
      // Coloca a cor branca no pixel
      kinectImage.pixels[i] = color(255);
    }
  }
  
  kinectImage.updatePixels();
}

void resetPose(){
  emPose = false;
  previousEmPose = false;
  elapsedTimeInPose = 0;
  elapsedTimeOutOfPose = 0;
  lastTimeInPose = millis();
  lastTimeOutOfPose = millis();
}

void calculateOverlap() {
  if(scene == 0) {poseImg = poseStart;}
  if(scene == 2){poseImg = selectedPoses[currentPose];}
  poseImg.loadPixels();
  kinectImage.loadPixels();
  imgDifferences.loadPixels();

  numPosePixels = 0;
  numKinectPixels = 0;
  numWhitePixels = 0;
  
  for (int i = 0; i < poseImg.pixels.length; i++) {
    poseColor = poseImg.pixels[i];
    kinectColor = kinectImage.pixels[i];

    // If poseImg pixel is not black, set it to red
  if (poseColor != color(0, 0, 0, 0)) {
    poseImg.pixels[i] = color(255, 255, 255, 255);
  }

  // If kinectImage pixel is not black, set it to red
  if (kinectColor != color(0, 0, 0, 0)) {
    kinectImage.pixels[i] = color(255, 255, 255, 255);
  }


    rPose = red(poseColor);
    gPose = green(poseColor);
    bPose = blue(poseColor);

    rKinect = red(kinectColor);
    gKinect = green(kinectColor);
    bKinect = blue(kinectColor);

    if (rPose == 255) numPosePixels++;
    if (rKinect == 255) numKinectPixels++;

    diffR = abs(rKinect - rPose);
    diffG = abs(gKinect - gPose);
    diffB = abs(bKinect - bPose);

    if (diffR == 0 && diffG == 0 && diffB == 0) {
  imgDifferences.pixels[i] = color(0, 0, 0, 0);
} else {
  imgDifferences.pixels[i] = color(diffR, diffG, diffB, 255);
  numWhitePixels++;
}

    //if (diffR == 255 && diffG == 255 && diffB == 255) numWhitePixels++;
  }

  poseImg.updatePixels();
  kinectImage.updatePixels();
  imgDifferences.updatePixels();
  imgDifferences.updatePixels();

  overlap = 100.0 * numWhitePixels / (numPosePixels + numKinectPixels);
  
  if (overlap < 50) emPose = true;
  else emPose = false;
}
