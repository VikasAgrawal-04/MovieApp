import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie/models/video_response.dart';
import 'package:movie/repository/repository.dart';
import 'package:rxdart/rxdart.dart';


class VideoBloc{

  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<VideoResponse> _subject = BehaviorSubject<VideoResponse>();


  getMoviesVideos({required int id, bool movie = false}) async{
    VideoResponse response = await _repository.getMoviesVideos(id);
    if(movie == false){
    _subject.sink.add(response);}
    else{
      String keyValue =(response.videos[0].key);
      print(keyValue);
      return keyValue;
    }

  }

  void drainStream() async{
    await _subject.drain();
  }

  @mustCallSuper
  void dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<VideoResponse> get subject =>_subject;
}
final movieVideoBloc = VideoBloc();