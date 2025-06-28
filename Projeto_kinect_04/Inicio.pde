PImage start;

void setupInicio(){
  start = new PImage(300, 300, ARGB);
  start = loadImage("start.png");
}

void drawInicio(){
  image(start, (width/2)-150, (height/2)-150);
}
