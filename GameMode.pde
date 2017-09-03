interface GameMode
{
  public void restartMode();
  
  public void keyPress();
  public void keyRelease();
  public void mousePress();
  
  public void updateMode(float deltaTime);
  public void beginContact(Contact contact);
  public void endContact(Contact contact);
  
  public void drawMode();
}
