class Slide {
  
  Body body;
  
  Vec2[] vertices;
  int nVertices;
 
  // Body initial position, because this is a static body,
  // this position will be maintaned while the program 
  // is running
  Vec2 initPos;
  float angle;
  
  // CONSTRUCTOR /////////////////////////////////////////////////////
  Slide(Vec2 vs[], int nVertices_, Vec2 initPos_, float angle_) {
    
    // data conversion
    nVertices = nVertices_;
    vertices = new Vec2[nVertices_];
    for(int i = 0; i < nVertices; i++) {
      float x = box2d.scalarPixelsToWorld( vs[i].x );
      // we have to flip the y axis
      float y = box2d.scalarPixelsToWorld( -vs[i].y );
      vertices[i] = new Vec2(x, y);
    }
    initPos = box2d.coordPixelsToWorld(initPos_); // central position in pixel
    angle = angle_;

    BodyDef bd = new BodyDef();
    bd.position.set(initPos);
    bd.angle = radians(-angle);    
    bd.type = BodyType.STATIC;
    
    body = box2d.createBody(bd);
    
    PolygonShape ps = new PolygonShape();
    ps.set(vertices, nVertices);
    
    body.createFixture(ps, 1);
  }
  
  // DISPLAY /////////////////////////////////////////////////////////
  void display() {
    
    // coincide con la initPos (se espressa in pixels)
    // 
    Vec2 pos = box2d.getBodyPixelCoord(body); 
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y); 
    rotate(-a);
    
    pushStyle();
    strokeWeight(1);
    stroke(0);
    fill(255, 113, 31);
    
    beginShape();
      for(Vec2 v: vertices) {
        float x = box2d.scalarWorldToPixels(v.x);
        float y = box2d.scalarWorldToPixels(-v.y);
        vertex(x, y);
      }
    endShape(CLOSE);
    
    // uncomment these 2 lines of code if you want to see
    // the "pseudo-center" of the figure.
    // pseudo-center is used to build-up the shape of the figure. 
    // Each vertex of the shape is infact expressed coords
    // that are relative to this point.
    //fill(255, 0, 0);
    //ellipse(0, 0, 5, 5); //
    
    popStyle();
    popMatrix();
  }  
}