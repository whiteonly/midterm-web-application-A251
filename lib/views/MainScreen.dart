import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:pawpal/models/adoption_request.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/petsubmittion.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/views/DonationPage.dart';
import 'package:pawpal/views/SubmitPetScreen%20.dart';
import 'package:pawpal/views/loginScreen.dart';
import 'package:url_launcher/url_launcher.dart';


class Mainscreen extends StatefulWidget {
  final User? user;
  const Mainscreen({super.key, required this.user});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<AdoptionRequest> adoptionRequests = [];
  List<Petsubmittion> listSubmissions = [];
  List<Petsubmittion> allSubmissions = [];
  List<String> petTypes = ['All'];
  String selectedPetType = 'All';
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  
  @override
  void initState() {
    super.initState();
    loadServices('');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 1000) {
      screenWidth = 1000;
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFA18B1D),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Builder(
            builder: (innerContext) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();   // safe
              },
            ),
            ),
            Icon(Icons.pets, size: 28),
            SizedBox(width: 12),
            Text(
              'Submissions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          
          // Filter button (opens dialog)
          IconButton(
            icon: Icon(Icons.filter_list, size: 26),
            onPressed: () {
              showFilterDialog();
            },
            tooltip: 'Filter by pet type',
          ),
          // Show active filter label
          if (selectedPetType != 'All')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(selectedPetType, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          IconButton(
            icon: Icon(Icons.search, size: 26),
            onPressed: () {
              showSearchDialog();
            },
            tooltip: 'Search',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedPetType = 'All';
              });
              loadServices('');
            },
            icon: Icon(Icons.refresh, size: 26),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => loginScreen(),
                ),
              );
            },
            icon: Icon(Icons.login, size: 26),
            tooltip: 'Login',
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              // Header with result count
              if (listSubmissions.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$numofresult ${numofresult == 1 ? 'Submission' : 'Submissions'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA18B1D),
                        ),
                      ),
                      Text(
                        'Page $curpage of $numofpage',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

              listSubmissions.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.pets,
                                size: 80,
                                color: Color(0xFFA18B1D),
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFA18B1D),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Your pet submissions will appear here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                    child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: listSubmissions.length,
                    itemBuilder: (BuildContext context, int index) {
                      String imgPaths = listSubmissions[index].image_paths ?? "";
                      List<String> imgs = imgPaths.split(",");
                      String firstImage;
                      if (imgs.isNotEmpty && imgs[0].isNotEmpty) {
                        firstImage = imgs[0].trim();
                        firstImage = firstImage.replaceAll('\\', '/').split('/').last;
                      } else {
                        firstImage = "default.png";
                      }

                      // Debug logging
                      print('DEBUG: image_paths from DB = $imgPaths');
                      print('DEBUG: firstImage after extraction = $firstImage');

                      final imageUrl = '${myconfiguration.baseUrl}/pawpal/assets/uploads/pet_${listSubmissions[index].pet_id}_1.png';
                      print('Image URL: $imageUrl');

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.only(bottom: 12),
                        clipBehavior: Clip.antiAlias, // Ensures children respect the border radius
                        child: InkWell(
                          onTap: () {
                            // Add your click handler here
                            print('Card tapped: ${listSubmissions[index].pet_name}');
                            showDetailsDialog(index);
                            // Example: Navigate to detail page
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PetDetailScreen(
                            //       petData: listSubmissions[index],
                            //     ),
                            //   ),
                            // );
                          },
                          borderRadius: BorderRadius.circular(16),
                          splashColor: Color(0xFFA18B1D).withOpacity(0.1),
                          highlightColor: Color(0xFFA18B1D).withOpacity(0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Section
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: screenWidth * 0.2,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFBFA523).withOpacity(0.2),
                                          Color(0xFFF0EBD2).withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          print('Image loaded successfully: $imageUrl');
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFA18B1D),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Image load FAILED for $imageUrl, Error: $error');
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.broken_image_rounded,
                                                size: 64,
                                                color: Colors.grey[400],
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                'Image not available',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Attempted URL:',
                                                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                                      ),
                                                      Text(
                                                        imageUrl,
                                                        style: TextStyle(fontSize: 10, color: Colors.red[400]),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Category Badge
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFA18B1D),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        listSubmissions[index].category.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Content Section
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Pet Name
                                    Text(
                                      listSubmissions[index].pet_name.toString(),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFA18B1D),
                                        letterSpacing: 0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),

                                    // Pet Type with Icon
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.pets,
                                          size: 18,
                                          color: Color(0xFFA18B1D),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          listSubmissions[index].pet_type.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),

                                    // Description
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF0EBD2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Color(0xFFBFA523).withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        listSubmissions[index].description.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF78671F),
                                          height: 1.4,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
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
      bottomNavigationBar: listSubmissions.isNotEmpty
          ? Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: numofpage,
                itemBuilder: (context, index) {
                  final isActive = (curpage - 1) == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: isActive
                            ? const Color(0xFFA18B1D)
                            : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          curpage = index + 1;
                        });
                        loadServices('');
                      },
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFA18B1D),
        icon: const Icon(Icons.add),
        label: const Text("Submit Pet"),
        onPressed: () async {
            if (widget.user?.userId == '0') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please login or register first"),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => loginScreen()),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubmitPet(user: widget.user),
                ),
              );
              loadServices('');
            }
          },
      ),
      drawer: MyDrawer(user: widget.user),
    );
  }

    void showDetailsDialog(int index) {// need change
    final submission = listSubmissions[index];
    final formattedDate = formatter.format(
      DateTime.parse(submission.userRegdate.toString()),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DRAG HANDLE
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Image.network(
                          '${myconfiguration.baseUrl}/pawpal/assets/uploads/pet_${listSubmissions[index].pet_id}_1.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Image.network(
                          '${myconfiguration.baseUrl}/pawpal/assets/uploads/pet_${listSubmissions[index].pet_id}_2.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Image.network(
                          '${myconfiguration.baseUrl}/pawpal/assets/uploads/pet_${listSubmissions[index].pet_id}_3.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TITLE
                    Text(
                      submission.pet_name.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // DISTRICT + RATE
                    Row(
                      children: [
                        _chip(
                          Icons.location_on,
                          "${submission.lat}, ${submission.lng}",
                        ),
                        const SizedBox(width: 8),
                        _chip(
                          Icons.calendar_month,
                          submission.created_at.toString(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // DESCRIPTION
                    Text(
                      submission.description.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      "${submission.age},${submission.gender},${submission.health}",
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    // INFO SECTION
                    _infoRow("Pet Type", submission.pet_type),
                    _infoRow("Posted On", formattedDate),
                    _infoRow("Provider", submission.userName),
                    _infoRow("Phone", submission.userPhone),
                    _infoRow("Email", submission.userEmail),

                    const SizedBox(height: 20),

                    // CONTACT ACTIONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionIcon(
                          Icons.call,
                          () => launchUrl(
                            Uri.parse('tel:${submission.userPhone}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _actionIcon(
                          Icons.message,
                          () => launchUrl(
                            Uri.parse('sms:${submission.userPhone}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _actionIcon(
                          Icons.email,
                          () => launchUrl(
                            Uri.parse('mailto:${submission.userEmail}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _actionIcon(
                          Icons.wechat,
                          () => launchUrl(
                            Uri.parse('https://wa.me/${submission.userPhone}'),
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    if(listSubmissions[index].category == "Adoption")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFA726),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Color(0xFFFFA726).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (widget.user?.userId == '0') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please login or register first"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => loginScreen()),
                          );
                        } else {
                          final TextEditingController motivationController = TextEditingController();
                          bool isConfirmed = false;
                          
                          await showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Adoption Request'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: motivationController,
                                    decoration: const InputDecoration(
                                      labelText: 'Motivation Message',
                                      hintText: 'Why do you want to adopt this pet?',
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    isConfirmed = false;
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Validate before confirming
                                    if (motivationController.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please enter your motivation'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    if (motivationController.text.trim().length < 10) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please provide more details (minimum 10 characters)'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    isConfirmed = true;
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('Submit Request'),
                                ),
                              ],
                            ),
                          );
                          
                          // Process if confirmed (isConfirmed = true)
                          if (isConfirmed) {
                              await http.post(
                                Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/insert_adoption.php'),
                                body: {
                                  'user_id': widget.user!.userId,
                                  'pet_id': listSubmissions[index].pet_id.toString(),
                                  'submission_id': listSubmissions[index].user_id.toString(),
                                  'motivation': motivationController.text.trim(),
                                },
                              )
                              .then((response) {
                              
                              if (response.statusCode == 200) {
                                final result = jsonDecode(response.body);
                                
                                if (result['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Adoption request submitted successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  adoptionRequests.add(AdoptionRequest.fromJson(result['adoption_request']));
                                  Navigator.pop(context); // Close the bottom sheet
                                } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to submit request: ${result['message']}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    
                                }
                              } 
                            loadServices('');
                            setState(() {});
                          });
                          }
                          
                        }
                      },
                      child: Text(
                        'Adopt Pet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                        
                      ),
                    ),
                    if(listSubmissions[index].category != "Adoption")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA18B1D),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Color(0xFFA18B1D).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (widget.user?.userId == '0') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please login or register first"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => loginScreen()),
                          );
                        } else {
                        Navigator.pop(context); // Close the bottom sheet
                        _showDonationDialog(context, listSubmissions[index].pet_id.toString(), listSubmissions[index].pet_name.toString());
                        }
                      },
                      child: Text(
                        'Donate for this Pet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void loadServices(String searchQuery) {
    allSubmissions.clear();
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
              allSubmissions.clear();
              for (var item in jsonResponse['data']) {
                allSubmissions.add(Petsubmittion.fromJson(item));
              }

              // Build pet types list from data
              petTypes = ['All'];
              for (var s in allSubmissions) {
                String t = (s.pet_type ?? '').toString();
                if (t.isNotEmpty && !petTypes.contains(t)) {
                  petTypes.add(t);
                }
              }

              // Apply current filter
              applyFilter();

              numofpage = int.parse(jsonResponse['numofpage'].toString());
              numofresult = listSubmissions.length;
              print(numofpage);
              print(numofresult);
              setState(() {
                status = "";
              });
            } else {
              setState(() {
                listSubmissions.clear();
                allSubmissions.clear();
                status = "Not Available";
              });
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
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
                  },
                );
              }
            }
          } else {
            setState(() {
              listSubmissions.clear();
              allSubmissions.clear();
              status = "Failed to load services";
            });
          }
        }).catchError((error) {
          print('Error loading services: $error');
          setState(() {
            status = "Error: $error";
          });
        });
  }

  void applyFilter() {
    setState(() {
      if (selectedPetType == 'All' || selectedPetType.isEmpty) {
        listSubmissions = List.from(allSubmissions);
      } else {
        listSubmissions = allSubmissions.where((p) => (p.pet_type ?? '').toString().toLowerCase() == selectedPetType.toLowerCase()).toList();
      }
      numofresult = listSubmissions.length;
      numofpage = 1;
      curpage = 1;
    });
  }

  void showFilterDialog() {
    String tempSelected = selectedPetType;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.filter_list, color: Color(0xFFA18B1D)),
              SizedBox(width: 12),
              Text('Filter by Pet Type'),
            ],
          ),
          content: DropdownButtonFormField<String>(
            value: tempSelected,
            items: petTypes.map((t) => DropdownMenuItem<String>(
              value: t,
              child: Text(t),
            )).toList(),
            onChanged: (value) {
              tempSelected = value ?? 'All';
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.pets, color: Color(0xFFA18B1D)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFBFA523)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFA18B1D), width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA18B1D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Apply'),
              onPressed: () {
                setState(() {
                  selectedPetType = tempSelected;
                });
                applyFilter();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.search, color: Color(0xFFA18B1D)),
              SizedBox(width: 12),
              Text('Search Submissions'),
            ],
          ),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Enter pet name',
              prefixIcon: Icon(Icons.pets, color: Color(0xFFA18B1D)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFBFA523)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFA18B1D), width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFA18B1D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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

   Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value ?? "-")),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blueGrey.withValues(alpha: 0.15),
        child: Icon(icon, color: Colors.blueGrey),
      ),
    );
  }
