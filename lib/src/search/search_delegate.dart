import 'package:flutter/material.dart';
import 'package:flutter_trbajo_final_pro_movil/src/models/pelicula_model.dart';
import 'package:flutter_trbajo_final_pro_movil/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final PeliculasProvider peliculasProvider = PeliculasProvider();

  final List<String> peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitán América',
    'Superman',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
  ];

  final List<String> peliculasRecientes = ['Spiderman', 'Capitán América'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del AppBar (ej. botón para limpiar la búsqueda)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Ícono a la izquierda del AppBar (para cerrar la búsqueda)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Muestra los resultados cuando el usuario selecciona una opción
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Center(
          child: Text(
            seleccion,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias mientras el usuario escribe en la barra de búsqueda
    if (query.isEmpty) {
      return ListView(); // Evita problemas de renderizado devolviendo una lista vacía
    }

    return FutureBuilder<List<Pelicula>>(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error al cargar los datos. Inténtalo de nuevo.'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron resultados'));
        }

        final List<Pelicula> peliculas = snapshot.data!;

        return ListView.builder(
          itemCount: peliculas.length,
          itemBuilder: (context, index) {
            final pelicula = peliculas[index];

            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
              onTap: () {
                close(context, null);
                // Verifica que uniqueId existe en el modelo
                // pelicula.uniqueId = ''; // Si no existe, comenta esta línea o corrige el modelo.
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
            );
          },
        );
      },
    );
  }
}
