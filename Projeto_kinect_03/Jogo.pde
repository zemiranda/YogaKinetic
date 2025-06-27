PImage imgDifferences, selectedPoses[];
float overlap;

void setupJogo(){
  imgDifferences = new PImage(resolutionW, resolutionH, RGB);
  selectedPoses = new PImage[selectedTime+1];
  if (selectedDifficulty == 0)
  {
  for (int i = 0; i < selectedTime+1; i = i + 1) {
    selectedPoses[i]= loadImage("easy/" + nf(i, 2) + ".png");
  }
  }
  if (selectedDifficulty == 1)
  {
  for (int i = 0; i < selectedTime+1; i = i + 1) {
    selectedPoses[i]= loadImage("medium/" + nf(i, 2) + ".png");
  }
  }
  if (selectedDifficulty == 2)
  {
  for (int i = 0; i < selectedTime+1; i = i + 1) {
    selectedPoses[i]= loadImage("hard/" + nf(i, 2) + ".png");
  }
  }
  for (int i = 0; i < selectedTime+1; i = i + 1) {
    selectedPoses[i].resize(resolutionW, resolutionH);
  }
}

void drawJogo(){
  createImgDifferences();
  overlap();
  image(imgDifferences, 0,0, width, height);
  fill(255,0,0);      // Set text color (white)
  textSize(32);   // Set text size
  text("Overlap: " + nf(overlap, 1, 2) + "%", 960, 540);
}

void createImgDifferences() {
  color cPrevious, cActual;
  float rPrevious, gPrevious, bPrevious, rActual, gActual, bActual;

  // Para aceder as cores dos pixels das PImages imgActual e imgPrevious
  kinectBin.loadPixels();
  
  
  selectedPoses[0].loadPixels();

  for ( int index = 0; index < kinectBin.pixels.length; index = index + 1) {
    cPrevious =  selectedPoses[0].pixels[index];
    rPrevious = red(cPrevious);
    gPrevious = green(cPrevious);
    bPrevious = blue(cPrevious);

    cActual = kinectBin.pixels[index];
    rActual = red(cActual);
    gActual = green(cActual);
    bActual = blue(cActual);

    imgDifferences.pixels[index] = color( abs(rActual-rPrevious), abs(gActual-gPrevious), abs(bActual-bPrevious));
  }

  // Aplicar as alterações que foram realizadas na Array pixels da PImage imgDiferrences na imagem
  imgDifferences.updatePixels();
}

void overlap() {

  int numWhitePixels = 0;
  int numTotalPixels = kinectBin.pixels.length;

  // Para aceder as cores dos pixels da PImage imgDifferences
  imgDifferences.loadPixels();

  color c;

  for ( int index = 0; index < imgDifferences.pixels.length; index = index + 1) {

    c = imgDifferences.pixels[index];

    // Se a cor do pixel for branca
    if (red(c) == 255) {
      // Conta o pixel branco
      numWhitePixels = numWhitePixels + 1;
    }
  }

  overlap = 100.0 * numWhitePixels / numTotalPixels;
}
