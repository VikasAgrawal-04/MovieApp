import 'package:movie/models/movie_details.dart';

class MovieDetailResponse{
  final MovieDetail movieDetail;
  final String error;


  MovieDetailResponse(this.movieDetail,this.error);

  MovieDetailResponse.fromJson(Map<String, dynamic>json):
        movieDetail = MovieDetail.fromJson(json),
        error = "";


  MovieDetailResponse.withError(String errorValue)
      : movieDetail = MovieDetail(id: null,adult: null, budget: null,genres: null, releaseDate: "",runtime: null),
        error = errorValue;
}