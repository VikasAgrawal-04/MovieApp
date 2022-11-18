import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/get_movies_bloc.dart';
import 'package:movie/cubit/internet_cubit/cubit_internet.dart';
import 'package:movie/cubit/internet_cubit/internet_states.dart';
import 'package:movie/widgets/now_playing.dart';

import '../widgets/genres.dart';
import '../widgets/best_movies.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> movieList =[];

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  void getMovies() async {
    var result = await moviesBloc.getMovies(searchList: true);
    movieList.addAll(result);
    print(movieList);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Movie App"),
        leading: const Icon(
          EvaIcons.menu2Outline,
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate(movieList));
              },
              icon: const Icon(
                EvaIcons.searchOutline,
                color: Colors.white,
              ))
        ],
      ),
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context,state){
          if (state is InternetStateActive) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Internet Connected"),
              backgroundColor: Colors.green,
            ));
          } else if (state is InternetStateInactive) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Internet Unavailable"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Loading..."),
              ),
            );
          }
        },
        builder: (context, state) {
          if(state is InternetStateActive){
            return SingleChildScrollView(
              child: Column(
                children: [
                  NowPlaying(),
                  GenreScreen(),
                  BestMovies(),
                ],
              ),
            );
          }
          else{
            return const Scaffold(
              backgroundColor: Colors.black12,
              body: Center(
              child: Text("INTERNET IS UNAVAILABLEf",
              ),
              ),
            );
          }
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate{
  List<String> suggestion;
  MySearchDelegate(this.suggestion);
  @override

  List<Widget>? buildActions(BuildContext context) =>[
    IconButton(onPressed: (){
      query = "";
    }, icon: const Icon(Icons.cancel),),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>IconButton(onPressed: (){
    close(context, null);
  }, icon: const Icon(Icons.arrow_back_ios_outlined));

  @override
  Widget buildResults(BuildContext context) {
    return Center(child:Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = suggestion.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      if(result.contains(input)){
        return result.contains(input);
      }
      else{
        return false;
      }
    }).toList();
    return ListView.builder(
      itemCount: suggestions.length,
        itemBuilder: (context, index){
        return ListTile(
          title: query.isEmpty? null : Text(suggestions[index]),
          onTap: (){
            query = suggestions[index];
          },
        );
        });
  }
}
