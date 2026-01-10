import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class Userprofile extends StatefulWidget {
  final User? user;
  const Userprofile({super.key, this.user});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  final TextEditingController nameController  = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  /* ---------- appearance ---------- */
  String selectedTheme    = 'system';   // system | light | dark
  String selectedLanguage = 'en';       // en | ms
  bool isLoading          = true;

  /* ---------- image ---------- */
  Uint8List? webImage;
  File? image;
  String? profileImageUrl;
  bool isUploading = false; // For upload progress
  @override
  void initState() {
    super.initState();
    _loadProfileFromPrefs();   // profile first
    loadSettings();            // theme/lang afterwards
  }

  /* ---------------- profile helpers ---------------- */
    Future<void> _loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    nameController.text  = prefs.getString('profile_name')  ?? widget.user?.userName ?? '';
    phoneController.text = prefs.getString('profile_phone') ?? widget.user?.userPhone ?? '';
    emailController.text = prefs.getString('email') ?? '';
    
    // Load the saved photo URL
    final cachedPhoto = prefs.getString('profile_photo') ?? '';
    if (cachedPhoto.isNotEmpty) {
      print('Loaded cached photo: $cachedPhoto');
      
      // Construct full URL if needed
      if (cachedPhoto.startsWith('http')) {
        profileImageUrl = cachedPhoto;
      } else {
        profileImageUrl = '${myconfiguration.baseUrl}/$cachedPhoto';
      }
      
      print('Full profile photo URL: $profileImageUrl');
      setState(() {}); // Update UI
    }
  }

  Future<void> _saveProfile() async {
  // Step 1: Validate required fields
  if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Name and phone are required'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() => isUploading = true); // Show loading on button

  // Step 2: Encode image to base64 (like in submitService)
  String base64image = "NA"; // Default if no image
  if (kIsWeb && webImage != null) {
    base64image = base64Encode(webImage!);
  } else if (!kIsWeb && image != null) {
    base64image = base64Encode(image!.readAsBytesSync());
  }

  // Step 3: Update profile data on server (includes base64 image)
  final response = await http.post(
    Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/update_user_profile.php'),
    body: {
      'user_id': widget.user?.userId ?? '',
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'image': base64image,
    },
  );

  setState(() => isUploading = false); // Hide loading

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    if (data['status'] == 'success') {// Profile updated successfully
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', nameController.text.trim());
      await prefs.setString('profile_phone', phoneController.text.trim());
      
      // Save the returned image URL
      if (data['image_url'] != null && data['image_url'].isNotEmpty) {
        await prefs.setString('profile_photo', data['image_url']);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(// Success
        const SnackBar(
          content: Text('Profile and image saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {// Server returned failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] ?? 'Profile update failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Server error during profile update'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  /* ---------------- appearance helpers ---------------- */
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme    = prefs.getString('theme')    ?? 'system';
      selectedLanguage = prefs.getString('language') ?? 'en';
      isLoading        = false;
    });
  }

  /* ---------------- image picker ---------------- */
  Future<void> _pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    if (kIsWeb) {
      webImage = await pickedFile.readAsBytes();
    } else {
      image = File(pickedFile.path);
    }
    setState(() {});
  }

  /* ============================================================ */

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (innerContext) => IconButton(// to open drawer safely
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();   // safe
              },
            ),
            ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      drawer: MyDrawer(user: widget.user),// pass user to drawer
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 500
              ? 500
              : double.infinity,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionTitle('Profile'),// profile section
              _card(// profile card to save profile image and details
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                       backgroundImage: webImage != null
                              ? MemoryImage(webImage!)
                              : (image != null
                                  ? FileImage(image!)
                                  : (profileImageUrl != null && profileImageUrl!.isNotEmpty
                                      ? NetworkImage(profileImageUrl!)
                                      : null
                          ))
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.blue),
                            onPressed: _pickProfileImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _field(label: 'Name', icon: Icons.person, controller: nameController),// name field
                  _field(label: 'Email', icon: Icons.email, controller: emailController, enabled: false),// email field (disabled)
                  _field(label: 'Phone', icon: Icons.phone, controller: phoneController, type: TextInputType.phone),// phone field
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ---------------- UI helpers ---------------- */
  Widget _sectionTitle(String title) => Padding(//
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)));

  Widget _card({required List<Widget> children}) => Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children));

  Widget _field(// reusable text field - name / email / phone
          {required String label,
          required IconData icon,
          required TextEditingController controller,
          TextInputType? type,
          bool enabled = true}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: type,
          decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        ),
      );
}