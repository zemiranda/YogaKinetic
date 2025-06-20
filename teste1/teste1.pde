import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import java.util.ArrayList;

Capture video;
OpenCV opencv;

PImage backgroundImage;
boolean backgroundCaptured = false;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  video.start();
  
  opencv = new OpenCV(this, 640, 480);
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  image(video, 0, 0);

  if (backgroundCaptured) {
    // Convert current frame to grayscale with filter()
    PImage currentFrame = video.get();
    currentFrame.filter(GRAY);

    // Calculate absdiff between currentFrame and backgroundImage (both grayscale)
    PImage diff = createImage(width, height, ALPHA);
    diff.loadPixels();
    currentFrame.loadPixels();
    backgroundImage.loadPixels();
    for (int i = 0; i < diff.pixels.length; i++) {
      float b1 = brightness(currentFrame.pixels[i]);
      float b2 = brightness(backgroundImage.pixels[i]);
      float diffVal = abs(b1 - b2);
      diff.pixels[i] = color(diffVal);
    }
    diff.updatePixels();

    opencv.loadImage(diff);
    opencv.threshold(30);

    ArrayList<Contour> contours = opencv.findContours();

    noFill();
    strokeWeight(2);
    for (Contour contour : contours) {
      if (contour.area() > 5000) {
        stroke(0, 255, 0);
        contour.draw();

        Rectangle bbox = contour.getBoundingBox();
        stroke(255, 0, 0);
        rect(bbox.x, bbox.y, bbox.width, bbox.height);

        fill(255);
        noStroke();
        textSize(14);
        text("Area: " + nf(contour.area(), 0, 1), bbox.x, bbox.y - 10);
      }
    }
  }

  fill(255);
  textSize(16);
  text("Press 'b' to capture background (no one in frame)", 10, height - 10);
}

void keyPressed() {
  if (key == 'b') {
    // Capture background as grayscale using Processing's filter()
    PImage temp = video.get();
    temp.filter(GRAY);
    backgroundImage = temp;
    backgroundCaptured = true;
    println("Background captured!");
  }
}
