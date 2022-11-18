import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_movies_bloc.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/movie_response.dart';

import '../screens/detail_screen.dart';

class BestMovies extends StatefulWidget {
  const BestMovies({Key? key}) : super(key: key);

  @override
  State<BestMovies> createState() => _BestMoviesState();
}

class _BestMoviesState extends State<BestMovies> {
  @override
  void initState() {
    super.initState();
    moviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 15),
          child: Text(
            "Best Popular Movies".toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieResponse>(
          stream: moviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildHomeWidget(snapshot.data!);
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

  Widget _buildHomeWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "No Movies",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 250.0,
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 12.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>MovieDetailScreen(movie: movies[index])));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(2.0),
                          ),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w200/${movies[index].poster}"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movies[index].title,
                      maxLines: 2,
                      style: const TextStyle(
                        height: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
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
                        SizedBox(width: 2.0),
                        RatingBar(
                            itemSize: 10.0,
                            ratingWidget: RatingWidget(
                              full: const Icon(
                                Icons.star,
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
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
