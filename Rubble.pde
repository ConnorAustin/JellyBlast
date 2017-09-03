class Rubble
{
  float size;
  
  float x, y;
  float xVel, yVel;
  float angle;
  float angleVelocity;
  
  color col;
  
  Rubble()
  {
    size = 0;
  }
  
  void reset(float x, float y, color col) 
  {
    this.size = random(3, 17);
    this.x = x;
    this.y = y;
    this.col = col;
    
    this.yVel = random(-4, -1);
    this.xVel = random(-1, 2);
    
    int direction = round(random(1));
    if(direction == 0)
      this.xVel *= -1;
    this.xVel /= (size * 0.1f);
    this.yVel /= (size * 0.1f);
    angle = random(0, TWO_PI);
    angleVelocity = random(-2, 3);
  }
  
  void update(float deltaTime)
  {
    size -= deltaTime * 0.01f;
    if(size < 0)
      size = 0;
      
    yVel += deltaTime * 0.001f * size;
    angle += angleVelocity * deltaTime * 0.001f;
      
    x += xVel * deltaTime * 0.1f;
    y += yVel * deltaTime * 0.1f;
  }
  
  void drawSelf()
  {
    if(size == 0)
      return;
    imageMode(CENTER);
    pushMatrix();
    translate(x, y);
    scale(size / 5.0f);
    rotate(angle);
    tint(col);
    image(rubbleImage, 0, 0);
    popMatrix();
    tint(255);
  }
}
