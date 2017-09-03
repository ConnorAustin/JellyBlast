PImage ballImage;
PImage playerImage;
PImage playerThrowingImage;
PImage rubbleImage;
PImage jellyBlastImage;

BuildingData[] buildings;

public class Game implements GameMode
{
  Boolean gameStarted = false;
  
  Boolean menuOver = false;
  
  GameState gameState;
  
  BuildingData curBuilding;
  
  PFont scoreFont;
  
  int nextHitSoundIndex = 0;
  
  float gameOverTimer;
  
  float brickSwell;
  
  float startingBuildingXOffset;
  float buildingXOffset;
  
  int nextRubble = 0;
  
  //Rubbles is such a fun word
  Rubble[] rubbles;
  BuildingManager buildingManager;
  
  Cloud[] clouds;
  
  Player player;
  
  Body floor;
  
  color oldFloorColor;
  color newFloorColor;
  
  static final float floorHeight = 160;
  static final float floorYOffset = -100;
  
  //The order in which the buildings appear
  int curBuildingOrderIndex;
  BuildingData[] buildingOrder;
  
  public Game()
  {
    scoreFont = createFont("Consolas-Bold-48.vlw", 48);
    
    ballImage = loadImage("Ball.png");
    playerThrowingImage = loadImage("PlayerThrowing.png");
    playerImage = loadImage("Player.png");
    rubbleImage = loadImage("rubble.png");
    jellyBlastImage = loadImage("JellyBlast.png");
    
    buildings = new BuildingData[9];
    //             new BuildingData(String fileName,   color floorColor,  float density,float brickScore)
    buildings[0] = new BuildingData("Start.png",       color(255, 255, 255), 0.3f,   0.0045f);
    buildings[1] = new BuildingData("Pyramid.png",     color(183, 169, 28),  0.3f,   0.0035f);
    buildings[2] = new BuildingData("RedBuilding.png", color(30, 139, 81),   0.2f,   0.0041f);
    buildings[3] = new BuildingData("BigBuilding.png", color(86, 186, 26),   0.5f,   0.0045f);
    buildings[4] = new BuildingData("Mushroom.png",    color(240, 170, 41),  0.3f,   0.0027f);
    buildings[5] = new BuildingData("Tetris.png",      color(229, 121, 143), 0.3f,   0.0037f);
    buildings[6] = new BuildingData("SNES.png",        color(234, 234, 250), 0.3f,   0.0042f);
    buildings[7] = new BuildingData("Missingno.png",   color(245, 227, 250), 0.1f,   0.004f);
    buildings[8] = new BuildingData("Pancakes.png",    color(255, 229, 222), 0.1f,   0.00245f);
    
    rubbles = new Rubble[200];
    for(int i = 0; i < rubbles.length; ++i)
    {
      rubbles[i] = new Rubble();
    }
    startingBuildingXOffset = width;
    
    buildingOrder = new BuildingData[buildings.length - 1]; 
    for(int i = 0; i < buildingOrder.length; ++i)
    {
      buildingOrder[i] = buildings[i + 1];
    }
    curBuildingOrderIndex = buildingOrder.length;
    
    clouds = new Cloud[8];
  }

  public void restartMode()
  {
    popBar.reset();
    
    box2d.createWorld();
    box2d.listenForCollisions();
    box2d.setGravity(0, -20);
    
    gameState = GameState.Running;
    
    buildingXOffset = 0;
    
    nextRubble = 0;
    brickSwell = 0;
    
    for(int i = 0; i < clouds.length; ++i)
    {
      clouds[i] = new Cloud(i * 500 + 50, -70);
    }
    
    player = new Player(70, 70);
    
    //Create floor
    floor = createBoxBody(width / 2, height + BrickData.brickSize / 2, width, floorHeight, BodyType.STATIC);
    
    buildingManager = new BuildingManager();
    
    if(gameStarted)
    {
      setBuilding(pickRandomBuilding());
    }
    else
    {
      setBuilding(buildings[0]);
    }
  }
  
  public void mousePress()
  {
    player.mousePress();
  }
  
  public void keyPress()
  {
  }
  
  public void keyRelease()
  {
  }
  
  void setBuilding(BuildingData buildingData)
  {
    oldFloorColor = newFloorColor;
    newFloorColor = buildingData.floorColor;
    buildingManager.building = buildingFromImage(buildingData.image, floor, width / 2.0f, buildingData.density, 0.2f, 0.1f);
    curBuilding = buildingData;
  }
  
  public void updateMode(float deltaTime)
  {
    popBar.update(deltaTime);
    
    for(Rubble rubble : rubbles)
    {
      rubble.update(deltaTime);
    }
    if(gameState == GameState.Running && player.x > width + 120)
    {
      gameState = GameState.GameOver;
      gameOverTimer = 1600;  
    } 
    if(gameState == GameState.GameOver)
    {
      gameOverTimer -= deltaTime;
      if(gameOverTimer < 0)
      {
        buildingManager.sleepBuilding();
        player.sleepBalls();
        changeGameMode(results);
      }
    }
    else
    {
      if(gameState == GameState.Swelling)
      {
        player.update(deltaTime);
        brickSwell += deltaTime * 0.0009f;
        
        if(brickSwell > 2.0f)
        {
          for(Body brick : buildingManager.building)
          {
            if(brick != null)
              destroyBrick(brick);
          }
          popBar.flushBar();
          buildingManager.clean();
          
          gameState = GameState.Transitioning;
          buildingXOffset = startingBuildingXOffset;
          setBuilding(pickRandomBuilding());
          
          brickSwell = 0;
        }
      }
      else if(gameState == GameState.Transitioning)
      {
        box2d.step(1.0/60.0, 3, 1); 
        
        player.update(deltaTime); 
        
        buildingXOffset -= (startingBuildingXOffset - buildingXOffset + 300) * deltaTime * 0.001f;
        if(buildingXOffset < 0)
        {
          buildingXOffset = 0;
          gameState = GameState.Running;
          player.endGoingBackToStart();
          menuOver = true;
        }
      }
      else if(gameState == GameState.Running)
      {
        for(Cloud cloud : clouds)
        {
          cloud.update(deltaTime);
        }
        box2d.step(1.0/60.0, 3, 1); 
        
        player.update(deltaTime);
        
        //Quick hack to get the player to not move yet
        if(!gameStarted)
        {
          player.x = width / 2.0f;
        }
        
        //If we are at the start
        if(curBuilding == buildings[0])
        {
          player.x = width / 2.0f;
        }
        
        buildingManager.update(deltaTime);
      }
    }
  }
  
