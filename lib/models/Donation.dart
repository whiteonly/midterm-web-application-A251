class Donation {
  String? donationId;
  String? petId;
  String? userId;
  String? donationType;
  String? amount;
  String? description;
  String? donorName;
  String? donorEmail;
  String? donorPhone;
  String? donationDate;
  String? petname;

  Donation({
    this.donationId,
    this.petId,
    this.userId,
    this.donationType,
    this.amount,
    this.description,
    this.donorName,
    this.donorEmail,
    this.donorPhone,
    this.donationDate,
    this.petname,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donationId: json['donation_id']?.toString(),
      petId: json['pet_id']?.toString(),
      userId: json['user_id']?.toString(),
      donationType: json['donation_type']?.toString(),
      amount: json['amount']?.toString(),
      description: json['description']?.toString(),
      donorName: json['donor_name']?.toString(),
      donorEmail: json['donor_email']?.toString(),
      donorPhone: json['donor_phone']?.toString(),
      donationDate: json['donation_date']?.toString(),
      petname: json['pet_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donation_id': donationId,
      'pet_id': petId,
      'user_id': userId,
      'donation_type': donationType,
      'amount': amount,
      'description': description,
      'donor_name': donorName,
      'donor_email': donorEmail,
      'donor_phone': donorPhone,
      'donation_date': donationDate,
      'pet_name': petname,
    };
  }

  @override
  String toString() {
    return 'Donation{id: $donationId, petId: $petId, type: $donationType, amount: $amount, date: $donationDate}';
  }
}