import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:url_launcher/url_launcher.dart';

class Donationpage extends StatefulWidget {
  final User? user;
  final int credits;
  final String petId;
  final String petName;

  const Donationpage({
    super.key,
    required this.user,
    required this.credits,
    required this.petId,
    required this.petName,
  });

  @override
  State<Donationpage> createState() => _DonationpageState();
}

class _DonationpageState extends State<Donationpage> {
  late String userName, userEmail, userPhone, userID;
  bool isLoading = false;

  @override
  void initState() {
    // Initialize user details from the passed user object
    super.initState();
    userEmail = widget.user!.userEmail!;
    userPhone = widget.user!.userPhone!;
    userName = widget.user!.userName!;
    userID = widget.user!.userId!;
    
    // Automatically launch payment when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchPayment();
    });
  }
  //using url launcher instead of webview for better user experience and compatibility
  Future<void> _launchPayment() async {
    setState(() {
      isLoading = true;
    });
    //call the package url_launcher to launch the payment url for payment gateway
    final paymentUrl = Uri.parse(
      '${myconfiguration.baseUrl}/pawpal/pawpal/api/payment.php?email=$userEmail&phone=$userPhone&userid=$userID&name=$userName&credits=${widget.credits}&petid=${widget.petId}',
    );
    //error handling for url launch failure
    try {
      if (await canLaunchUrl(paymentUrl)) {
        await launchUrl(
          paymentUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          _showErrorDialog('Could not launch payment page');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  // Show error dialog with retry option
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchPayment(); // Retry
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  //UI for donation page and payment redirection gateway and details
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pet information card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.pets,
                        size: 64,
                        color: Color(0xFF1F3C88),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Donation for ${widget.petName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Amount: RM ${widget.credits}.00',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F3C88),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Donor: $userName',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Email: $userEmail',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Loading to redirect to payment page
              if (isLoading)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Opening payment page...'),
                  ],
                )
              else
              // Proceed to payment button to redirect to payment gateway
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _launchPayment,
                      icon: const Icon(Icons.payment),
                      label: const Text('Proceed to Payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F3C88),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              
              const SizedBox(height: 24),
              const Text(
                'You will be redirected to Billplz payment gateway',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}