// Nov 2013
// http://jiyu-kenkyu.org
// http://kow-luck.com
// Based on a work at http://www.zenbullets.com.
//
// This work is licensed under a Creative Commons 3.0 License.
// (Attribution - NonCommerical - ShareAlike)
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// 
// This basically means, you are free to use it as long as you:
// 1. give http://kow-luck.com a credit
// 2. don't use it for commercial gain
// 3. share anything you create with it in the same way I have
//
// If you want to use this work as free, or encourage me,
// please contact me via http://kow-luck.com/contact

//========================================
import processing.opengl.*;

int NUM = 6;
DNA[] dna = new DNA[NUM];

float eyeX, eyeY, eyeZ, eyeZnumerator, eyeXmov, eyeYmov, eyeZmov;

//========================================
void setup() {
  size(1280, 720, OPENGL);
  frameRate(30);
  colorMode(RGB);
  smooth();

  float coilLength  = width * 5;
  float coilWidth   = width/15;
  float coilDensity = 10;
  float rotX        = 1;
  for (int i = 0; i < NUM; i++) {
    float xPos        = random(-width, width);
    float yPos        = random(-height, height);
    float zPos        = random(-width, width);
    float coilAngleY  = random(-30, 30);
    float coilAngleZ  = random(-30, 30);
    coilWidth *=1.3;
    rotX *= 1.4;

    dna[i] = new DNA(xPos, yPos, zPos, coilAngleY, coilAngleZ, 
    coilLength, coilWidth, coilDensity, rotX);
  }
  background(255);

  eyeXmov = 3;
  eyeYmov = 6;
  eyeZmov = 2;
  eyeX = width/2;
  eyeY = height/2;
  eyeZnumerator = height/2;
}

//========================================
void draw() {
  background(0);
  cameraMove();
  translate(width/2, height/2);
  rotateY(radians(mouseX));
  rotateX(radians(mouseY));
  for (int i = 0; i < NUM; i++) {
    dna[i].display();
  }
  println(frameRate);
}

//========================================
void cameraMove() {
  camera(eyeX, eyeY, eyeZ, width/2, height/2, 0, 0, 1, 0);
  eyeX += eyeXmov;
  eyeY += eyeYmov;
  eyeZnumerator += eyeZmov;
  eyeZ = (eyeZnumerator)/tan(PI*60.0 / 360.0);
  if (eyeX < -width || eyeX > width) {
    eyeXmov *= -1;
  }
  if (eyeY < -height*3 ||eyeY >height*3) {
    eyeYmov *= -1;
  }
  if (eyeZnumerator < 6 || eyeZnumerator> width/1.5) {
    eyeZmov *=-1;
  }
}
//========================================
public class DNA {
  float xPos, yPos, zPos, coilAngleY, coilAngleZ;
  float coilLength;
  float coilWidth, coilDensity;
  float rotX;
  float angle, Y1, Z1, Y2, Z2;
  //========================================
  DNA(float _xPos, float _yPos, float _zPos, float _coilAngleY, float _coilAngleZ, 
  float _coilLength, float _coilWidth, float _coilDensity, float _rotX) {
    xPos        = _xPos;
    yPos        = _yPos;
    zPos        = _zPos;
    coilAngleY  = _coilAngleY;
    coilAngleZ  = _coilAngleZ;
    coilLength  = _coilLength;
    coilWidth   = _coilWidth;
    coilDensity = _coilDensity;
    rotX        = _rotX;
  }
  //========================================
  public void display() {
    angle = 0;
    pushMatrix();
    translate(xPos, yPos, zPos);
    rotateY(radians(coilAngleY));
    rotateZ(radians(coilAngleZ));

    this.rotation();

    this.drawMe();
  }
  //========================================
  private void drawMe() {
    for (float X = -coilLength/2; X < coilLength/2; X += coilDensity) {
      float rad = radians(angle);
      Y1 =   (sin(rad) * coilWidth); 
      Z1 =   (cos(rad) * coilWidth); 
      Y2 = - (sin(rad) * coilWidth); 
      Z2 = - (cos(rad) * coilWidth); 

      strokeWeight(2);
      stroke(255, 200);
      line(X, Y1, Z1, X, Y2, Z2);

      strokeWeight(20);
      stroke(50, 200);
      point(X, Y1, Z1);
      stroke(150, 200);
      point(X, Y2, Z2);

      angle += coilDensity;
    }
    popMatrix();
  }
  //========================================
  private void rotation() {
    rotateX(frameCount * rotX/100);
  }
}

