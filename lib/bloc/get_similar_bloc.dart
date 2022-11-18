import 'package:flutter/material.dart';
import 'package:movie/models/movie_response.dart';
import 'package:movie/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SimilarMovieBloc{

  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  getSimilarMovie(int id) async {
    MovieResponse response = await _repository.getSimilarMovies(id);
    _subject.sink.add(response);
  }

  void drainStream() async {
    await _subject.drain();
  }

  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}
final similarMovieBloc = SimilarMovieBloc();
