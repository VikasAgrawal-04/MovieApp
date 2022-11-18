import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_similar_bloc.dart';
import 'package:movie/models/movie_response.dart';

import '../models/movie.dart';

class SimilarMovies extends StatefulWidget {
  final int id;
  const SimilarMovies({Key? key, required this.id}) : super(key: key);

  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  @override
  void initState() {
    super.initState();
    similarMovieBloc.getSimilarMovie(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    similarMovieBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "CASTS",
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w800,
                fontSize: 15.0),
          ),
        ),
        const SizedBox(height: 5),
        StreamBuilder<MovieResponse>(
          stream: similarMovieBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildSimilarMoviesWidget(snapshot.data!);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ],
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

  Widget _buildSimilarMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: Text(
            "No More Movies",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Container(
        height: 270,
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: movies[index].id,
                  child: Container(
                    width: 120.0,
                    height: 180.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2.0)),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w200/${movies[index].poster}")),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: 100,
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
                const SizedBox(
                  height: 5.0,
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
                          empty: const Icon(null),
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
            );
          },
        ),
      );
    }
  }
}
