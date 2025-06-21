import gab.opencv.*;
import processing.video.*;
import java.util.*;

Capture video;
OpenCV opencv;

PImage backgroundImage;
boolean backgroundCaptured = false;
//set da pose inicial
int pose = 1;
int mirror = 1;
PGraphics poseMask; // forma da pose desejada

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  video.start();

  opencv = new OpenCV(this, 640, 480);
  
  // Desenhar pose desejada
  poseMask = createGraphics(width, height);
  drawTargetPose(pose);
}

void drawTargetPose(int n) {
  
  poseMask.beginDraw();
  poseMask.background(0);
  poseMask.fill(255);
  poseMask.noStroke();
  
  if(n == 0){
    
    poseMask.beginShape();
    // Aumentado proporcionalmente
    poseMask.vertex(width/2 - 100, 80);   // ombro esq
    poseMask.vertex(width/2 - 60, 220);   // cintura esq
    poseMask.vertex(width/2 - 160, 460);  // pé esq
    poseMask.vertex(width/2 + 160, 460);  // pé dir
    poseMask.vertex(width/2 + 60, 220);   // cintura dir
    poseMask.vertex(width/2 + 100, 80);   // ombro dir
    poseMask.endShape(CLOSE);
  }
  if(n == 1){
    poseMask.beginShape();
   // Cabeça — mais próxima e maior
poseMask.rect(width/2 + 80, 200, 60, 60);

// Tronco — mais espesso e mais largo
poseMask.rect(width/2 - 140, 230, 280, 80);

// Braço frontal — mais grosso e alto
poseMask.rect(width/2 - 140, 300, 40, 160);

// Perna frontal — idem
poseMask.rect(width/2 + 60, 300, 40, 160);
    poseMask.endShape(CLOSE);
   
  }

  poseMask.endDraw();
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  //Mostra a camara
 
  if(mirror == 1){
    pushMatrix();
    translate(width, 0);  // Move origin to the right edge
    scale(-1, 1);        // Flip horizontally
    image(video, 0, 0);  // Draw video flipped
    popMatrix();
  } else image(video, 0, 0); 

  // Mostra a pose alvo desenhada
  tint(0, 0, 255, 60);
  image(poseMask, 0, 0);
  noTint();

  if (backgroundCaptured) {
    PImage current = video.get();
    if(mirror == 1) current = flipHorizontal(current);
    current.filter(GRAY);

    // Subtração de fundo
    PImage diff = createImage(width, height, RGB);
    diff.loadPixels();
    current.loadPixels();
    backgroundImage.loadPixels();

    for (int i = 0; i < diff.pixels.length; i++) {
      float b1 = brightness(current.pixels[i]);
      float b2 = brightness(backgroundImage.pixels[i]);
      float d = abs(b1 - b2);
      diff.pixels[i] = color(d);
    }
    diff.updatePixels();

    opencv.loadImage(diff);
    opencv.blur(15);
    opencv.threshold(50);
    opencv.erode();
    opencv.dilate();
    opencv.erode();

    ArrayList<Contour> contours = opencv.findContours();

    // Máscara da pessoa
    PGraphics maskLayer = createGraphics(width, height);
    maskLayer.beginDraw();
    maskLayer.background(0);
    maskLayer.fill(255);
    maskLayer.noStroke();

    Contour biggest = null;
    float maxArea = 0;
    for (Contour c : contours) {
      if (c.area() > 5000 && c.area() > maxArea) {
        maxArea = c.area();
        biggest = c;
      }
    }

    if (biggest != null) {
      maskLayer.beginShape();
      for (PVector pt : biggest.getPoints()) {
        maskLayer.vertex(pt.x, pt.y);
      }
      maskLayer.endShape(CLOSE);
    }

    maskLayer.endDraw();

    // Verificação de correspondência com a pose alvo
    poseMask.loadPixels();
    maskLayer.loadPixels();

    
    int inside = 0;    // user pixels inside pose
    int outside = 0;   // user pixels outside pose
    int poseArea = 0;          // total pose mask pixels
    int coveredPoseArea = 0;   // pose pixels covered by user
    
    for (int i = 0; i < poseMask.pixels.length; i++) {
      boolean userPixel = brightness(maskLayer.pixels[i]) > 127;
      boolean posePixel = brightness(poseMask.pixels[i]) > 127;
    
      if (posePixel) {
        poseArea++;
        if (userPixel) {
          coveredPoseArea++;
        }
      }
    
      if (userPixel && posePixel) inside++;
      else if (userPixel && !posePixel) outside++;
    }
    
    float totalUserPixels = inside + outside;
    float insidePct = totalUserPixels > 0 ? inside / (float)totalUserPixels * 100 : 0;
    float outsidePct = totalUserPixels > 0 ? outside / (float)totalUserPixels * 100 : 0;
    
    float poseCoveragePct = poseArea > 0 ? coveredPoseArea / (float)poseArea * 100 : 0;
    
        // Show the percentages
    fill(255);
    textSize(16);
    text("Dentro da pose: " + nf(insidePct, 0, 1) + "%", 10, 25);
    text("Fora da pose: " + nf(outsidePct, 0, 1) + "%", 10, 45);
    text("Cobertura da pose: " + nf(poseCoveragePct, 0, 1) + "%", 10, 65);

    
    println("Pose coverage: " + nf(poseCoveragePct, 0, 1) + "%");
    
    if (insidePct > 70 && outsidePct < 30 && poseCoveragePct >= 60) {
      fill(0, 200, 0);
      text("✅ Pose correta!", width - 180, 35);
    } else {
      fill(255, 0, 0);
      text("❌ Ajusta-te à pose", width - 200, 35);
    }

    // Debug visual
    //bimage(diff, 0, height - 120, 160, 120);
    image(opencv.getOutput(), 160, height - 120, 160, 120);
  }

  fill(255);
  textSize(14);
  text("Pressiona 'b' para capturar o fundo", 10, height - 10);
}

void keyPressed() {
  if (key == 'b') {
    backgroundImage = video.get();
    if(mirror == 1) backgroundImage = flipHorizontal(backgroundImage);  
    backgroundImage.filter(GRAY);
    backgroundImage.filter(BLUR, 7);
    backgroundCaptured = true;
    println("Fundo capturado.");
  }
  //com a seta -> e <- podemos mudar as posicoes 
  if (keyCode == RIGHT) {
    if (pose >= 1) pose = 0;
    else pose += 1;

    drawTargetPose(pose);
    println("Mudou para pose: " + pose);
  }
  if (keyCode == LEFT) {
    if (pose <= 0) pose = 1;
    else pose -= 1;

    drawTargetPose(pose);
    println("Mudou para pose: " + pose);
  }
  if (key == ' '){
    if(mirror == 1) mirror = 0;
    else mirror = 1;
  }
}

PImage flipHorizontal(PImage img) {
  PImage flipped = createImage(img.width, img.height, img.format);
  img.loadPixels();
  flipped.loadPixels();

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      int flippedX = img.width - 1 - x;
      flipped.pixels[y * img.width + x] = img.pixels[y * img.width + flippedX];
    }
  }

  flipped.updatePixels();
  return flipped;
}
