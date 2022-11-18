import 'package:flutter/material.dart';
import 'package:movie/bloc/get_casts_bloc.dart';

import '../models/cast.dart';
import '../models/cast_response.dart';

class Casts extends StatefulWidget {
  final int id;
  const Casts({Key? key, required this.id}) : super(key: key);

  @override
  State<Casts> createState() => _CastsState();
}

class _CastsState extends State<Casts> {
  @override
  void initState() {
    super.initState();
    castsBloc.getCasts(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc.drainStream();
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
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildCastWidget(snapshot.data!);
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

  Widget _buildCastWidget(CastResponse data) {
    List<Cast> casts = data.casts;
    return Container(
      height: 150,
      padding: const EdgeInsets.only(left: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: casts.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: casts[index].id,
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w300/${casts[index].img}")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    casts[index].name,
                    maxLines: 2,
                    style: const TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.0),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    casts[index].character,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        height: 1.4,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 7.0),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
