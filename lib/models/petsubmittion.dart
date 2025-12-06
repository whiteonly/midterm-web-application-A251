class Petsubmittion {
  String? pet_id;
  String? user_id;
  String? pet_name;
  String? pet_type;
  String? category;
  String? description;
  String? image_paths;
  String? lat;
  String? lng;
  String? created_at;


  // Added user info
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userRegdate;

  Petsubmittion({
    this.pet_id,
    this.user_id,
    this.pet_name,
    this.pet_type,
    this.category,
    this.description,
    this.image_paths,
    this.lat,
    this.lng,
    this.created_at,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userRegdate,
  });

  Petsubmittion.fromJson(Map<String, dynamic> json) {
    pet_id = json['pet_id'];
    user_id = json['user_id'];
    pet_name = json['pet_name'];
    pet_type = json['pet_type'];
    category = json['category'];
    description = json['description'];
    image_paths = json['image_paths'];
    lat = json['lat'];
    lng = json['lng'];
    created_at = json['created_at'];

    // Mapping user fields
    userName = json['name'];
    userEmail = json['email'];
    userPhone = json['phone'];
    userRegdate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = pet_id;
    data['user_id'] = user_id;
    data['pet_name'] = pet_name;
    data['pet_type'] = pet_type;
    data['category'] = category;    
    data['description'] = description;
    data['image_paths'] = image_paths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = created_at;

    data['name'] = userName;
    data['email'] = userEmail;
    data['phone'] = userPhone;
    data['reg_date'] = userRegdate;

    return data;
  }
}
