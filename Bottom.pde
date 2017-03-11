class Bottom {
  
  float w, h;
 
  Body body;
  Vec2[] coords;
  Vec2 initPos;
  
  // CONSTRUCTOR /////////////////////////////////////////////////////
  Bottom(Vec2 initPos_, float w_, float h_) {
        
    w = w_;
    h = h_;
    
    // central position in pixels
    initPos = box2d.coordPixelsToWorld(initPos_); 
    
    BodyDef bd = new BodyDef();
    bd.position.set(initPos);
    bd.type = BodyType.STATIC;
   
    body = box2d.createBody(bd);
   
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    ps.setAsBox(box2dW, box2dH);
 
    body.createFixture(ps, 1);
  } 
  
  // DISPLAY /////////////////////////////////////////////////////////
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    //float a = body.getAngle();
  
    pushMatrix();
    translate(pos.x, pos.y);
    //rotate(-a);
       
    pushStyle();
    
    strokeWeight(1);
    stroke(0);
    fill(255, 113, 31);
    rectMode(CENTER);
    rect(0, 0, w, h);

    popStyle();
    popMatrix();
  }  
 
}