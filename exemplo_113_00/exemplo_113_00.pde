// Exemplo_113_00
import processing.video.*;

Capture cam;
String[] listaCameras;

void setup() {
  size(1000, 800);

  listaCameras = Capture.list();

  if (listaCameras == null) {
    println("Lista de câmaras nula!");
  } 
  if (listaCameras.length == 0) {
    println("Câmara(s) não detetada(s)!");
    exit();
  } 
  else {
    println("Câmaras disponíveis:");
    for (int i = 0; i < listaCameras.length; i++) {
      println("listaCameras[" + i + "]: " + listaCameras[i]);
    }

    //cam = new Capture(this, listaCameras[5]);// Escolha da configuração através dos resultados da lista
    //cam = cam = new Capture(this, 320, 240, "Chicony USB 2.0 Camera", 30); // Escolha da câmara atraves dos resultados do nome da câmara
    cam = new Capture(this, 640, 400); // Definição da configuração

    // Inicia a captura de imagens a partir da câmara
    cam.start();
  }
}

void draw() {
  background(235);
  // Lê uma nova imagem se a câmara tiver uma nova imagem disponível
  if (cam.available() == true) cam.read();
  
  // Este modo de desenho é mais rápido
  //set(40, 80, cam); 
   // Este modo de desenho permite redimendionar, transforma e tingir a imagem
   pushMatrix();
   translate(width,0);
   scale(-1,1);
  image(cam, 40, 80); // posição(x,y) do canto superior esquerdo do desenho da imagem
  popMatrix();
}
