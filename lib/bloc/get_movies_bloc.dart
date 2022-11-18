import 'package:movie/repository/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/movie_response.dart';


class MoviesListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
  BehaviorSubject<MovieResponse>();

  getMovies({bool searchList = false}) async {
    MovieResponse response = await _repository.getMovies();
    if(searchList== true){
      var movieTitle = response.movies.map((e) => e.title).toList();
      return movieTitle;
    }
    else{
      _subject.sink.add(response);
    }

  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

}
final moviesBloc = MoviesListBloc();