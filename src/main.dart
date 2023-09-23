import "dart:io";


String checkPositivoNegativo(int X){
  late String resultado;
  ((X>0 && X!=0)?resultado = "Positivo" : resultado = "Negativo");
  if(X==0) {resultado = "Cero";}
  return resultado;
}

void Menu(){
  late int numero;
  print("_________________________");
  print("|                       |");
  print("|    Comprobar Positivo |");
  print("|      o Negativo !     |");
  print("|_______________________|");
  print("|                       |");
  print("   Ingresa tu Numero : ");
  numero = int.parse(stdin.readLineSync()!);
  print("_________________________");
  print("|                       |");
  print("  El Numero es ${checkPositivoNegativo(numero)}");
  print("|_______________________|");
}
void main(){

  Menu();

}