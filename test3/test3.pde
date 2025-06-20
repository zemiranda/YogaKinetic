import gab.opencv.*;
import processing.video.*;
import java.util.*;

Capture video;
OpenCV opencv;

PImage backgroundImage;
boolean backgroundCaptured = false;

PGraphics poseMask; // forma da pose desejada

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  video.start();

  opencv = new OpenCV(this, 640, 480);

  // Desenhar pose desejada
  poseMask = createGraphics(width, height);
  drawTargetPose();
}

void drawTargetPose() {
  poseMask.beginDraw();
  poseMask.background(0);
  poseMask.fill(255);
  poseMask.noStroke();

  poseMask.beginShape();
  // Aumentado proporcionalmente
  poseMask.vertex(width/2 - 100, 80);   // ombro esq
  poseMask.vertex(width/2 - 60, 220);   // cintura esq
  poseMask.vertex(width/2 - 160, 460);  // pé esq
  poseMask.vertex(width/2 + 160, 460);  // pé dir
  poseMask.vertex(width/2 + 60, 220);   // cintura dir
  poseMask.vertex(width/2 + 100, 80);   // ombro dir
  poseMask.endShape(CLOSE);

  poseMask.endDraw();
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  image(video, 0, 0);

  // Mostra a pose alvo desenhada
  tint(0, 0, 255, 60);
  image(poseMask, 0, 0);
  noTint();

  if (backgroundCaptured) {
    PImage current = video.get();
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

    int inside = 0;
    int outside = 0;

    for (int i = 0; i < poseMask.pixels.length; i++) {
      boolean user = brightness(maskLayer.pixels[i]) > 127;
      boolean target = brightness(poseMask.pixels[i]) > 127;

      if (user && target) inside++;
      else if (user && !target) outside++;
    }

    float total = inside + outside;
    float insidePct = total > 0 ? inside / total * 100 : 0;
    float outsidePct = total > 0 ? outside / total * 100 : 0;

    fill(0, 150);
    noStroke();
    rect(0, 0, width, 60);
    fill(255);
    textSize(16);
    text("Dentro da pose: " + nf(insidePct, 0, 1) + "%", 10, 25);
    text("Fora da pose: " + nf(outsidePct, 0, 1) + "%", 10, 45);

    if (insidePct > 70 && outsidePct < 30) {
      fill(0, 200, 0);
      text("✅ Pose correta!", width - 180, 35);
    } else {
      fill(255, 0, 0);
      text("❌ Ajusta-te à pose", width - 200, 35);
    }

    // Debug visual
    image(diff, 0, height - 120, 160, 120);
    image(opencv.getOutput(), 160, height - 120, 160, 120);
  }

  fill(255);
  textSize(14);
  text("Pressiona 'b' para capturar o fundo", 10, height - 10);
}

void keyPressed() {
  if (key == 'b') {
    backgroundImage = video.get();
    backgroundImage.filter(GRAY);
    backgroundImage.filter(BLUR, 5);
    backgroundCaptured = true;
    println("Fundo capturado.");
  }
}