// donation form when type of category is 
void _showDonationDialog(BuildContext context, String petId, String petName) {
  String selectedType = 'Money';
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Donate for Pet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //frop down button to select type of donation
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['Money', 'Food', 'Medical'].map((type) => 
                DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setDialogState(() => selectedType = value!),
              decoration: const InputDecoration(labelText: 'Donation Type'),
            ),
            const SizedBox(height: 15),
            if (selectedType == 'Money')
            //input value for money donation
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (RM)', 
                  border: OutlineInputBorder()
                ),
              )
            else
            //input value for non-money donation
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description', 
                  hintText: 'Brand of food or medical needs', 
                  border: OutlineInputBorder()
                ),
              ),
          ],
        ),
        actions: [
          //cancel donation button
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () async {
              // Validation for money donation empty value 
              if (selectedType == 'Money' && amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter amount')),
                );
                return;
              }
              // Validation for non-money donation empty value 
              if (selectedType != 'Money' && descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter description')),
                );
                return;
              }
              
              Navigator.pop(context); // Close dialog first
              
              // Handle donation based on type
              if (selectedType == 'Money') {
              
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Donationpage(
                      user: widget.user,
                      credits: int.parse(amountController.text),
                      petId: petId, 
                      petName: petName,
                    ),
                  ),
                );
                loadServices('');
                
              } else {
                // For Food/Medical donations, directly record to database
                await _recordDonation(
                  petId: petId,
                  donationType: selectedType,
                  description: descriptionController.text,
                  petName: petName, // Use the passed petName parameter
                );
                
                loadServices('');
              }
            },
            child: const Text('Donate Now'),
          ),
        ],
      ),
    ),
  );
}

// method to record non-money donations
Future<void> _recordDonation({
  required String petId,
  required String donationType,
  required String description,
  required String petName,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/record_donation_non_payment.php'),
      body: {
        'pet_id': petId,
        'user_id': widget.user!.userId!,
        'donation_type': donationType,
        'amount': '0',
        'description': description,
        'donor_name': widget.user!.userName!,
        'donor_email': widget.user!.userEmail!,
        'donor_phone': widget.user!.userPhone!,
      },
    );
    
    if (response.statusCode == 200) {//if server connect successfully
      var result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${donationType} donation recorded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  } catch (e) {//if server not connected
    print('Error recording donation: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error recording donation'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  
}