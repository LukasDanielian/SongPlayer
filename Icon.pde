class Icon
{
  //VARIABLES
  float x,y;
  String text;
  boolean canClick;
  
  public Icon(float x, float y, String text)
  {
    this.x = x;
    this.y = y;
    this.text = text;
    canClick = true;
  }
  
  void render()
  {
    //CIRCLE
    stroke(255);
    strokeWeight(map(amp.analyze(),0,1,1,10));
    fill(0);
    if(!renderEffects && text.equals("Effects"))
      fill(255,0,0);
      
    circle(x,y,dist(x,y,mouseX,mouseY) <= height * .075 / 2? height * .1 : height * .075);
    noStroke();
    
    //TEXT
    textSize(15);
    fill(255);
    text(text, x, y);
    
    //LIMITS CLICKING
    if(!canClick && frameCount % 50 == 0)
      canClick = true;
    
    //WHITE EFFECTS AROUND CIRCLE
    if(amp.analyze() > .85 && renderEffects)
    {
      for(int i = 0; i < 20; i++)
        effects.add(new Effect(x,y,255));
    }
  }
  
  //CHECKS IF BOTTON IS CLICKED
  boolean isClicked()
  {
    if(canClick && dist(x,y,mouseX,mouseY) <= height * .05)
    {
      canClick = false;
      return true;
    }
      
    return false;
  }
}
