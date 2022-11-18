import 'package:flutter/material.dart';
import 'package:movie/bloc/get_movie_detail_bloc.dart';
import 'package:movie/models/movie_detail_response.dart';
import 'package:movie/models/movie_details.dart';

class MovieInfo extends StatefulWidget {
  final int id;
  const MovieInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  @override
  void initState() {
    super.initState();
    movieDetailBloc.getMovieDetails(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieDetailBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
        stream: movieDetailBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieDetailResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.error.isNotEmpty) {
              return _buildErrorWidget(snapshot.data!.error);
            }
            return _buildMovieDetailsWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else {
            return _buildLoadingWidget();
          }
        });
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

  Widget _buildMovieDetailsWidget(MovieDetailResponse data) {
    MovieDetail detail = data.movieDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "BUDGET",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "${detail.budget}\$",
                      style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "DURATION",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text("${detail.runtime}min",
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "RELEASE DATE",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(detail.releaseDate!,
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0))
                  ],
                ),
              ],
            )),
        const SizedBox(height: 10.0),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "GENRES",
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w800,
                fontSize: 15.0),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 30.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: detail.genres!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(width: 1.0, color: Colors.white),
                    ),
                    child: Text(
                      detail.genres![index].name,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.0
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
