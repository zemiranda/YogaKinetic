import kinect4WinSDK.Kinect;
Kinect kinect;
PImage kinectBin;
int resolutionW = 1920, resolutionH = 1080;

void setupKinect() {
  kinect = new Kinect(this);
  kinectBin = new PImage(resolutionW, resolutionH, ARGB);
}

void drawKinect() {
  kinectBin.copy(kinect.GetMask(), 0, 0, width, resolutionH, 0, 0, width, resolutionH);
  kinectBin.loadPixels();

  color c;
  float alpha;

  // Percorrer todos os pixels da PImage kinectBin
  for ( int index = 0; index < kinectBin.pixels.length; index = index + 1) {
    // Vai buscar a cor do pixel
    c = kinectBin.pixels[index];
    // Vai buscar o valor alpha da cor do pixel
    alpha = alpha(c);
    // Se o valor da intensidad de alpha for igual a 0,
    // então o pixel pretence ao fundo
    if (alpha == 0) {
      // Coloca a cor preta no pixel
      kinectBin.pixels[index] = color(0);
    } else { // Caso contrário, o pixel pertence ao um corpo
      // Coloca a cor branca no pixel
      kinectBin.pixels[index] = color(255);
    }
  }
}
