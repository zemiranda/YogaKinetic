int scene;

void setup() {
  fullScreen();
  background(0);

  setupKinect();
  setupVideos();
  setupSom();
  setupInicio();
  scene = 0;
}

void draw() {  
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
  noiseVolume();
  }
  
  if (scene == 3){
  drawDefeat();
  }
  
  if (scene == 4){
  drawWin();
  }
}
