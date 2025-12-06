import 'dart:convert';
import 'package:pawpal/myconfiguration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocode/geocode.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pawpal/views/homeScreen.dart';

class SubmitPet extends StatefulWidget {
  final User? user;
  const SubmitPet({super.key, required this.user});

  @override
  State<SubmitPet> createState() => _SubmitPetState();
}

class _SubmitPetState extends State<SubmitPet> {
  List<String> petType = [
    'Cat',
    'Dog',
    'Rabbit',
    'Other',
  ];
  List<String> submission_category = [
    'Adoption',
    'Donation Request',
    'Help/Rescue',
  ];

  TextEditingController petNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedPetType = 'Cat';
  String selectedCategory = 'Adoption';
  String selectedLocation = 'Alor Tajar';
  late Position myposition;
  late Coordinates coordinates;
  File? image;
  // Uint8List? webImage; // for web
  List<File> images = [];
  List<Uint8List> webImages = [];
  final int maxImages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 191, 165, 35),
        title: const
         Text('Submit Pet for Adoption',
        style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),
        
  ),
  centerTitle: true,
      ),
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter pet name',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 234, 213, 110),
                    ),
                    
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                      child: DropdownButtonFormField<String> (
                      decoration: InputDecoration(
                        labelText: 'Select Pet Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        filled: true,
                        fillColor: Color.fromARGB(255, 234, 213, 110),
                      ),
                      
                      items: petType.map((String petType) {
                        return DropdownMenuItem<String>(
                          value: petType,
                          child: Text(petType),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPetType = newValue!;
                          print(selectedPetType);
                        });
                      },
                      ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                      child : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Submission Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                          filled: true,
                          fillColor: Color.fromARGB(255, 234, 213, 110),
                        ),
                        items: submission_category.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            print(selectedCategory);
                          });
                        },
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                      filled: true,
                      fillColor: Color.fromARGB(255, 234, 213, 110),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                      maxLines: 3,
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        filled: true,
                        fillColor: Color.fromARGB(255, 234, 213, 110),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            myposition = await _determinePosition();
                            print(myposition.latitude);
                            print(myposition.longitude);
                            coordinates = Coordinates(
                              latitude: myposition.latitude,
                              longitude: myposition.longitude,
                            );

                            GeoCode geoCode = GeoCode();
                            try {
                              Address address = await geoCode.reverseGeocoding(
                                latitude: myposition.latitude,
                                longitude: myposition.longitude,
                              );
                              print(address.streetNumber);
                              print(address.city);
                              print(address.countryName);
                              addressController.text =
                                  "${address.streetNumber}, ${address.city}, ${address.countryName}";
                            } catch (e) {
                              print(e);
                            }
                            setState(() {});
                          },
                          icon: Icon(Icons.location_on),
                        ),

                      ),
                    ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded( // 1st image
                        child: GestureDetector(
                          onTap: () {
                            int currentCount = kIsWeb ? webImages.length : images.length;
                            if (currentCount >= maxImages) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Maximum $maxImages images allowed")),
                              );
                              return;
                            }
                            if (kIsWeb) {
                              openGallery();
                            } else {
                              pickimagedialog();
                            }
                          },
                          child: Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: (!kIsWeb && images.length > 0)
                                  ? DecorationImage(
                                      image: FileImage(images[0]),
                                      fit: BoxFit.cover,
                                    )
                                  : (kIsWeb && webImages.length > 0)
                                  ? DecorationImage(
                                      image: MemoryImage(webImages[0]),
                                      fit: BoxFit.cover,
                                    )
                                  : null, // No image for this slot
                            ),
                            // Show icon only if this specific slot has no image
                            child: ((!kIsWeb && images.length < 1) || (kIsWeb && webImages.length < 1))
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Tap to add image",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Expanded( // 2nd image
                        child: GestureDetector(
                          onTap: () {
                            int currentCount = kIsWeb ? webImages.length : images.length;
                            if (currentCount >= maxImages) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Maximum $maxImages images allowed")),
                              );
                              return;
                            }
                            if (kIsWeb) {
                              openGallery();
                            } else {
                              pickimagedialog();
                            }
                          },
                          child: Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: (!kIsWeb && images.length > 1)
                                  ? DecorationImage(
                                      image: FileImage(images[1]),
                                      fit: BoxFit.cover,
                                    )
                                  : (kIsWeb && webImages.length > 1)
                                  ? DecorationImage(
                                      image: MemoryImage(webImages[1]),
                                      fit: BoxFit.cover,
                                    )
                                  : null, // No image for this slot
                            ),
                            // Show icon only if this specific slot has no image
                            child: ((!kIsWeb && images.length < 2) || (kIsWeb && webImages.length < 2))
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Tap to add image",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Expanded( // 3rd image
                        child: GestureDetector(
                          onTap: () {
                            int currentCount = kIsWeb ? webImages.length : images.length;
                            if (currentCount >= maxImages) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Maximum $maxImages images allowed")),
                              );
                              return;
                            }
                            if (kIsWeb) {
                              openGallery();
                            } else {
                              pickimagedialog();
                            }
                          },
                          child: Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: (!kIsWeb && images.length > 2)
                                  ? DecorationImage(
                                      image: FileImage(images[2]),
                                      fit: BoxFit.cover,
                                    )
                                  : (kIsWeb && webImages.length > 2)
                                  ? DecorationImage(
                                      image: MemoryImage(webImages[2]),
                                      fit: BoxFit.cover,
                                    )
                                  : null, // No image for this slot
                            ),
                            // Show icon only if this specific slot has no image
                            child: ((!kIsWeb && images.length < 3) || (kIsWeb && webImages.length < 3))
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Tap to add image",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton( 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 191, 165, 35),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ), 
                        onPressed: () {
                          showSubmitDialog();
                        },
                        child: Text('Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),),
                      ),
                      SizedBox(width: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 191, 165, 35),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ), 
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  Homescreen(user: widget.user),
                            ),
                          );
                        },
                        child: Text('Cancel',
                        style: TextStyle(fontSize: 18, color: Colors.white),),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                ],
              )
            ),  
        ),
      )
    );
  }


  void pickimagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera() async {
    int currentCount = kIsWeb ? webImages.length : images.length;
  if (currentCount >= maxImages) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Maximum $maxImages images allowed")),
    );
    return;
  }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImages.add(await pickedFile.readAsBytes());// list need to add function
        setState(() {});
      } else {
        images.add(File(pickedFile.path));
        cropImage();
      }
    }
  }

  Future<void> openGallery() async {
    int currentCount = kIsWeb ? webImages.length : images.length;
    if (currentCount >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum $maxImages images allowed")),
      );
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImages.add(await pickedFile.readAsBytes());
        setState(() {});
      } else {
        images.add(File(pickedFile.path));
        cropImage(); // only for mobile
      }
    }
  }

  Future<void> cropImage() async {
    if (kIsWeb) return; // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile != null) {
      images.add(File(croppedFile.path)) ;
      image = null;
      setState(() {});
    }
  }

  void showSubmitDialog() {
    // Title validation
    if (petNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter name of the pet"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Image validation: mobile uses image, web uses webImage
    if (!kIsWeb && images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (kIsWeb && webImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please press location button to get address"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (descriptionController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description at least 10 charaters") ,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Service'),
          content: const Text('Are you sure you want to submit this pet service?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitService();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
}

void submitService() async {
    // String base64image = "";
    List<String> base64images = [];
    if (kIsWeb) {
      // base64image = base64Encode(webImage!);
      for (var webImages in webImages){
      base64images.add(base64Encode(webImages));
      }
    } else {
      // base64image = base64Encode(image!.readAsBytesSync());
      for (var images in images){
      base64images.add(base64Encode(images.readAsBytesSync()));
      }
    }
    String base64image = base64images.join('|||');

    String pet_name = petNameController.text.trim();
    String description = descriptionController.text.trim();

    http
        .post(
          Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/submit_pet.php'),
          body: {
            'user_id': widget.user?.userId,
            'pet_name': pet_name,
            'pet_type': selectedPetType,
            'category': selectedCategory,
            'description': description,
            'image_paths': base64image,
            'lat': coordinates.latitude.toString(),
            'lng': coordinates.longitude.toString(),
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Service submitted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Homescreen(user: widget.user),
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return await Geolocator.getCurrentPosition();
  }
}