  BuildingData pickRandomBuilding()
  {
    if(curBuildingOrderIndex == buildingOrder.length)
    {
      curBuildingOrderIndex = 0;
      
      //Fisher-Yates Shuffle
      for(int i = buildingOrder.length - 1; i > 1; --i)
      {
        int pick = int(random(i, buildingOrder.length));
        
        //Swap
        BuildingData temp = buildingOrder[i];
        buildingOrder[i] = buildingOrder[pick];
        buildingOrder[pick] = temp;
      } 
    }
    return buildingOrder[curBuildingOrderIndex++];
  }
  
  public void drawMode()
  {
    background(53, 165, 203);
    if(!menuOver)
    {
      imageMode(CENTER);
      float logoSize = 15 * popBar.getBarProgress();
      image(jellyBlastImage, width / 2.0f, height / 2.0f - 50, jellyBlastImage.width * logoSize, jellyBlastImage.height * logoSize);
    }
    
    
    noStroke();
    rectMode(CORNER);
    
    //Draw floor
    fill(oldFloorColor);
    rect(buildingXOffset - startingBuildingXOffset, height + floorYOffset, width, height);
    
    fill(lerpColor(color(0), oldFloorColor, 0.9f));
    rect(buildingXOffset - startingBuildingXOffset, height + floorYOffset + 30, width, height);
    
    fill(lerpColor(color(0), oldFloorColor, 0.7f));
    rect(buildingXOffset - startingBuildingXOffset, height + floorYOffset + 45, width, height);
    
    //Draw floor
    fill(newFloorColor);
    rect(buildingXOffset, height + floorYOffset, width, height);
    
    fill(lerpColor(color(0), newFloorColor, 0.9f));
    rect(buildingXOffset, height + floorYOffset + 30, width, height);
    
    fill(lerpColor(color(0), newFloorColor, 0.7f));
    rect(buildingXOffset, height + floorYOffset + 45, width, height);
    
    strokeWeight(gameState == GameState.Swelling ? 0 : 2);
    
    if(buildingManager.building != null)
    for(Body brick : buildingManager.building)
    {
      if(brick != null)
      {
        BrickData brickData = (BrickData)brick.getUserData();
        
        stroke(brickData.col);
        fill(brickData.col);

        Vec2 bodyPos = box2d.getBodyPixelCoord(brick);
        float angleOfBody = brick.getAngle();
        
        pushMatrix();
        
        translate(bodyPos.x + buildingXOffset, bodyPos.y);
        rectMode(CENTER);
        rotate(-angleOfBody);
        float size = lerp(BrickData.brickSize, 17, brickSwell);
        rect(0, 0, size, size);
        popMatrix();
      }
    }
    
    if(gameState == GameState.Transitioning)
    {
      pushMatrix();
    
      translate(buildingXOffset - startingBuildingXOffset, 0.0f);
    }
    for(Rubble rubble : rubbles)
    {
      rubble.drawSelf();
    }
    if(gameState == GameState.Transitioning)
      popMatrix();
    
    for(Cloud cloud : clouds)
    {
      cloud.drawSelf();
    }
    
    player.drawSelf();
    
    textFont(scoreFont);
    
    if(gameState == GameState.GameOver)
    {
      fill(0);
      textSize(68);
      textAlign(CENTER);
      
      text("TIME!", width / 2, height / 2);
    }
    
    popBar.drawSelf(width / 2.0f, height - 37);
  } 
  
  public void endContact(Contact contact)
  {
  }
  
  public void makeRubble(float x, float y, color col)
  {
    for(int i = 0; i < 2; ++i)
    {
      rubbles[nextRubble].reset(x, y, col);
      nextRubble = (nextRubble + 1) % rubbles.length;
    }
  }
  
  void destroyBrick(Body brick)
  {
    Vec2 brickPos = box2d.getBodyPixelCoord(brick);
    BrickData brickData = (BrickData)brick.getUserData();
    brickData.cleanUpBody = true;
    
    
    
    makeRubble(brickPos.x, brickPos.y, brickData.col);
  }
  
  public void beginContact(Contact contact)
  {
    HitResult hitResult = buildingManager.beginContact(contact);
    if(hitResult != null)
    {
      Body hitBrick = hitResult.brick;
      Ball ball = hitResult.ball;
      
      if(++ball.brickKillCount > 15)
      {
        ball.disable();
      }
      destroyBrick(hitBrick);
      
      popBar.increase(curBuilding.brickScore);
      
      if(popBar.getBarProgress() == 1.0f)
      {
        player.moveSpeed += 0.02f;
        player.goBackToStart();
        
        gameState = GameState.Swelling; 
          
        if(gameStarted)
        {
          ((Results)results).addBuilding(curBuilding.image);
        }
        
        //It's on like donkey kong!
        gameStarted = true;
      }
    }
  }
}