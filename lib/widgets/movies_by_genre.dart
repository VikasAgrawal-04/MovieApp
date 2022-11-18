import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_movies_byGenre_bloc.dart';
import 'package:movie/models/movie_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:movie/screens/detail_screen.dart';
import '../models/movie.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;
  const GenreMovies({Key? key, required this.genreId}) : super(key: key);

  @override
  State<GenreMovies> createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
  @override
  void initState() {
    moviesByGenreBloc.getMoviesByGenre(widget.genreId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildGenreMovieWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: SizedBox(
        height: 25.0,
        width: 25.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4.0,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text("Error occurred: $error"),
    );
  }

  Widget _buildGenreMovieWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Text(
          "No More Movies",
          style: TextStyle(color: Colors.black45),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
            itemCount: movies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>MovieDetailScreen(movie: movies[index])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                              width: 120,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2.0),
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200/${movies[index].poster}"),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 130,
                        child: Text(
                          movies[index].title,
                          maxLines: 2,
                          style: const TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (movies[index].rating / 2)
                                .round()
                                .toDouble()
                                .toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 2.0),
                          RatingBar(
                              itemSize: 10.0,
                              ratingWidget: RatingWidget(
                                full: const Icon(
                                  EvaIcons.star,
                                  color: Colors.amber,
                                ),
                                half: const Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                ),
                                empty: Icon(null),
                              ),
                              initialRating: movies[index].rating / 2.round(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              onRatingUpdate: (rating) {
                                print(rating);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }
}
