class Effect
{
  float x, y, xMover, yMover, size, sizeChanger;
  color col;

  //TWO POINTS AT BOTTOM RIGHT AND BOTTOM LEFT
  public Effect(color col)
  {
    this.col = col;
    size = random(10, 25);
    sizeChanger = random(.1, .5);
    int spawnCorner = (int)random(0, 2);
    if (spawnCorner == 0)
    {
      x = width;
      y = height;
      xMover = random(-7, -5);
      yMover = random(-10, -5);
    } else
    {
      x = 0;
      y = height;
      xMover = random(5, 7);
      yMover = random(-10, -5);
    }
  }

  //FOR SINGLE POINT EXPLOSION
  public Effect(float x, float y, color col)
  {
    this.col = col;
    size = random(10, 25);
    sizeChanger = random(.1, .5);
    this.x = x;
    this.y = y;
    xMover = random(-4, 4);
    yMover = random(-4, 4);
  }

  //DRAWS ONE EFFECT
  void render()
  {
    //SQUARE
    pushMatrix();
    translate(x, y);
    rotate(frameCount * map(size, 15, 0, .01, .1));

    fill(col);
    rect(0, 0, size, size);
    popMatrix();

    //MOVEMENT
    x += xMover;
    y += yMover;
    yMover += .1;
    size -= sizeChanger;
  }

  //CHECKS IF SHOULD DELETE
  boolean notValid()
  {
    return(x > width || x < 0 || y > height || y < 0 || size <= 0);
  }
}
