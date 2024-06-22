import 'package:flutter/material.dart';

import 'api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ApiService apiService = ApiService();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
          future: apiService.fetchData(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }else{
              if(snapshot.hasError){
                return const Center(
                  child: Text('Something Error'),
                );
              }else{
                return ListView.builder(
                  itemCount: apiService.dataList.length,
                    itemBuilder: (context, int index){
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade200
                        ),
                        child: ListTile(
                          title: Text(apiService.dataList[index].title),
                          subtitle: Text(apiService.dataList[index].content),
                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'edit') {

                                _updateData(apiService.dataList[index].id,
                                  apiService.dataList[index].title,
                                    apiService.dataList[index].content
                                    );


                              } else if (value == 'delete') {
                                apiService.deletePost(apiService.dataList[index].id);
                               // _deletePost(post.id); // Call delete function
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  child: Text('Edit'),
                                  value: 'edit',
                                ),
                                const PopupMenuItem(
                                  child: Text('Delete'),
                                  value: 'delete',
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    );
                    }
                );
              }
            }
          },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addNewData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //new post
  void _addNewData() {
    String title = ''; // Initialize variables to hold input values
    String content = '';

    // Controllers for text fields
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  content = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                apiService.createPost(titleController.text, contentController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  //update
  void _updateData(id, String updateTitle, String updateContent) {
    String title = updateTitle; // Initialize variables to hold input values
    String content = updateContent;

    // Controllers for text fields
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    titleController.text = updateTitle;
    contentController.text = updateContent;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Existing Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                onChanged: (value) {
                  content = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                apiService.updatePost(id, titleController.text, contentController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
