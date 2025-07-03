PImage natureFrames[], glitchFrames[];
int numNatureFrames = 50, currentNatureFrame = 0, natureDirection = 1;
int numGlitchFrames = 10, currentGlitchFrame = 0, glitchDirection = 1;
int frameSlower = 0;

void setupVideos() {
  natureFrames = loadFrames("video/nature/ezgif-frame-", numNatureFrames);
  glitchFrames = loadFrames("video/glitch/ezgif-frame-", numGlitchFrames);
}

PImage[] loadFrames(String pathPrefix, int frameCount) {
  PImage[] frames = new PImage[frameCount];
  for (int i = 0; i < frameCount; i++) {
    PImage img = loadImage(pathPrefix + nf(i + 1, 3) + ".png");
    img.resize(width, height);
    frames[i] = img;
  }
  return frames;
}

void drawVideos() {
   if (!transitioning && ++frameSlower % 2 != 0) return;
  
  image(natureFrames[currentNatureFrame], width/2, height/2);
  currentNatureFrame += natureDirection;
  if (currentNatureFrame == numNatureFrames - 1 || currentNatureFrame == 0) natureDirection *= -1;
  
  if(scene == 2){ 
  if(emPose == false){
  tint(255,  17 * (elapsedTimeOutOfPose / 1000));
  image(glitchFrames[currentGlitchFrame], width/2, height/2);
  currentGlitchFrame += glitchDirection;
  if (currentGlitchFrame == numGlitchFrames - 1 || currentGlitchFrame == 0) glitchDirection *= -1; 
  tint(255, 255);
  }
  }
  
  if(scene == 3){
  image(glitchFrames[currentGlitchFrame], width/2, height/2); 
  currentGlitchFrame += glitchDirection;
  if (currentGlitchFrame == numGlitchFrames - 1 || currentGlitchFrame == 0) glitchDirection *= -1;
  }
}
