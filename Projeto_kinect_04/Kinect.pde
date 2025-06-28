import kinect4WinSDK.Kinect;
Kinect kinect;
PImage kinectImage;
float alpha;

void setupKinect() {
  kinect = new Kinect(this);
  kinectImage = new PImage(width, height, ARGB);
}

void drawKinect() {
  kinectImage.copy(kinect.GetMask(), 0, 0, width, height, 0, 0, width, height);
  kinectImage.loadPixels();

  // Percorrer todos os pixels da PImage kinectImage
  for (int i = 0; i < kinectImage.pixels.length; i++) {
    // Vai buscar o valor alpha da cor do pixel
    int pix = kinectImage.pixels[i];
    // Se o valor da intensidad de alpha for igual a 0, então o pixel pretence ao fundo
    if ((pix >>> 24) == 0) {
      // Coloca a cor preta no pixel
      kinectImage.pixels[i] = color(0);
    } else { // Caso contrário, o pixel pertence ao um corpo
      // Coloca a cor vermelha no pixel
      kinectImage.pixels[i] = color(255,0,0);
    }
  }
  
  kinectImage.updatePixels();
}
