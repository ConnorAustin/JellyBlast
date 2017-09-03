class PopBar
{
  
  float barProgress;
  
  float waveAmp;
  
  boolean flushing;
  
  PopBar()
  {
    
    
    flushing = false;
    
    reset();
  }
  
  void reset()
  {
    waveAmp = 0;
    
    barProgress = 0;
  }
  
  void flushBar()
  {
    flushing = true;
  }
  
  float getBarProgress()
  {
    return barProgress;
  }
  
  void increase(float amount)
  {
    barProgress = min(1, barProgress + amount);
    waveAmp = 0.24f;
    if(flushing)
    {
      
    }
    else
    {
      
    }
    if(flushing && barProgress < 0)
    {
      barProgress = 0;
      flushing = false;
    }
  }
  
  void update(float deltaTime)
  {
    if(flushing)
    {
      increase(-0.002f * deltaTime);
    }
    waveAmp -= 0.0005f * deltaTime;
    if(waveAmp < 0)
      waveAmp = 0;
    
  }
  
  void drawSelf(float x, float y)
  {
    final float startBarWidth = 600;
    noStroke();
    fill(0);
    rectMode(CORNER);
    rect(x - startBarWidth / 2.0f, y, 600, 27);
    fill(lerpColor(color(40, 40, 40), color(247, 110, 60), barProgress));
    rect(x - startBarWidth / 2.0f, y, lerp(0, startBarWidth, barProgress), 27);
  }
}