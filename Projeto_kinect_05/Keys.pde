void keyPressed() {  
  if (scene == 1){ 
  if(key == '2') {setupJogo(); scene = 2;}
  if (keyCode == RIGHT && selectedDifficulty < buttons.length-1) selectedDifficulty++;
  if (keyCode == LEFT && selectedDifficulty > 0) selectedDifficulty--;  
  if (keyCode == UP  && selectedTime < numbers.length-1) selectedTime++;
  if (keyCode == DOWN && selectedTime > 0) selectedTime--; 
  }
  
  if (scene == 3){ 
  if(key == '0') {setupInicio(); scene = 0;}
  if(key == '1') {setupMenu(); scene = 1;}
  if(key == '2') {setupJogo(); scene = 2;}
  }
  
  if (scene == 4){ 
  if(key == '0') {setupInicio(); scene = 0;}
  if(key == '1') {setupMenu(); scene = 1;}
  }
}
