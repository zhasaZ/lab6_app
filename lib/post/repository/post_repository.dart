import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/get_posts.dart';
import '../bloc/post_bloc.dart';

class PostRepository {
  final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<void> getPosts(GetPostEvent event, Emitter<PostState> emit) async {
    emit(LoadingPostState());
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode != 200) {
        emit(FailurePostState());
        return;
      }
      final List<dynamic> jsonList = jsonDecode(response.body);
      final getPosts = jsonList.map((json) => Posts.fromJson(json)).toList();
      emit(FetchedPostsState(getPosts));
    } catch (e) {
      emit(FailurePostState());
    }
  }
}
