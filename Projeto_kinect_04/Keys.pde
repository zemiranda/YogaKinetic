void keyPressed() { 
  if (scene == 0){
    if(key == '0') {setupMenu(); scene++;}
  }
  
  if (scene == 1){ 
  if(key == '1') {setupJogo(); scene++;}
  if (keyCode == RIGHT && selectedDifficulty < buttons.length-1) selectedDifficulty++;
  if (keyCode == LEFT && selectedDifficulty > 0) selectedDifficulty--;  
  if (keyCode == UP  && selectedTime < numbers.length-1) selectedTime++;
  if (keyCode == DOWN && selectedTime > 0) selectedTime--; 
  }
}
