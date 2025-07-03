void keyPressed() {
  if (scene == 0){
  if(key == '1') {
   resetPose();
  playStart(); 
setupMenu(); 
transition();
nextScene = 1;}
  }
  
  if (scene == 1){ 
  if(key == '2') {
  playStart(); 
setupJogo(); 
transition();
nextScene = 2;
}
  if (keyCode == RIGHT && selectedDifficulty < buttons.length - 1) {playMove(); selectedDifficulty++;}
  if (keyCode == LEFT && selectedDifficulty > 0) {playMove(); selectedDifficulty--;}
  if (keyCode == UP  && selectedTime < numbers.length - 1) {playMove(); selectedTime++;}
  if (keyCode == DOWN && selectedTime > 0) {playMove(); selectedTime--;}
  }
  
  if (scene == 3){ 
  if(key == '0') {
  playStart(); 
setupInicio(); 
transition();
nextScene = 0;
}
  if(key == '1') {
  playStart(); 
setupMenu(); 
transition();
nextScene = 1; 
}
  if(key == '2') {
    playStart(); 
setupJogo(); 
transition();
nextScene = 2;
}
  }
  
  if (scene == 4){ 
  if(key == '0') {
  playStart(); 
setupInicio(); 
transition();
nextScene = 0;
}
  if(key == '1') {
  playStart();
setupMenu(); 
transition();
nextScene = 1;
}
  }
}
