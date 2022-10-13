//DIRECTION OF NEXT SONG
void keyPressed()
{
  if (keyCode == RIGHT)
    updateSong(2);

  else if (keyCode == LEFT)
    updateSong(0);
}

//DETECTION OF ICONS
void mousePressed()
{
  for (int i = 0; i < icons.length; i++)
  {
    if (icons[i].isClicked())
    {
      //PAUSE/PLAY
      if (i == 1)
      {
        if (song.isPlaying())
          song.pause();
        else
          song.play();

        isPaused = !isPaused;
      }

      //RENDER EFFECTS
      else if (i == 3)
      {
        renderEffects = !renderEffects;
        effects.clear();
      }

      //CHANGE SONG
      else
        updateSong(i);
    }
  }
}

//UPDATES LINKED LIST LOC AND IMAGE ALSO LOADS SONG FILE
void updateSong(int dir)
{
  doneLoading = false;
  song.stop();
  
  if (dir == 2)
    songs.curr = songs.curr.next;
  else
    songs.curr = songs.curr.prev;

  thread("loadData");
}
