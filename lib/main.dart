import 'package:flutter/material.dart';
import 'package:flutter_trbajo_final_pro_movil/src/pages/home_page.dart';
import 'package:flutter_trbajo_final_pro_movil/src/pages/pelicula_detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //// eso es ta listo
  // L
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas-Cinemapedia',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle(),
      },
    );
  }
}
 // prube de que todo corre bien