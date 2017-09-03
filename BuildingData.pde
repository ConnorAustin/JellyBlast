class BuildingData
{
  PImage image;
  color floorColor;
  float density;
  float brickScore;
  
  BuildingData(String fileName, color floorColor, float density, float brickScore)
  {
    this.image = loadImage(fileName);
    this.image.loadPixels();
    this.floorColor = floorColor;
    this.density = density;
    this.brickScore = brickScore;
  }
}
