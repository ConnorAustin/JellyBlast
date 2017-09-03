Body createBoxBody(float x, float y, float w, float h, BodyType bodyType)
{
  return createBoxBody(x, y, w, h, 1.0f, 0.3f, 0, bodyType);
}

Body createBoxBody(float x, float y, float w, float h, float density, float friction, float restitution, BodyType bodyType)
{
  PolygonShape boxShape = new PolygonShape();
  float boxWidth = box2d.scalarPixelsToWorld(w / 2);
  float boxHeight = box2d.scalarPixelsToWorld(h / 2);
  boxShape.setAsBox(boxWidth, boxHeight);
  
  FixtureDef boxFixtureDef = new FixtureDef();
  boxFixtureDef.shape = boxShape;
  boxFixtureDef.density = density;
  boxFixtureDef.friction = friction;
  boxFixtureDef.restitution = restitution;
    
  BodyDef boxBodyDef = new BodyDef();
  boxBodyDef.type = bodyType;
  
  Vec2 boxPos = box2d.coordPixelsToWorld(new Vec2(x, y));
  boxBodyDef.position.set(boxPos);
    
  Body body = box2d.createBody(boxBodyDef);
  body.createFixture(boxFixtureDef);  
    
  return body;
}