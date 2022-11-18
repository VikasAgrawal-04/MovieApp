import 'package:flutter/material.dart';
import 'package:movie/bloc/get_genres_bloc.dart';
import 'package:movie/bloc/get_movies_byGenre_bloc.dart';
import 'package:movie/widgets/movies_by_genre.dart';
import '../models/genre.dart';
import '../models/genre_response.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  void initState() {
    super.initState();
    genresBloc.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: genresBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
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
        });
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4.0,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text("Error Occurred$error"),
    );
  }

  Widget _buildHomeWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "No More Genre!",
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      );
    } else {
      return GenreList(genres: genres);
    }
  }
}

class GenreList extends StatefulWidget {
  final List<Genre> genres;
  const GenreList({Key? key, required this.genres}) : super(key: key);

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.genres.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc.drainStream();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: DefaultTabController(
        length: widget.genres.length,
        child: Scaffold(
          backgroundColor: Colors.white10,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight((50.0)),
            child: AppBar(
              backgroundColor: Colors.white10,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.amber,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                labelColor: Colors.white,
                tabs: widget.genres.map((Genre genre) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.genres.map((Genre genre) {
              return GenreMovies(
                genreId: genre.id,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
