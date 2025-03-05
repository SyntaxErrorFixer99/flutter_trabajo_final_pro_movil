import 'package:flutter/material.dart';
import 'package:flutter_trbajo_final_pro_movil/src/models/pelicula_model.dart';

class MovieHorizontal extends StatefulWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina; // YA TERMINADO

  const MovieHorizontal({
    Key? key,
    required this.peliculas,
    required this.siguientePagina,
  }) : super(key: key);

  @override
  _MovieHorizontalState createState() => _MovieHorizontalState();
}

class _MovieHorizontalState extends State<MovieHorizontal> {
  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.35,
  );

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.position.pixels >=
        _pageController.position.maxScrollExtent - 200) {
      widget.siguientePagina();
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.0,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.peliculas.length,
        itemBuilder: (context, i) => _tarjeta(context, widget.peliculas[i]),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-poster';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage(
                  placeholder: const AssetImage(
                      'assets/loading.gif'), // Imagen de carga temporal
                  image: NetworkImage(pelicula.getPosterImg()),
                  fit: BoxFit.cover,
                  height: 140.0,
                  width: 100.0,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/img/no-image.jpg',
                      fit: BoxFit.cover,
                      height: 140.0,
                      width: 100.0,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              width: 100.0,
              child: Text(
                pelicula.title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
