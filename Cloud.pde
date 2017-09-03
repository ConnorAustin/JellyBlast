class Cloud
{
  final float w = 100;
  final float h = 50;
  
  float x, y;
  Body body;
  
  Cloud()
  {
  }
  
  public Cloud(float x, float y)
  {
    this.x = x;
    this.y = y;
    
    //body = createBoxBody(x, y, w, h, 0.5, 1, 1.0f, BodyType.KINEMATIC);
  }
  
  public void update(float deltaTime)
  {
    x -= deltaTime * 0.03f;
    //body.setTransform(box2d.vectorPixelsToWorld(x, y), 0);
  }
  
  public void drawSelf()
  {
    fill(255);
    rectMode(CENTER);
    //Vec2 cloudPos = box2d.getBodyPixelCoord(body);
    
    //rect(cloudPos.x, cloudPos.y, w, h);  
  }
}
