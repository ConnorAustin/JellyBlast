class Player
{
  float moveSpeed = 0.1f;
  final int playerWidth = 90;
  
  final int playerHeight = 40;
  
  final int ballCount = 7;
  
  int nextBallIndex = 0;
  
  boolean mouseIsPressed = false;
  
  float throwingTimer = 0;
  
  Ball[] balls;
  
  boolean goingBackToStart;
  float startX;
  float x;
  float y;
  
  public Player(float startX, float startY)
  {
    this.startX = startX;
    x = startX;
    y = startY;
    
    balls = new Ball[ballCount];
    for(int i = 0; i < ballCount; ++i)
    {
      balls[i] = new Ball();
    }
  }
  
  public void mousePress()
  {
    if(!goingBackToStart)
      mouseIsPressed = true;
  }
  
  public void goBackToStart()
  {
    mouseIsPressed = false;
    goingBackToStart = true;
    for(Ball ball : balls)
    {
      ball.kill();
    }
  }
  
  public void endGoingBackToStart()
  {
    goingBackToStart = false;
    x = startX;
  }
  
  public void sleepBalls()
  {
    for(Ball ball : balls)
    {
      ball.body.setActive(false);
    }
  }
  
  public void update(float deltaTime)
  {
    for(Ball ball : balls)
    {
      ball.update(deltaTime);
    }
    if(goingBackToStart)
    {
      x -= moveSpeed * 6 * deltaTime;
      if(x < startX)
      {
        x = startX;
      }
      return;
    }
    x += moveSpeed * deltaTime;
    throwingTimer -= deltaTime;
    
    if(mouseIsPressed)
    {
      
      
      PVector direction = new PVector(mouseX - x, y - mouseY);
      direction.normalize();
      balls[nextBallIndex].reset(x + 20, y + 20, direction.x, direction.y);
      throwingTimer = 90;
      
      nextBallIndex = (nextBallIndex + 1) % ballCount;
      mouseIsPressed = false;  
    }
  }
  
  public void drawSelf()
  {
    for(Ball ball : balls)
    {
      ball.drawSelf();
    }
    
    imageMode(CENTER);
    PImage img = playerImage;
    if(throwingTimer > 0)
      img = playerThrowingImage;
      
    image(img, x, y + 12 * sin(millis() / 400.0f), img.width * 3, img.height * 3);
  }
}