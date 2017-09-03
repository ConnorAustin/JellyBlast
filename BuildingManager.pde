class HitResult
{
  Ball ball;
  Body brick;
  
  HitResult(Ball ball, Body brick)
  {
    this.ball = ball;
    this.brick = brick;
  }
}

class BuildingManager
{
  public Body[] building;
  
  public BuildingManager()
  {
  }
  
  public void sleepBuilding()
  {
    for(Body brick : building)
    {
      if(brick != null)
        brick.setActive(false);
    }
  }
  
  public void update(float deltaTime)
  {
    if(building == null)
      return;
    
    for(int brickIndex = 0; brickIndex < building.length; ++brickIndex)
    {
      Body brickBody = building[brickIndex];
      if(brickBody != null)
      {
        BrickData data = (BrickData)brickBody.getUserData();
        if(data.cleanUpBody)
        {
          box2d.destroyBody(brickBody);
          building[brickIndex] = null;
        }
      }
    }
  }
  
  public void clean()
  {
    for(Body brick : building)
    {
      if(brick != null)
        box2d.destroyBody(brick);
    }
    building = null;
  }
  
  //Returns the destroyed brick if a brick was destroyed
  public HitResult beginContact(Contact contact)
  {
    Fixture f1 = contact.getFixtureA();
    Fixture f2 = contact.getFixtureB();
    
    // Get both bodies
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
  
    // Get our objects that reference these bodies
    Object data1 = b1.getUserData();
    Object data2 = b2.getUserData();  
    
    if(data1 != null && data2 != null)
    {
      if(data1.getClass() == Ball.class && data2.getClass() == BrickData.class)
      {
        //Swap data and bodies so that we don't need to make duplicate code for when the bodies are swapped 
        data1 = b2.getUserData();
        data2 = b1.getUserData();
        
        b1 = f2.getBody();
        b2 = f1.getBody();
      }
      if (data1.getClass() == BrickData.class && data2.getClass() == Ball.class)
      {
        Vec2 impactVel = b1.getLinearVelocity().sub(b2.getLinearVelocity());
        Ball ball = (Ball)data2;
        
        //If the ball hit a brick with enough velocity to destroy it
        if(ball.isEnabled && impactVel.length() > 20)
        {
          BrickData brick = (BrickData)data1;
          brick.cleanUpBody = true;
          
          ball.disableIn(60);
          
          return new HitResult(ball, b1);
        }
      }
    }
    return null;
  }
}
