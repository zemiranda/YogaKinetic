int scene;

void setup() {
  fullScreen();
  background(0);
  
  setupKinect();
  setupInicio();  
  scene = 0; 
}

void draw() {
  if (scene == 0){
  drawInicio();
  }
  
  if (scene == 1){
  drawKinect();
  drawMenu();
  }
  
  if (scene == 2){
  drawKinect();
  drawJogo();
  }
  
  if (scene == 3){
  drawKinect();
  drawMenu();
  }
}
