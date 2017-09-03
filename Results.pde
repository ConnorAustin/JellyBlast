public class Results implements GameMode
{
  PFont font;
  
  final float buildingSize = 2;
  final float peopleSize = 3;
  final float maxAlphaOverlay = 120;
  float continueCountdown;
  float continueAlpha;
  float resultOverlayAlpha;
  
  float addBuildingCap;
  float addBuildingCountdown;
  int buildingCount;
  int curBuildingCount;
  
  float x;
  
  Body[] buildings;
  ArrayList<PImage> buildingImages = new ArrayList<PImage>();
  ArrayList<Integer> buildingColors = new ArrayList<Integer>();
  
  public Results()
  {
    font = createFont("SourceSansPro-Semibold-48", 48);
    buildingImages = new ArrayList<PImage>();
  }

  public void setBuildingCount(int count)
  {
    buildingCount = count;
  }

  public void restartMode()
  {
    x = width;
    resultOverlayAlpha = 0;
    continueAlpha = 0;
    continueCountdown = 300;
    curBuildingCount = 0;
    buildingCount = buildingImages.size();
    addBuildingCap = 300;
    addBuildingCountdown = addBuildingCap;
    
    buildings = new Body[buildingCount];
  }
  
  public void addBuilding(PImage buildingImage)
  {
    buildingColors.add(color(random(125, 255), random(125, 255), random(125, 255)));
    buildingImages.add(buildingImage);
  }

  public void keyPress()
  {
    if (key == ' ')
    {
      buildingImages.clear();
      buildingColors.clear();
      changeGameMode(game);
    }
  }

  public void keyRelease()
  {
  }

  public void mousePress()
  {
  }

  public void updateMode(float deltaTime)
  {
    box2d.step(1.0/60.0, 3, 1);
    x -= x * deltaTime / 150.0f;
    
    if (x < 0)
      x = 0;
      
    resultOverlayAlpha = min(resultOverlayAlpha + deltaTime / 5.0f, maxAlphaOverlay);
    if(curBuildingCount != buildingCount && x <= 2)
    {
      addBuildingCountdown -= deltaTime;
      if(addBuildingCountdown < 0)
      {
        addBuildingCountdown = addBuildingCap;
       
        curBuildingCount++;
        
        PImage buildingImage = buildingImages.get(curBuildingCount - 1);
        Body building = createBoxBody(width / 2.0f + random(-100, 101), -20, buildingImage.width * buildingSize, buildingImage.height * buildingSize, 1.0f, 0.8f, 0.3f, BodyType.DYNAMIC);
        building.setLinearVelocity(new Vec2(random(-6, 7), -20.0f));
        buildings[curBuildingCount - 1] = building;
      }
    }
    
    if(curBuildingCount == buildingCount)
    {
      continueCountdown -= deltaTime / 2.0f;
      
      if (continueCountdown < 0)
        continueAlpha = min(continueAlpha + deltaTime, 255);
    }
  }

  public void drawMode()
  {
    //Draw the game under the results screen
    game.drawMode();
    
    noStroke();
    fill(240, 255, 240, resultOverlayAlpha);
    rectMode(CORNER);
    rect(0, 0, width, height);
    
    pushMatrix();
    translate(round(x), 0);
    
    imageMode(CENTER); 
    rectMode(CENTER);
    
    strokeWeight(3);
    for(int i = 0; i < buildings.length; ++i)
    {
      //Gotta stay in shape!
      Body building = buildings[i];
      if(building != null)
      {
        Vec2 buildingPos = box2d.getBodyPixelCoord(building);
        pushMatrix();
        translate(buildingPos.x, buildingPos.y);
        rotate(-building.getAngle());
        PImage buildingImage = buildingImages.get(i);
        fill(buildingColors.get(i));
        stroke(lerpColor(color(0), buildingColors.get(i), 0.9f));
        rect(0, 0, buildingImage.width * buildingSize, buildingImage.height * buildingSize);
        tint(lerpColor(buildingColors.get(i), color(255), 0.9f));
        image(buildingImages.get(i), 0, 0, buildingImage.width * buildingSize, buildingImage.height * buildingSize);
        popMatrix();
      }
    }
    tint(255);
    
    fill(0);
    textFont(font);
    textAlign(CENTER);
    text("Buildings Destroyed: " + curBuildingCount, width / 2, 50);

    textFont(font, 25);
    fill(40, continueAlpha);
    text("Press [Space] to play again.", width / 2, height - 40);
    popMatrix();
  }
  
  public void beginContact(Contact contact)
  {
  }
  
  public void endContact(Contact contact)
  {
  }
}