import 'package:flutter/material.dart';
import 'package:flutter_trbajo_final_pro_movil/src/providers/peliculas_provider.dart';
import 'package:flutter_trbajo_final_pro_movil/src/search/search_delegate.dart';
import 'package:flutter_trbajo_final_pro_movil/src/widgets/card_swiper_widget.dart';
import 'package:flutter_trbajo_final_pro_movil/src/widgets/movie_horizontal.dart';
import 'package:flutter_trbajo_final_pro_movil/src/models/pelicula_model.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final PeliculasProvider peliculasProvider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.local_movies, size: 28),
            SizedBox(width: 8),
            Text('Cinemapedia',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 207, 202, 218),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 82, 105, 157),
              Color.fromARGB(255, 114, 99, 99)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Películas en cines',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Explora los últimos estrenos y descubre las películas más populares.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'Montserrat'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(height: 400, child: _swiperTarjetas()),

                const SizedBox(
                    height: 20), // Espacio extra antes de "Populares"
                _footer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder<List<Pelicula>>(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 400.0,
            child:
                Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 400.0,
            child: Center(
                child: Text("Error al cargar datos",
                    style: TextStyle(color: Colors.white))),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 400.0,
            child: Center(
                child: Text("No hay películas disponibles",
                    style: TextStyle(color: Colors.white))),
          );
        } else {
          return CardSwiper(peliculas: snapshot.data ?? []);
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10.0),
            child: Text(
              'Populares',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            // Limita la altura para evitar el desbordamiento
            height: 200, // Ajusta según sea necesario
            child: StreamBuilder<List<Pelicula>>(
              stream: peliculasProvider.popularesStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Pelicula>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error al cargar datos",
                          style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No hay películas populares",
                          style: TextStyle(color: Colors.white)));
                } else {
                  return MovieHorizontal(
                    peliculas: snapshot.data ?? [],
                    siguientePagina: peliculasProvider.getPopulares,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
