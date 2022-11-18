import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/bloc/get_video_bloc.dart';
import 'package:movie/models/movie.dart';
import 'package:movie/models/video.dart';
import 'package:movie/models/video_response.dart';
import 'package:movie/screens/video_player_screen.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/movie_casts.dart';
import '../widgets/movie_info.dart';
import '../widgets/similiar_movies.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);
  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    movieVideoBloc.getMoviesVideos(id: widget.movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideoBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: const FloatingPosition(right: 30.0),
          floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideoBloc.subject.stream,
              builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.error.isNotEmpty) {
                    return _buildErrorWidget(snapshot.data!.error);
                  }
                  return _buildVideoWidget(snapshot.data!);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error.toString());
                } else {
                  return _buildLoadingWidget();
                }
              }),
          expandedHeight: 200,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white12,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.movie.title.length > 40
                      ? "${widget.movie.title.substring(0, 37)}..."
                      : widget.movie.title,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/${widget.movie.backPoster}"))),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: const [.1, .9],
                          colors: [
                            Colors.black.withOpacity(.7),
                            Colors.black.withOpacity(.0)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          (widget.movie.rating / 2)
                              .round()
                              .toDouble()
                              .toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5.0),
                        RatingBar(
                            itemSize: 12.0,
                            ratingWidget: RatingWidget(
                              full: const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              half: const Icon(
                                Icons.star_half,
                                color: Colors.amber,
                              ),
                              empty: const Icon(null),
                            ),
                            initialRating: widget.movie.rating / 2.round(),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            onRatingUpdate: (rating) {}),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      "OVERVIEW",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w800,
                          fontSize: 15.0),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.movie.overview,
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.white, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MovieInfo(id: widget.movie.id),
                  Casts(id: widget.movie.id),
                  SimilarMovies(id: widget.movie.id)
                ]),
              ),
            )
          ],
        );
      }),
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

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Colors.amber,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              controller: YoutubePlayerController(
                initialVideoId: videos[0].key,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                ),
              ),
            ),
          ),
        );
      },
      child: const Icon(Icons.play_arrow_rounded),
    );
  }
}
