import gab.opencv.*;
import processing.video.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;

Capture video;
OpenCV opencv;

PImage backgroundImage;
Mat backgroundMat;
Mat frameMat;
Mat diffMat;

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
    // Load current frame into OpenCV
    opencv.loadImage(video);
    frameMat = opencv.getColor();  // get current frame Mat
    
    // Compute absdiff between background and current frame
    diffMat = new Mat();
    Core.absdiff(backgroundMat, frameMat, diffMat);

    // Load the difference into opencv object
    opencv.setColor(diffMat);
    
    // Threshold the diff image
    opencv.threshold(30);
    
    // Find contours
    ArrayList<Contour> contours = opencv.findContours();
    
    noFill();
    strokeWeight(2);
    stroke(0, 255, 0);
    
    for (Contour contour : contours) {
      if (contour.area() > 5000) {
        contour.draw();
        // You can draw bounding boxes or other info here
      }
    }
  }

  fill(255);
  textSize(16);
  text("Press 'b' to capture background", 10, height - 10);
}

void keyPressed() {
  if (key == 'b') {
    // Capture background
    backgroundImage = video.get();
    opencv.loadImage(backgroundImage);
    backgroundMat = opencv.getColor();
    backgroundCaptured = true;
    println("Background captured!");
  }
}
