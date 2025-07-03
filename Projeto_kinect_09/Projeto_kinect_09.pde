int scene, nextScene;
boolean transitioning = false, fadingIn = true;
float fadeAlpha = 0, fadeSpeed = 5;
float fadeDurationFrames = 255.0 / fadeSpeed;
float totalTransitionFrames = fadeDurationFrames * 2;
float frameDurationMs, totalTransitionTimeMs;

void setup() {
  fullScreen();
  background(0);

  setupUI();
  setupKinect();
  setupVideos();
  setupSom();
  setupInicio();
  scene = 0;
  
  frameDurationMs = 1000.0 / frameRate;
  totalTransitionTimeMs = totalTransitionFrames * frameDurationMs;
}

void draw() {
  drawUI();
  drawKinect();
  drawVideos();
  
  if (scene == 0){
  drawInicio();
  }
  
  if (scene == 1){
  drawMenu();
  }
  
  if (scene == 2){
  drawJogo();
  }
  
  if (scene == 3){
  drawDefeat();
  }
  
  if (scene == 4){
  drawWin();
  }
  
  drawTransition();
}

void drawTransition() {
  if (transitioning) {
    fill(255, fadeAlpha);
    noStroke();
    rect(0, 0, width, height);

    if (fadingIn) {
      fadeAlpha += fadeSpeed;
      if (fadeAlpha >= 255) {
        fadeAlpha = 255;
        scene = nextScene;
        fadingIn = false;
      }
    } else {
      fadeAlpha -= fadeSpeed;
      if (fadeAlpha <= 0) {
        fadeAlpha = 0;
        transitioning = false;
        fadingIn = true;
      }
    }
  }
}

void transition(){
transitioning = true; 
fadingIn = true;
fadeAlpha = 0;
}
