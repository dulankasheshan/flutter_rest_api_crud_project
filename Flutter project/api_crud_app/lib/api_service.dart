import 'package:http/http.dart' as http;
import 'dart:convert';

import 'DataModel.dart';


class ApiService{

  final apiUrl = 'https://*****/*****'; //api url

  late List<DataModel> dataList = [];

  //Get data
  Future<void> fetchData() async{
    final response = await http.get(Uri.parse('$apiUrl/get'));
    try{

      if(response.statusCode == 200){

        final List<dynamic> data = jsonDecode(response.body);
        dataList = data.map((json) => DataModel.fromJson(json)).toList();

      }else{
        Future.error(('Something error, Status Code: ${response.statusCode}'));
      }

    }catch(e){
      Future.error(('Something error, $e'));
    }
  }

  // Create a new post
  Future<void> createPost(String title, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/post'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'content': content,
        }),
      );
      if (response.statusCode == 200) {
        print('Post created successfully');
        fetchData(); // Refresh posts after creation
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  // Update an existing post
  Future<void> updatePost(String id, String title, String content) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/put'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': id,
          'title': title,
          'content': content,
        }),
      );
      if (response.statusCode == 200) {
        print('Post updated successfully');
        fetchData(); // Refresh posts after update
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  // Delete a post
  Future<void> deletePost(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/delete'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'id': id.toString(),
        },
      );
      if (response.statusCode == 200) {
        print('Post deleted successfully');
        fetchData(); // Refresh posts after deletion
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

}