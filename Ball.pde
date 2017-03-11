class Ball {
  
  Body body;
  float r;
  Vec2 pos; // posizione delal biglia in pixels
  boolean bFinalPosCheck;
  
  // CONSTRUCTOR /////////////////////////////////////////////////////
  Ball(float r_, float density_, float restitution_) {
    r = r_;
    
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(mouseX, mouseY));
    bd.type = BodyType.DYNAMIC;
    
    body = box2d.createBody(bd);
    
    CircleShape cs = new CircleShape();
    float box2Dr = box2d.scalarPixelsToWorld(r_);
    cs.setRadius(box2Dr);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = density_;
    fd.restitution = restitution_;
    
    body.createFixture(fd);
    bFinalPosCheck = false;
  }
  
  // DISPLAY /////////////////////////////////////////////////////////
  void display() {
    pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle(); //angle in radiants
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    pushStyle();
    
    if(sveglio() == 1) {
      fill(0, 255, 0);
    } else {
      fill(175);
    }
    stroke(0);
   
    ellipse(0, 0, 2*r, 2*r);
    line(0, 0, r, 0);
    
    popStyle();
    popMatrix();
  }
  
  // a useful function to verify the ball status
  int sveglio() {
    int i = 0;
    if(body.isAwake()) 
      i = 1;
     else
       i = 0;
       
    return i;
  }
  
  // use this function to delete the ball from the world
  boolean killBody() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if(pos.x + r < 0 || pos.x - r> width || pos.y - r> height) {
      box2d.destroyBody(body);
      return true;
    }
    return false;
  }


  // FINAL POSITION CHECK ////////////////////////////////////////////
  // this function is called when we want to check if the ball 
  // is inside one of the cylinder.
  boolean finalPositionCheck() {
    return bFinalPosCheck;
  }
  
}