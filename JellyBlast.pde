/*
  This is a game about a yellow dude in a cloud shooting who knows what at random stuff made of jelly
*/

import shiffman.box2d.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.callbacks.*;

GameMode game;
GameMode results;

GameMode mode;

Box2DProcessing box2d;

PopBar popBar;

PFont personMessageFont;


void changeGameMode(GameMode newMode)
{
  mode = newMode;
  mode.restartMode();
}

String getTitle()
{
  return "Jelly Blast!";
}

String getName()
{
  return "Connor 'Consumer of much pizza' Austin";
}

public void beginContact(Contact contact)
{
  mode.beginContact(contact);
}

public void endContact(Contact contact)
{
  mode.endContact(contact);
}

void setup()
{
  size(1080, 720);
  noSmooth();
  popBar = new PopBar();

  box2d = new Box2DProcessing(this);
  game = new Game();
  results = new Results();
  
  changeGameMode(game);

  lastUpdate = millis();
}

void keyPressed()
{
  mode.keyPress();
}

void keyReleased()
{
  mode.keyRelease();
}

void mousePressed()
{
  mode.mousePress();
}

void update(float deltaTime)
{
  mode.updateMode(deltaTime);
}

float lastUpdate = 0;
void draw()
{ 
  float curTime = millis();
  update(curTime - lastUpdate);
  lastUpdate = curTime;
  mode.drawMode();
}