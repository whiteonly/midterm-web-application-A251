import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/donation.dart';
import 'package:pawpal/myconfiguration.dart';

class MyDonationsScreen extends StatefulWidget {
  final User? user;
  const MyDonationsScreen({super.key, this.user});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  List<Donation> donations = [];
  bool isLoading = true;
  String errorMessage = '';
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    loadDonations();
  }

  Future<void> loadDonations() async {// load user donations from server
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    final url = '${myconfiguration.baseUrl}/pawpal/pawpal/api/get_user_donations.php?user_id=${widget.user!.userId}';
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {// update donations list
            donations = (jsonResponse['data'] as List)
                .map((item) => Donation.fromJson(item))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {// handle no donations or error message
            isLoading = false;
            errorMessage = jsonResponse['message'] ?? 'No donations found';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'HTTP Error: ${response.statusCode}';
        });
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Connection Error: $error';
      });
    });
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(// app bar with title and refresh button
        backgroundColor: const Color(0xFFA18B1D),
        foregroundColor: Colors.white,
        title: const Text(
          'My Donations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(//refresh button
            icon: const Icon(Icons.refresh),
            onPressed: loadDonations,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFA18B1D),
              ),
            )
          : donations.isEmpty
          // no donations case in the database
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.volunteer_activism,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(// display error message or no donations message
                        errorMessage.isEmpty ? 'No donations yet' : errorMessage,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(// display user id for reference
                        'User ID: ${widget.user!.userId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(// donations list with pull to refresh
                  color: const Color(0xFFA18B1D),
                  onRefresh: loadDonations,
                  child: Column(
                    children: [
                      // Summary header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(// donations count
                              '${donations.length} ${donations.length == 1 ? 'Donation' : 'Donations'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA18B1D),
                              ),
                            ),
                            _buildTotalAmount(),// total money donations amount
                          ],
                        ),
                      ),
                      
                      // Donations list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: donations.length,
                          itemBuilder: (context, index) {
                            final donation = donations[index];
                            final isMoneyDonation = donation.donationType == 'Money';
                            print('DEBUG: Building list item $index: ${donation.donationType}, Amount: ${donation.amount}');
                            DateTime? donationDateTime;
                            donationDateTime = DateTime.parse(donation.donationDate ?? ''); // parse donation date
                            return Card(// donation details
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(//donation list tile
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor: _getDonationTypeColor(donation.donationType).withOpacity(0.2),
                                  child: Icon(
                                    _getDonationTypeIcon(donation.donationType),// icon based on donation type
                                    color: _getDonationTypeColor(donation.donationType),// color based on donation type
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(// donation type title
                                      '${donation.donationType ?? 'Unknown'} Donation',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (isMoneyDonation && donation.amount != null)// show amount for money donations
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFA18B1D),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(// formatted amount text
                                          'RM ${donation.amount}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(// donation description and pet id
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    if (donation.description != null && donation.description!.isNotEmpty)
                                      Text(// description text
                                        donation.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.pets, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(// pet id text
                                          'Pet ID: ${donation.petId ?? 'N/A'}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(// formatted donation date
                                      DateFormat('dd/MM/yyyy').format(donationDateTime),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(// formatted donation time
                                      DateFormat('hh:mm a').format(donationDateTime),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _showDonationDetails(donation),// show donation details on tap
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTotalAmount() {// calculate and display total money donations how much user has donated
    double total = 0;
    int moneyCount = 0;
    
    for (var donation in donations) {
      if (donation.donationType == 'Money' && donation.amount != null) {
        total += double.tryParse(donation.amount!) ?? 0;
        moneyCount++;
      }
    }
    if (moneyCount == 0) return const SizedBox.shrink();
    return Container(// return total amount widget
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFA18B1D).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(// formatted total amount
        'Total: RM ${total.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA18B1D),
        ),
      ),
    );
  }

  Color _getDonationTypeColor(String? type) {// icon shown in donation list
    switch (type) {
      case 'Money':
        return const Color(0xFFA18B1D);
      case 'Food':
        return Colors.orange;
      case 'Medical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getDonationTypeIcon(String? type) {// icon shown in donation list
    switch (type) {
      case 'Money':
        return Icons.attach_money;
      case 'Food':
        return Icons.restaurant;
      case 'Medical':
        return Icons.medical_services;
      default:
        return Icons.volunteer_activism;
    }
  }

  void _showDonationDetails(Donation donation) {// show donation details in bottom sheet
    DateTime? donationDateTime;
    donationDateTime = DateTime.parse(donation.donationDate ?? '');
    showModalBottomSheet(// bottom sheet for donation details
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Title
              const Text(
                'Donation Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA18B1D),
                ),
              ),
              const SizedBox(height: 20),
              // Details
              _detailRow('Donation ID', donation.donationId),// detailed rows for donation information
              _detailRow('Pet ID', donation.petId),// pet id row
              _detailRow('Type', donation.donationType),// donation type row
              if (donation.donationType == 'Money' && donation.amount != null)// amount row for money donations
                _detailRow('Amount', 'RM ${donation.amount}'),
              if (donation.description != null && donation.description!.isNotEmpty)// description row if available
                _detailRow('Description', donation.description),
              _detailRow('Donor Name', donation.donorName),
              _detailRow('Email', donation.donorEmail),
              _detailRow('Phone', donation.donorPhone),
              _detailRow(
                'Date', 
                donationDateTime != null 
                    ? formatter.format(donationDateTime)
                    : donation.donationDate ?? 'N/A'
              ),
              const SizedBox(height: 20),
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(// close button to dismiss bottom sheet
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA18B1D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String? value) {// reusable detail row widget for ui customisable
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}