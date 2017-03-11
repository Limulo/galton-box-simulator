/* This class is needed to describe
* the cylinders' borders
*/

class Border {
  
  float x, y;
  float c, hcyl, A;
  
  Body body;
  Vec2[] coords;
  
  // CONSTRUCTOR /////////////////////////////////////////////////////
  Border(float x_, float y_, float c_, float hcyl_, float A_) {
    x = x_;
    y = y_;
    c = c_;
    hcyl = hcyl_;
    A = A_;
    
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x, y) );
    bd.type = BodyType.STATIC;
    
    body = box2d.createBody(bd);
    
    PolygonShape ps = new PolygonShape();
    // let's build the coords of the PolygonalShape
    coords = new Vec2[5];
    coords[0] = box2d.vectorPixelsToWorld(new Vec2(c/2, 0));
    coords[1] = box2d.vectorPixelsToWorld(new Vec2( c/2, -hcyl));
    coords[2] = box2d.vectorPixelsToWorld(new Vec2( 0, -(hcyl+A) ));
    coords[3] = box2d.vectorPixelsToWorld(new Vec2(-c/2, -hcyl));
    coords[4] = box2d.vectorPixelsToWorld(new Vec2(-c/2, 0));
    ps.set(coords, 5);
    
    body.createFixture(ps, 1);
  }
  
  // DISPLAY /////////////////////////////////////////////////////////
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    //float a = body.getAngle(); //angle in radiants
    pushMatrix();
    translate(pos.x, pos.y);
    //rotate(-a);

    pushStyle();
    strokeWeight(1);
    stroke(0);
    fill(255, 113, 31);
    beginShape();
      vertex( c/2, 0);
      vertex( c/2, -hcyl);
      vertex( 0, -(hcyl+A) );
      vertex(-c/2, -hcyl);
      vertex(-c/2, 0);
    endShape(CLOSE);
    
    popMatrix();
    popStyle();
  }  
}