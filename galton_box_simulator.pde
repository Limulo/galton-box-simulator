/*
* This is a sketch to simulate the so called
* "Beam Machine" by sir. Galton Box. More info
* how its working prinpiple here 
* (https://en.wikipedia.org/wiki/Bean_machine)
*
* The sketch has been constructed with a procedural 
* architecture in mind; what does it mean is that 
* you can modify the geometrical structure of the 
* Bean Machine with ease by simply changing some global 
* variables, and the code will adjust itself automatically
*/

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// this java util packet is here to make us
// capable of using ArrayLists that will be
// internally modified inside loops 
// (see the last for loop)
import java.util.concurrent.*; 

// dynamic elements
CopyOnWriteArrayList<Ball> balls;

// static elements
Box2DProcessing box2d;   // helper class

Pin[]      pins;
Border[]   borders;
Slide[]    slides;
Bottom     bottom;
int[]      cilCounter;

int n = 12;         // rows of pins
int k = 10;         // number of cylinders (number of separators = k - 1 ( + side walls)
int np;             // number of pins

int maxBalls = 350; // max number of balls simultaneously calculated
float radius = 3;   // balls radius
float c = 8.0;      // wall thickness
float A = 30.0;     // rows distanpe
float wopening = 3*c;

float hcyl = 60.0;  // cylinders heigh
float wcyl;
float lowMargin = 60;
float Hlowest;
float slideLowBorder;

// FONT
PFont f;

// ///////////////////////////////////////////////////////////////// SETUP
void setup() {
  size(400, 700);
  frameRate(60);
  smooth();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  // *** Utils  **************************************************
  Hlowest = height - lowMargin;
  wcyl = (width - c * k) / (float)k;
  np = (n/2)*(2*k - 1) + (n % 2) * k;
  slideLowBorder = A*(2+n) - Hlowest + hcyl;
  cilCounter = new int[k];
  for (int i = 0; i < k; i++) {
    cilCounter[i] = 0;
  }
  
  // *** Balls ***************************************************
  balls = new CopyOnWriteArrayList<Ball>(); 
  
  // *** Bottom **************************************************
  bottom = new Bottom(new Vec2(width/2, Hlowest+c/2 + 3), width, c); 
  
  // *** Slides **************************************************
  slides = new Slide[2];
  Vec2[] vertices = new Vec2[4];
  // vertex expressed in pixels, relative to the center of the figure
  // ina clockwise order
  vertices[0] = new Vec2( -c/2, 0);
  vertices[1] = new Vec2( -c/2, slideLowBorder);
  vertices[2] = new Vec2( width/2 - wopening/2, -c);
  vertices[3] = new Vec2( width/2 - wopening/2,  0);
  slides[0] = new Slide(vertices, 4, new Vec2(0, -slideLowBorder), 0);
  
  vertices[0] = new Vec2( +c/2, 0);
  vertices[1] = new Vec2( +c/2, slideLowBorder);
  vertices[2] = new Vec2( -(width/2 - wopening/2), -c);
  vertices[3] = new Vec2( -(width/2 - wopening/2),  0);
  slides[1] = new Slide(vertices, 4, new Vec2(width, -slideLowBorder), 0);
  
  // *** Pins ****************************************************
  pins = new Pin[np];
  int count = 0;
  int mult = 0;
  for (int i=0; i < np; i++) {
    count = i%(2*k -1);
    if( (count == 0) || ((count % k) == 0 ) ) {
      mult++;
    }
    float x = ((c + wcyl)/2.0) + (count%k)*(wcyl+c) + (count/k)*((wcyl+c)/2.0);
    float y = Hlowest - ( (mult*A) + (hcyl + A) );
    pins[i] = new Pin(x, y, c/2);
  }
  
  // *** Borders *************************************************
  borders = new Border[k+1];
  for(int i= 0; i < k+1; i++) {
    float x = (c + wcyl) * i;
    borders[i] = new Border(x, Hlowest, c, hcyl, A);
  }

  // *** Font ****************************************************
  // Create the font
  //println(PFont.list());
  f = createFont("Liberation Serif", 16);
  textFont(f);
}

// ////////////////////////////////////////////////////////////////// DRAW
void draw() {
  background(190);
  
  box2d.step();
  
  stroke(0);
  fill(120);  
  
  // *** Balls ***************************************************
  if (mousePressed) {
    if(balls.size() < maxBalls) {
      // generate new balls
      Ball p = new Ball(radius, 70, 0.02);
      balls.add(p);
    }
  }
  
  for(Ball p: balls) {
    p.display();
  }
  
  for(Ball p: balls) {
     if (p.killBody()) {
       balls.remove(p);
     }        
  }
  
  // *** Pins ****************************************************
  for (int i=0; i < np; i++) {
    pins[i].display();
  }

  // *** Bottom **************************************************
  bottom.display();

  // *** Borders *************************************************
  for (int i=0; i < k+1; i++) {
    borders[i].display();
  }
  
  // *** Slides **************************************************
  for (int i=0; i < 2; i++) {
    slides[i].display();
  }

  // *** Cylinders & Font ****************************************
  float x = 0.0;
  float y = Hlowest;
  pushStyle();
  rectMode(CENTER);
  noStroke();
  fill(255, 113, 31, 50);
  for(int i = 0; i < k; i++) {
    x = (c + wcyl)*i + (c+wcyl)/2;
    rect(x, y-hcyl/2, wcyl, hcyl);
  }
  popStyle();
  
  textAlign(LEFT);
  fill(0);
  text("GALTON BOX\nSIMULATOR", 20, -slideLowBorder-30);
  //textAlign(RIGHT);
  text("n. cylinders: " + k + "\nn. balls: " + balls.size(), width-20-100, -slideLowBorder-30);
  
  //println("# particles: " + balls.size() );
  conteggioBiglie();
  textAlign(CENTER);
  x = 0.0;
  for(int i = 0; i < k; i++) {
    x = (c + wcyl)*i + (c+wcyl)/2;
    fill(120);
    text("["+ (i+1) +"]", x, Hlowest - hcyl- 10);
    
    fill(0);
    text(cilCounter[i], x, Hlowest + 30);
  }
 }

// //////////////////////////////////////////////////////////// BALL COUNT
void conteggioBiglie() {
  // count the balls inside each cylinder
  float y = Hlowest;
  // for each ball
  for(Ball p: balls) {
    // do we have already done this counting?
    if( !p.bFinalPosCheck ) {
      // if it is the first time, first i verify that
      // the y coodinate is inside the cylinder
      if ( p.pos.y > (y-hcyl) && p.pos.y < y+10) {
        // once done, do the same for x coordinate
        float x = 0.0;
        for(int i = 0; i < k; i++) {
          x = (c + wcyl)*i + c/2;
          if ( p.pos.x > x && p.pos.x < (x+wcyl) ) {
            cilCounter[i]++;
            // check completed! Let's the ball
            // memorize it.
            p.bFinalPosCheck = true;
            break;
          }
        }
      }
    }
  }
}

// ////////////////////////////////////////////////////////////// KEYBOARD
void keyPressed()
{
  if(key == ' ')
    saveFrame("./frames/frame-####.png");
}