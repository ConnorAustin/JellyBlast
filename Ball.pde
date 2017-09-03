import java.util.*;

final float normalBallRadius = 25;

class Ball
{
  final float ballSpeed = 100;

  final int tailCount = 6;
  int brickKillCount;
  
  float radius;
  float[] tailX;
  float[] tailY;
  float disableTimer;
  float tailUpdateRate = 53;
  float tailUpdateTimer = tailUpdateRate;

  public boolean isEnabled = true;

  private Body body;

  public Ball()
  {
    makeBallBody(normalBallRadius);  
    body.setUserData(this);
    disable();
    tailX = new float[tailCount];
    tailY = new float[tailCount];

    //Disable the ball if it stays on screen for too long
    disableIn(3000);
  }

  public void reset(float newX, float newY, float xDir, float yDir)
  {
    brickKillCount = 0;
    radius = normalBallRadius;
    disableTimer = 0;
    enable();
    disableIn(1200);
    body.setTransform(box2d.coordPixelsToWorld(newX, newY), 0);
    body.setLinearVelocity(new Vec2(xDir * ballSpeed, yDir * ballSpeed));

    for (int i = 0; i < tailCount; ++i)
    {
      tailX[i] = newX;
      tailY[i] = newY;
    }
  }

  //Like disable but is instant(no trail left over)
  void kill()
  {
    disable();
    radius = 0;
  }
  
  void disable()
  {
    isEnabled = false;
    body.getFixtureList().setSensor(true);
  }

  void disableIn(float timer)
  {
    disableTimer = timer;
  }

  void enable()
  {
    isEnabled = true;
    body.getFixtureList().setSensor(false);
  }

  void makeBallBody(float radius)
  {
    CircleShape circleShape  = new CircleShape();
    circleShape.m_radius = box2d.scalarPixelsToWorld(radius / 2);

    FixtureDef circleFixtureDef = new FixtureDef();
    circleFixtureDef.shape = circleShape;
    circleFixtureDef.density = (radius / 50) * 5f;
    circleFixtureDef.friction = 0.3f;
    circleFixtureDef.restitution = random(0, 0.4f);

    BodyDef circleBodyDef = new BodyDef();
    circleBodyDef.type = BodyType.DYNAMIC; 
    body = box2d.createBody(circleBodyDef);
    body.createFixture(circleFixtureDef);
    body.setUserData(this);
  }

  public void update(float deltaTime)
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);   
    tailUpdateTimer -= deltaTime;

    if (tailUpdateTimer < 0)
    {
      tailUpdateTimer = tailUpdateRate;
      for (int i = 0; i < tailCount - 1; ++i)
      {
        tailX[i] = tailX[i + 1];
        tailY[i] = tailY[i + 1];
      }
      tailX[tailCount - 1] = pos.x;
      tailY[tailCount - 1] = pos.y;
    }
    
    if (!isEnabled)
    {
      radius = max(0, radius - deltaTime * 0.05f);
      
      return;
    }
    if (pos.x < -200 || pos.x > width + 200 || pos.y < -60 || pos.y > height + 60)
    {
      disable();
    }
    else if (disableTimer > 0)
    {
      disableTimer -= deltaTime;
      if (disableTimer < 0)
      {
        disable();
      }
    }
  }

  public void drawSelf()
  {
    Vec2 circlePos = box2d.getBodyPixelCoord(body);
    if(radius > 0)
    {
      for (int i = 0; i < tailCount - 1; ++i)
      {
        stroke(lerpColor(color(249, 255, 0), color(255, 21, 0), (float)(i) / (float)(tailCount)));
        strokeWeight((i / 10.0f) * radius * 0.5f);
        line(tailX[i], tailY[i], tailX[i + 1], tailY[i + 1]);
      }
      line(tailX[tailCount - 2], tailY[tailCount - 2], circlePos.x, circlePos.y);
    }
    if (!isEnabled)
    {
      return;
    }
    else
    {
      strokeWeight(radius / 10.0f);    
      
      imageMode(CENTER);
  
      pushMatrix();
      translate(circlePos.x, circlePos.y);
      rotate(-body.getAngle());
      image(ballImage, 0, 0, radius, radius);
      popMatrix();
    }
  }
}