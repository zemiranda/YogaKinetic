PImage buttons[], numbers[];
int selectedDifficulty, selectedTime;

void setupMenu(){
  selectedDifficulty = 0;
  selectedTime = 0;
  
  buttons = new PImage[3];
  for (int i = 0; i < buttons.length; i = i + 1) {
    buttons[i]= loadImage("menu/difficulty/" + nf(i, 2) + ".png");
  }
  numbers = new PImage[5];
  for (int i = 0; i < numbers.length; i = i + 1) {
    numbers[i]= loadImage("menu/numbers/" + nf(i, 2) + ".png");
  }
}

void drawMenu(){
  image(kinectImage, 0, 0, width, height);
  
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
}
