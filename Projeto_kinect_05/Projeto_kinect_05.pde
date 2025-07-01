int scene;

void setup() {
  fullScreen();
  background(0);
  
  setupKinect();
  setupInicio();  
  scene = 0; 
}

void draw() {
  drawKinect();
  
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
}
