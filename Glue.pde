void glueBrickBodies(Body brick1, Body brick2)
{
  if(brick1 == null || brick2 == null)
    return;
    
  DistanceJointDef jointDef = new DistanceJointDef();
  jointDef.bodyA = brick1;
  jointDef.bodyB = brick2;
  jointDef.length = box2d.scalarPixelsToWorld(BrickData.brickSize);
  jointDef.frequencyHz = 0;
  jointDef.dampingRatio = 0;
  jointDef.collideConnected = true;
  
  box2d.world.createJoint(jointDef);
}

void glueToFloor(Body brick, Body floor)
{
  if(brick == null)
    return;
  
  Body bodyA = brick;
  
  DistanceJointDef jointDef = new DistanceJointDef();
  jointDef.bodyA = bodyA;
  jointDef.bodyB = floor;
  
  Vec2 gluePos = bodyA.getPosition();
  gluePos.y += box2d.scalarPixelsToWorld(BrickData.brickSize);
  
  jointDef.localAnchorB.set(floor.getLocalPoint(gluePos));
  jointDef.length = box2d.scalarPixelsToWorld(BrickData.brickSize);
  jointDef.frequencyHz = 0;
  jointDef.dampingRatio = 0;
  jointDef.collideConnected = true;
  
  DistanceJoint joint = (DistanceJoint) box2d.world.createJoint(jointDef);
}


void gluePixelsTogether(Body[] brickArray, int pixelsWide, int pixelsTall, Body floor)
{
  for(int y = 0; y < pixelsTall; y++)
  for(int x = 0; x < pixelsWide; x++)
  {
    //If this isn't the top row
    if(y != 0)
    {
      //Connect to the brick above
      glueBrickBodies(brickArray[x + y * pixelsWide], brickArray[x + (y - 1) * pixelsWide]);
    } 
    //If this isn't the bottom row
    if(y != pixelsTall - 1)
    {
      //Connect to the brick below
      glueBrickBodies(brickArray[x + y * pixelsWide], brickArray[x + (y + 1) * pixelsWide]);
    } 
    else
    {
      //Else, connect to floor
      glueToFloor(brickArray[x + y * pixelsWide], floor);
    }
    //If this isn't the right most column
    if(x != pixelsWide - 1)
    {
      //Connect to the brick to the right
      glueBrickBodies(brickArray[x + y * pixelsWide], brickArray[x + 1 + y * pixelsWide]);
    } 
    //If this isn't the left most column
    if(x != 0)
    {
      //Connect to the brick to the left
      glueBrickBodies(brickArray[x + y * pixelsWide], brickArray[x - 1 + y * pixelsWide]);
    } 
  }
}
