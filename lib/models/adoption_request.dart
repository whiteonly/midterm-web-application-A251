// models/adoption_request.dart
class AdoptionRequest {
  int? adoptionId;
  int? petId;
  int? adopterUserId;
  int? ownerUserId;
  String? motivationMessage;
  DateTime? updatedAt;

  AdoptionRequest({
    this.adoptionId,
    this.petId,
    this.adopterUserId,
    this.ownerUserId,
    this.motivationMessage,
    this.updatedAt,
  });

  factory AdoptionRequest.fromJson(Map<String, dynamic> json) => AdoptionRequest(
        adoptionId: json['adoption_id'],
        petId: json['pet_id'],
        adopterUserId: json['adopter_user_id'],
        ownerUserId: json['owner_user_id'],
        motivationMessage: json['motivation_message'],
        updatedAt: (json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        if (adoptionId != null) 'adoption_id': adoptionId,
        'pet_id': petId,
        'adopter_user_id': adopterUserId,
        'owner_user_id': ownerUserId,
        'motivation_message': motivationMessage,
        'updated_at': updatedAt,
      };
}