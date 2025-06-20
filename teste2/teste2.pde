import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import java.util.ArrayList;

Capture video;
OpenCV opencv;

PImage backgroundImage;
boolean backgroundCaptured = false;

// Define the pose zone (simple rectangle for now)
int zoneX, zoneY, zoneW, zoneH;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  video.start();
  
  opencv = new OpenCV(this, 640, 480);
  
  // Define a central rectangle zone
  zoneW = 200;
  zoneH = 500;
  zoneX = (width - zoneW) / 2;
  zoneY = (height - zoneH) / 2;
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  image(video, 0, 0);
  
  // Draw pose zone
  noFill();
  stroke(0, 0, 255);
  strokeWeight(2);
  rect(zoneX, zoneY, zoneW, zoneH);
  
  if (backgroundCaptured) {
    // Get current frame and convert to grayscale
    PImage current = video.get();
    current.filter(GRAY);
    
    // Difference with background
    PImage diff = createImage(width, height, RGB);
    diff.loadPixels();
    current.loadPixels();
    backgroundImage.loadPixels();
    for (int i = 0; i < diff.pixels.length; i++) {
      float b1 = brightness(current.pixels[i]);
      float b2 = brightness(backgroundImage.pixels[i]);
      float diffVal = abs(b1 - b2);
      diff.pixels[i] = color(diffVal);
    }
    diff.updatePixels();
    
    opencv.loadImage(diff);
    opencv.blur(5);
    opencv.threshold(40);
    opencv.erode();
    opencv.dilate();
    
    ArrayList<Contour> contours = opencv.findContours();
    
    // Combine all contours into one mask
    PGraphics maskLayer = createGraphics(width, height);
    maskLayer.beginDraw();
    maskLayer.background(0);
    maskLayer.fill(255);
    maskLayer.noStroke();
    
    float totalUserArea = 0;
    for (Contour c : contours) {
      if (c.area() > 1000) {
        maskLayer.beginShape();
        for (PVector pt : c.getPoints()) {
          maskLayer.vertex(pt.x, pt.y);
        }
        maskLayer.endShape(CLOSE);
        totalUserArea += c.area();
      }
    }
    maskLayer.endDraw();
    
    // Now compare how much of that mask is inside vs outside pose zone
    maskLayer.loadPixels();
    int inside = 0;
    int outside = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int idx = x + y * width;
        if (brightness(maskLayer.pixels[idx]) > 127) {
          if (x >= zoneX && x <= zoneX + zoneW && y >= zoneY && y <= zoneY + zoneH) {
            inside++;
          } else {
            outside++;
          }
        }
      }
    }
    
    float total = inside + outside;
    float insidePct = total > 0 ? inside / total * 100 : 0;
    float outsidePct = total > 0 ? outside / total * 100 : 0;
    
    // Show feedback
    fill(0, 150);
    noStroke();
    rect(0, 0, width, 60);
    fill(255);
    textSize(16);
    text("Inside Pose Zone: " + nf(insidePct, 0, 1) + "%", 10, 25);
    text("Outside: " + nf(outsidePct, 0, 1) + "%", 10, 45);
    
    if (insidePct > 70 && outsidePct < 30) {
      fill(0, 200, 0);
      text("✅ Pose OK!", width - 150, 35);
    } else {
      fill(255, 0, 0);
      text("❌ Adjust your pose", width - 200, 35);
    }
  }

  fill(255);
  textSize(14);
  text("Press 'b' to capture background", 10, height - 10);
}

void keyPressed() {
  if (key == 'b') {
    backgroundImage = video.get();
    backgroundImage.filter(GRAY);
    backgroundCaptured = true;
    println("Background captured.");
  }
}
