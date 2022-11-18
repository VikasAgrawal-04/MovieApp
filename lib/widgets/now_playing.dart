import 'package:flutter/material.dart';
import 'package:movie/bloc/get_now_playing_bloc.dart';
import 'package:movie/bloc/get_video_bloc.dart';
import 'package:movie/models/movie_response.dart';
import 'package:page_indicator/page_indicator.dart';
import '../models/movie.dart';
import 'now_playing_video.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  NowPlayingState createState() => NowPlayingState();
}

class NowPlayingState extends State<NowPlaying> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    nowPlayingMoviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
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
    return Center(child: Text("Error occurred: $error"));
  }

  Widget _buildHomeWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 250.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Colors.grey,
          indicatorSelectorColor: Colors.amber,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/original/${movies[index].backPoster}"),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: const [
                              0.0,
                              0.9
                            ],
                            colors: [
                              Colors.white10.withOpacity(0.3),
                              Colors.black.withOpacity(0.0),
                            ]),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: IconButton(
                        color: Colors.amber,
                        onPressed: () async {
                          var x = await movieVideoBloc.getMoviesVideos(
                              id: movies[index].id, movie: true);
                          if(!mounted) return;
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NowPlayingVideo(keyVal: x),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.play_circle_fill,
                          size: 60.0,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 25.0,
                      left: 15.0,
                      child: Text(
                        movies[index].title,
                        style: const TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
