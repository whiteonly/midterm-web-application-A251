import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/petsubmittion.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/views/homeScreen.dart';


class Mainscreen extends StatefulWidget {
  final User? user;
  const Mainscreen({super.key, required this.user});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<Petsubmittion> listSubmissions = [];
  String status = "Loading...";
  late double screenWidth, screenHeight;
  int numofpage = 1;// total number of pages
  int curpage = 1;// current page
  int numofresult = 0;// total number of results
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadServices('');
  }
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 1000) {
      screenWidth = 1000;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 165, 35),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 161, 139, 29),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Submissions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // search button
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearchDialog();
            },
          ),
          // refresh button
          IconButton(
            onPressed: () {
              loadServices('');
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
          // home button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homescreen(user: widget.user),),
              );
            },
            icon: Icon(Icons.meeting_room, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              listSubmissions.isEmpty
                    // if no submissions - it will show status message
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.find_in_page_outlined, size: 64,color: Color.fromARGB(255, 161, 139, 29),),
                            SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 161, 139, 29),
                                fontWeight: FontWeight.w500,),
                            ),
                          ],
                        ),
                      ),
                    )
                    // if there are submissions - it will show them in listviews
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listSubmissions.length,
                        itemBuilder: (BuildContext context, int index) {
                          String imgPaths = listSubmissions[index].image_paths ?? "";
                          List<String> imgs = imgPaths.split(",");// split image paths received into list
                          String firstImage;
                          if (imgs.isNotEmpty && imgs[0].isNotEmpty) {// check if first image path is not empty
                            firstImage = imgs[0].trim(); // trim() removes any spaces
                            // Extract filename if it's a full path
                            firstImage = firstImage.split('\\').last.split('/').last;// handles both Windows and Unix-style paths
                          } else {// if first image path is empty
                            firstImage = "default.png";
                          }

                          // Build and log image URL (encode filename to be safe)
                          final imageUrl = '${myconfiguration.baseUrl}/pawpal/assets/uploads/${Uri.encodeComponent(firstImage)}';
                          // Print the URL to help debugging (check console)
                          // ignore: avoid_print
                          print('Image URL: $imageUrl');

                          return Card(// each submission displayed in a card
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: screenWidth * 0.28, // more responsive
                                      height:screenWidth *0.22, // balanced aspect ratio
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 240, 235, 210),
                                        border: Border.all(
                                          color: Color.fromARGB(255, 191, 165, 35),
                                          width: 2,
                                        ),
                                      ),

                                      child: Image.network( // load image from network
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                'Failed to load image',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(// details column from each submission
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Name text
                                        Text(
                                          listSubmissions[index].pet_name
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 161, 139, 29),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 4),

                                        // type text
                                        Text(
                                          listSubmissions[index].pet_type
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        // category text
                                        Text(
                                          listSubmissions[index].category
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 161, 139, 29),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),

                                        // description text
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 240, 235, 210),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            listSubmissions[index].description
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(255, 120, 103, 21),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
            ],
          ),
        ),
      ),    
      );

    
  }

    void loadServices(String searchQuery) {
    // TODO: implement loadServices
    listSubmissions.clear();
    setState(() {
      status = "Loading...";
    });
    http
        .get(
          Uri.parse(
            '${myconfiguration.baseUrl}/pawpal/pawpal/api/get_my_pets.php?search=$searchQuery&curpage=$curpage',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            log(jsonResponse.toString());
            if (jsonResponse['status'] == 'success' &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // has data → load to list
              listSubmissions.clear();
              for (var item in jsonResponse['data']) {
                listSubmissions.add(Petsubmittion.fromJson(item));
              }
              numofpage = int.parse(jsonResponse['numofpage'].toString());
              numofresult = int.parse(
                jsonResponse['numberofresult'].toString(),
              );
              print(numofpage);
              print(numofresult);
              setState(() {
                status = "";
              });
            } else {
              // success but EMPTY data
              setState(() {
                listSubmissions.clear();
                status = "Not Available";
              });
              if (mounted){
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("No submissions yet"),
                  content: const Text("No service found. Please try again later."),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              
              });
              }
            }
          } else {
            // request failed
            setState(() {
              listSubmissions.clear();
              status = "Failed to load services";
            });
          }
        }).catchError((error) {
          // request failed
          print('Error loading services: $error');
          setState(() {
          status = "Error: $error";
          });
        });
  }
  void showSearchDialog() {// show search dialog for submission search
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Enter search query'),
          ),
          actions: [
            //cancel button 
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            //search buttons
            TextButton(
              child: Text('Search'),
              onPressed: () {
                String search = searchController.text;
                if (search.isEmpty) {
                  loadServices('');
                } else {
                  loadServices(search);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}