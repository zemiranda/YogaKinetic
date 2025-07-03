PImage poseStart, start, buttons[], numbers[];

float scaleFactor, angle = 0, scaleAmplitude = 0.2, baseScale = 1.0, frequency = 0.05;

void setupUI(){
  //Inicio
  poseStart = new PImage(width, height, RGB);
  poseStart = loadImage("start/startPose.png");
  poseStart.resize(width, height);
  
  start = new PImage(300, 300, RGB);
  start = loadImage("start/start.png");
  
  //Menu
  buttons = new PImage[3];
  for (int i = 0; i < buttons.length; i = i + 1) {
    buttons[i]= loadImage("menu/difficulty/" + nf(i, 2) + ".png");
  }
  numbers = new PImage[5];
  for (int i = 0; i < numbers.length; i = i + 1) {
    numbers[i]= loadImage("menu/numbers/" + nf(i, 2) + ".png");
  }
  
  imageMode(CENTER);
}

void drawUI(){
  scaleFactor = baseScale + scaleAmplitude * sin(angle);
  angle += frequency;
}

void drawStartUI(){
  image(imgDifferences, width/2, height/2);
  
  fill(255, 0, 0);
  textSize(32);
  text("Overlap: " + nf(overlap, 1, 2) + "%", 0, 32);
  if (emPose == true) {fill(0, 255, 0); text("Correto", 0, 64); text("Time passed: " + elapsedTimeInPose / 1000 + " seconds", 0, 98);}
  else {fill(255, 0, 0); text("Errado", 0, 64);}
  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(scaleFactor);
  image(start, 0, 0);
  popMatrix();
}

void drawMenuUI(){
  image(kinectImage, width/2, height/2);
  
  imageMode(CORNER);
  for (int i = 0; i < buttons.length; i = i + 1) {
    image(buttons[i], i * width/buttons.length, height - (height/buttons.length), width/buttons.length, height/buttons.length);
  }
  noFill();
  stroke(255);
  rect(selectedDifficulty * width/buttons.length, height - (height/buttons.length), width/buttons.length, height/buttons.length);
  
  for (int i = 0; i < numbers.length; i = i + 1) {
    image(numbers[i], i * width/numbers.length, height - (height/buttons.length) - (height/numbers.length), width/numbers.length, height/numbers.length);
  }
  noFill();
  stroke(255);
  rect(selectedTime * width/numbers.length, height - (height/buttons.length) - (height/numbers.length), width/numbers.length, height/numbers.length);
  imageMode(CENTER);
}

void drawGameUI() {
 
  image(imgDifferences, width/2, height/2);

  fill(255, 0, 0);
  textSize(32);
  text("Overlap: " + nf(overlap, 1, 2) + "%", 0, 32);
  if (emPose == true) {fill(0, 255, 0); text("Correto", 0, 64); text("Time passed: " + elapsedTimeInPose / 1000 + " seconds", 0, 98);}
  else {fill(255, 0, 0); text("Errado", 0, 64); text("Time passed: " + elapsedTimeOutOfPose / 1000 + " seconds", 0, 98);}
  text(currentPose, 0, 130);
}

void drawDefeatUI(){
image(kinectImage, width/2, height/2);
  fill(255, 0, 0);
  textSize(32);
  text("Defeat", width/2, height/2);
}

void drawWinUI(){
image(kinectImage, width/2, height/2);
fill(0, 255, 0);
textSize(32);
text("Win", width/2, height/2);
}
