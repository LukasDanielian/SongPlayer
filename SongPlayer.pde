//IMPORTS
import processing.sound.*;
import java.util.*;

//VARIABLES
Amplitude amp;
SoundFile song;
Sound s;
ArrayList<Effect> effects;
int vol;
PImage image;
DoublyLinkedList<Song> songs;
Icon[] icons;
boolean isPaused;
boolean renderEffects;
PImage logo;
PFont theFont;
boolean doneLoading = false;

void setup()
{
  //GENERAL SETTINGS
  fullScreen();
  colorMode(RGB);
  shapeMode(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  noStroke();

  //READ FILE FOR AMOUNT OF SONGS AND BUILD DCLL
  songs = new DoublyLinkedList<Song>();
  File folder = new File(sketchPath("data"));
  Stack<String> files = new Stack<String>();

  for (File fileEntry : folder.listFiles())
    files.push(fileEntry.getName());

  while (!files.isEmpty())
    songs.addFront(new Song(files.pop(), files.pop()));

  songs.front.prev = songs.end;
  songs.end.next = songs.front;
  songs.curr = songs.front;

  //SOUND SETTUP
  thread("loadData");
  isPaused = false;
  vol = height/2;

  //EFFECT SETTUP
  renderEffects = true;
  effects = new ArrayList<Effect>();
  
  //ICON SETUP
  icons = new Icon[4];
  icons[0] = new Icon(width/2-width*.1, height * .95, "Last");
  icons[1] = new Icon(width/2, height * .95, "Pause/Play");
  icons[2] = new Icon(width/2+width*.1, height * .95, "Next");
  icons[3] = new Icon(width/2, height * .85, "Effects");

  //IMAGE SETTINGS
  logo = loadImage("LukasLogo.png");
  logo.resize(0, height/4);

  //FONT SETTINGS
  theFont = createFont("Javanese Text", 25);
  textFont(theFont);
  textAlign(CENTER, CENTER);
}

void draw()
{
  //SETTINGS
  background(0);

  //LOGO
  fill(255);
  textSize(25);
  text("Danielian Softworks®", width/2, height * .025);

  //MAIN SCREEN
  if (doneLoading)
  {
    //AUDIO
    s.volume(map(vol, 0, height, .5, 0));

    //GUI
    fill(0);
    stroke(255);
    strokeWeight(5);
    rect(width * .025, height/2, width * .05, height);
    fill(0);
    rectMode(CORNERS);
    fill(255);
    noStroke();
    rect(0, vol, width * .05, height + vol);
    fill(0);
    stroke(255);
    rectMode(CENTER);
    rect(width * .025, vol, width * .05, height * .1, 40);
    fill(255);
    textSize(15);
    text("Volume", width * .025, vol);
    stroke(255);
    strokeWeight(5);
    fill(0);
    rect(width/2, height/2, map(amp.analyze(), 0, 1, image.width*1.01, image.width * 1.5), map(amp.analyze(), 0, 1, image.height*1.01, image.height * 1.5), 50);
    image(image, width/2, height/2);
    noStroke();

    //VOLUME SCROLLER
    if (mousePressed && mouseX < width * .1)
      vol = mouseY;


    //EFFECT RENDER
    if (renderEffects)
    {
      for (int i = 0; i < effects.size(); i++)
      {
        Effect temp = effects.get(i);
        temp.render();

        if (temp.notValid())
          effects.remove(temp);
      }

      //ADDING EFFECTS BASED ON SOUND LEVEL
      for (int i = 0; i < map(amp.analyze(), .7, 1, 0, 50); i++)
        effects.add(new Effect(get((int)random(width/2-image.width/2, width/2+image.width/2), (int)random(height/2-image.height/2, height/2+image.height/2))));

      //FIREWORK EFFECTS IF SOUND IS VERY LOUD
      if (amp.analyze() > .8)
      {
        color col = get((int)random(width/2-image.width/2, width/2+image.width/2), (int)random(height/2-image.height/2, height/2+image.height/2));
        float x = random(0, width);
        float y = random(0, height);
        for (int i = 0; i < 50; i++)
          effects.add(new Effect(x, y, col));
      }
    }

    //ICON RENDER
    for (int i = 0; i < icons.length; i++)
      icons[i].render();

    //AUTO PLAY
    if (!song.isPlaying() && !isPaused)
      updateSong(2);
  }

  //LOADING SCREEN
  else
  {
    textSize(50);
    pushMatrix();
    translate(width/2, height/2);
    image(logo, 0, 0);
    rotate(frameCount * .025);
    for (int i = 0; i < 270; i+=45)
    {
      float wheelX = sin(i) * height/4;
      float wheelY = cos(i) * height/4;
      pushMatrix();
      translate(wheelX, wheelY);
      rotate(frameCount * .05);
      for (int j = 0; j < 270; j += 45)
      {
        float x = sin(j) * 25;
        float y = cos(j) * 25;
        ellipse(x, y, 10, 10);
      }
      popMatrix();
    }
    popMatrix();
  }
}

//LOADS SONG DATA ON A NEW THREAD THEN LOADS ADJECENT SONGS
void loadData()
{
  //LOADS SOUND DATA AND SONG
  image = loadImage(songs.curr.data.imageFile);
  image.resize(0, height/2);
  song = new SoundFile(this, songs.curr.data.audioFile);
  song.play();
  s = new Sound(this);
  amp = new Amplitude(this);
  amp.input(song);
  doneLoading = true;
  
  //LOADS SONG TO THE LEFT AND RIGHT
  loadImage(songs.curr.prev.data.imageFile);
  loadImage(songs.curr.next.data.imageFile);
  SoundFile temp;
  temp = new SoundFile(this, songs.curr.prev.data.audioFile);
  temp = new SoundFile(this, songs.curr.next.data.audioFile);
}
