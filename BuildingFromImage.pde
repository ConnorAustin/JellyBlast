Body[] buildingFromImage(PImage image, Body floor, float xPos, float density, float friction, float restitution)
{
  int pixelIndex = 0;
  
  int imageWidth = image.width;
  int imageHeight = image.height;
  
  Body[] building = new Body[imageWidth * imageHeight];
  
  for(int y = 0; y < imageHeight; ++y)
  for(int x = 0; x < imageWidth; ++x)
  {
    color pixelColor = image.pixels[x + y * imageWidth];
    
    if(alpha(pixelColor) < 125)
    {
       building[x + y * imageWidth] = null;
       continue;  
    }
    BodyType bodyType = y < imageHeight - 1 ? BodyType.DYNAMIC : BodyType.STATIC;
    
    Body body = createBoxBody(x * BrickData.brickSize + xPos - (imageWidth * BrickData.brickSize) / 2,
                              y * BrickData.brickSize + height - (imageHeight * BrickData.brickSize) - Game.floorHeight / 2.0f, BrickData.brickSize, BrickData.brickSize, density, friction, restitution, bodyType);
                              
    body.setUserData(new BrickData(pixelColor));
    building[x + y * imageWidth] = body;
  }
  
  gluePixelsTogether(building, imageWidth, imageHeight, floor);

  return building;
}
