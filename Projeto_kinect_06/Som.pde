import ddf.minim.*;

Minim minim;
AudioPlayer menuSound, gameSound, noiseSound, selectSound;

void setupSom(){
  minim = new Minim(this);
  
  menuSound = minim.loadFile("som/flashcasanova.mp3");
  gameSound = minim.loadFile("som/Desolation.mp3");
  noiseSound = minim.loadFile("som/noise.mp3");
  selectSound = minim.loadFile("som/select.wav");
  
  menuMusic();
}

void menuMusic() {
  if (gameSound.isPlaying()) {
    gameSound.pause();
    gameSound.rewind();
    
    noiseSound.pause();
    noiseSound.rewind();
  }
  
  if (!menuSound.isPlaying()) {
    menuSound.loop();
  }
}

void gameMusic() {
  if (menuSound.isPlaying()) {
    menuSound.pause();
    menuSound.rewind();
  }
  
  if (!gameSound.isPlaying()) {
    gameSound.loop();
  }
  
  if (!noiseSound.isPlaying()) {
    noiseSound.loop();
  }
}

void noiseVolume(){
  if(emPose == false){
   noiseSound.setGain((80 * ((elapsedTimeOutOfPose / 1000.0) / 15)) - 80);
  }
  else {noiseSound.setGain(-80);}
}

void playSelect(){
selectSound.pause(); selectSound.rewind(); selectSound.play();
}
