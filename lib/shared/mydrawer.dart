import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/MainScreen.dart';
import 'package:pawpal/shared/animated_route.dart';
import 'package:pawpal/views/MyDonationScreen.dart';
import 'package:pawpal/views/loginScreen.dart';
import 'package:pawpal/views/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpal/myconfiguration.dart';
class MyDrawer extends StatefulWidget {
  final User? user;
  const MyDrawer({super.key, this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void initState() {
    super.initState();
    loadPreferences();
  }
  String cachedName  = '';
  String cachedEmail = '';
  String cachedPhoto = '';
  late double screenHeight;

  @override
  //UI of the drawer consisting of home, donation, profile, and login options(if not logged in)
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    final showName  = cachedName;
    final showEmail = cachedEmail;
    final showPhoto = cachedPhoto;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 180, 183, 16),
            ),
            currentAccountPicture: CircleAvatar(
             backgroundImage: showPhoto.isNotEmpty 
                  ? NetworkImage(showPhoto) 
                  : null,
              // Show text 'A' ONLY if showPhoto is empty
              child: showPhoto.isEmpty 
                  ? const Text('A', style: TextStyle(fontSize: 24)) 
                  : null,
            ),
            //Display name and email using shared preference instead of user object
            accountName: Text(showName.isNotEmpty ? showName : 'Guest'),
            accountEmail: Text(showEmail.isNotEmpty ? showEmail : 'Guest'),
          ),
          //Main list screen showing list of Submission
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(Mainscreen(user: widget.user)),
              );
            },
          ),
          //Donation screen showing list of Donations made by user
          ListTile(
            leading: Icon(Icons.volunteer_activism),
            title: Text('Donation'),
            onTap: () {
              // showdialog if user is not logged in, they cannot access donation screen
              if (widget.user?.userId == '0') {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: const [
                        Icon(Icons.lock_outline, color: Color(0xFF1F3C88)),
                        SizedBox(width: 8),
                        Text("Login Required"),
                      ],
                    ),
                    content: const Text(
                      "Please login to continue and access this feature.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F3C88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            AnimatedRoute.slideFromRight(const loginScreen()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );

                return;
              }
              Navigator.pop(context);
              //Navigate to MyDonationScreen if user is logged in
              if (widget.user != null) {
                Navigator.push(
                  context,
                  AnimatedRoute.slideFromRight(MyDonationsScreen(user: widget.user)),
                );
              }
              
            },
          ),
          //Profile screen showing user profile details and can edit profile
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // showdialog if user is not logged in, they cannot access profile screen
              if (widget.user?.userId == '0') {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: const [
                        Icon(Icons.lock_outline, color: Color(0xFF1F3C88)),
                        SizedBox(width: 8),
                        Text("Login Required"),
                      ],
                    ),
                    content: const Text(
                      "Please login to continue and access this feature.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F3C88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            AnimatedRoute.slideFromRight(const loginScreen()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );

                return;
              }
              Navigator.pop(context);
              //Navigate to Userprofile screen if user is logged in
              if (widget.user != null) {
                Navigator.pushReplacement(
                  context,
                  AnimatedRoute.slideFromRight(Userprofile(user: widget.user!)),
                );
              }
            },
          ),
          //Login screen if user is not logged in, it will dissapear if user is logged in
          if (widget.user?.userId == '0')
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const loginScreen()),
                );
              },
            ),
          const Divider(color: Colors.grey),
          SizedBox(
            height: screenHeight / 3.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("Version 0.1b", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }


 Future<void> loadPreferences() async {//load shared preference data for name, email, and profile photo
    final preferences = await SharedPreferences.getInstance();
    
    // Get values first
    cachedName = preferences.getString('profile_name') ?? '';
    cachedEmail = preferences.getString('email') ?? '';
    
    // Get the photo path from preferences
    final photoPath = preferences.getString('profile_photo') ?? '';
    
    // Construct full URL if it's a relative path
    if (photoPath.isNotEmpty) {
      if (photoPath.startsWith('http')) {
        cachedPhoto = photoPath; // Already a full URL
      } else {
        // Add base URL to relative path
        cachedPhoto = '${myconfiguration.baseUrl}/$photoPath';
      }
      print('Full profile photo URL: $cachedPhoto'); // Debug
    } else {
      cachedPhoto = '';
    }
    setState(() {});
  }
}
