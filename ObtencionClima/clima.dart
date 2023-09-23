import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';

/// clearScreen()
//Funcion para limpiar la pantalla segun el sistema operativo
void clearScreen() {
  if (Platform.isWindows) {
    // Si el sistema operativo es Windows, ejecutar el comando 'cls'
    stdout.write('\x1B[2J\x1B[0;0H');
  } else {
    // Si el sistema operativo es Unix o Mac, ejecutar el comando 'clear'
    stdout.write('\x1B[2J\x1B[3J\x1B[1;1H');
  }
}

void main() async {
  //creamos una variable para el ciclo for
  bool valor = false;
  //ciclo for para el menu, que se detendra al retornar el valor como 'true'
  for( ; valor == false; ) {

  // Clave de la API para acceder a la información del clima en la ciudad seleccionada.
  //API de OpenWeatherMap.
  //api key: 775bcc2c8a820947d590b91a3dfd815d de (https://openweathermap.org/)
  final apiKey = "775bcc2c8a820947d590b91a3dfd815d";
  clearScreen();
  print('_______________________________________________________');
  print("|   Bienvenido al servicio de pronóstico de clima.    |");
  print('|                                                     |');
  print("| Selecciona una ubicación:                           |");
  print('|                                                     |');
  print("| 1 - Guadalajara                                     |");
  print("| 2 - Zapopan                                         |");
  print("| 3 - Tlajomulco                                      |");
  print("| 4 - Tlaquepaque                                     |");
  print("| 5 - Tonalá                                          |");
  print("| 0 - Salida                                          |");
  print('|_____________________________________________________|');
  print("\n\n");
  stdout.write("Opcion: ");
  // Obtén la ubicación seleccionada del usuario.
  int seleccion = int.parse(stdin.readLineSync()!);
  clearScreen();
  // Define las coordenadas de las ubicaciones.
  Map<int, String> ubicaciones = {
    1: "Guadalajara",
    2: "Zapopan",
    3: "Tlajomulco",
    4: "Tlaquepaque",
    5: "Tonalá"
  };

  // Verifica que la selección sea válida.
  if (ubicaciones.containsKey(seleccion)) {
    final ciudad = ubicaciones[seleccion];

    //Se llama a la funcion para obtener el clima actual
    await obtenerClima(apiKey, ciudad!);
    print('Presiona enter para continuar...');
    stdin.readLineSync();
  } 
  //Condicion para salir
  else if(seleccion==0){
    clearScreen();
        print('Seguro que deseas salir ?');
        stdout.write("\n\n S o N_: ");
        String respuesta = stdin.readLineSync()!;
        //condicion para confirmar salida del programa
        if(respuesta == 'S' || respuesta == 's'){
          valor = true;
          clearScreen();
          exit(0);
        }
        else{
            clearScreen();
            print("Opcion no valida");
            print('\n\n\n\n\n Presiona enter para continuar...');
            stdin.readLineSync()!;
          }
  }
  else {
    clearScreen();
    print("Selección no válida.\n\nPor favor, elige una ubicación válida.");
    print('Presiona enter para continuar...');
    stdin.readLineSync()!;
    clearScreen();
  }//fin del else
}//fin del for
}//Fin del main

//Funcion para Obtener el clima actual
Future<void>  obtenerClima(String apiKey, String ciudad) async {
  final url =
      'https://api.openweathermap.org/data/2.5/weather?q=$ciudad&appid=$apiKey&units=metric&lang=es';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final temperaturaActual = data['main']['temp'];
    final descripcionClima = data['weather'][0]['description'];

    print('_____________________________________________________');
    print('|                                                 ');
    print("| El clima actual en $ciudad es:                  ");
    print("| Temperatura: $temperaturaActual°C               ");
    print("| Descripción: $descripcionClima                  ");
    print('|____________________________________________________');

    // Obtener el pronóstico para el día siguiente.
    await obtenerPronostico(apiKey, ciudad);
  } else {
    clearScreen();
    print("Hubo un error al obtener el clima. Inténtalo de nuevo más tarde.");
    print('Presiona enter para continuar...');
    stdin.readLineSync()!;
    clearScreen();
  }
}


//Funcion par obtener el pronostico para el día siguiente
Future<void>  obtenerPronostico(String apiKey, String ciudad) async {
  final url =
      'https://api.openweathermap.org/data/2.5/forecast?q=$ciudad&appid=$apiKey&units=metric&lang=es';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final pronosticoDiaSiguiente = data['list'][8]['weather'][0]['description'];

    print('_____________________________________________________');
    print('|                                                  ');
    print("| El pronóstico para el día siguiente en $ciudad:  ");
    print("| Descripción: $pronosticoDiaSiguiente             ");
    print('|____________________________________________________\n\n');
  } else {
    clearScreen();
    print("Hubo un error al obtener el pronóstico. Inténtalo de nuevo más tarde.");
    print('Presiona enter para continuar...');
    stdin.readLineSync()!;
    clearScreen();
  }
}