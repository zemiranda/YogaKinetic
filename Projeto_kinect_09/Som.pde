import ddf.minim.*;

Minim minim;
AudioPlayer menuSound, gameSound, noiseSound, noise2Sound;
AudioPlayer startSound, moveSound, selectSound, failSound, passSound;

void setupSom() {
  minim = new Minim(this);

  menuSound    = minim.loadFile("som/LEASE.mp3");
  gameSound    = minim.loadFile("som/nature.mp3");
  noiseSound   = minim.loadFile("som/noise.mp3");
  noise2Sound  = minim.loadFile("som/noise2.mp3");
  startSound   = minim.loadFile("som/sfx/start.mp3");
  moveSound    = minim.loadFile("som/sfx/move.mp3");
  selectSound  = minim.loadFile("som/sfx/select.mp3");
  failSound  = minim.loadFile("som/sfx/fail.mp3");
  passSound  = minim.loadFile("som/sfx/pass.mp3");
}

void stopSound(AudioPlayer sound) {
  if (sound.isPlaying()) {
    sound.pause();
    sound.rewind();
  }
}

void loopIfNotPlaying(AudioPlayer sound) {
  if (!sound.isPlaying()) {
    sound.loop();
  }
}

void menuMusic() {
  stopSound(gameSound);
  stopSound(noiseSound);
  stopSound(noise2Sound);
  loopIfNotPlaying(menuSound);
}

void gameMusic() {
  stopSound(menuSound);
  stopSound(noise2Sound);
  loopIfNotPlaying(gameSound);
  loopIfNotPlaying(noiseSound);
  noiseSound.setGain(-80);
}

void defeatMusic() {
  noiseSound.setGain(0);
  stopSound(menuSound);
  stopSound(gameSound);
  loopIfNotPlaying(noiseSound);
  loopIfNotPlaying(noise2Sound);
  noiseSound.setGain(0);
}

void winMusic() {
  stopSound(menuSound);
  stopSound(noiseSound);
  stopSound(noise2Sound);
  loopIfNotPlaying(gameSound);
}

void noiseVolume() {
  if (!emPose) {
    float gain = (80 * ((elapsedTimeOutOfPose / 1000.0) / 15)) - 80;
    noiseSound.setGain(gain);
  } else {
    noiseSound.setGain(-80);
  }
}

void playOneShot(AudioPlayer sound) {
  sound.pause();
  sound.rewind();
  sound.play();
}

void playStart()  { playOneShot(startSound); }
void playMove()   { playOneShot(moveSound); }
void playSelect() { playOneShot(selectSound); }
void playFail() { playOneShot(failSound); }
void playPass() { playOneShot(passSound); }
