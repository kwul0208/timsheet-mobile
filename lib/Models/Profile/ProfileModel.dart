class ProfileModel{
  final int? id;
  final String? fullname;
  final String? departement;
  final String? position;
  final String? is_consultant;
  final String? url_photo;



  ProfileModel({this.id, this.fullname, this.departement, this.position, this.is_consultant, this.url_photo});

  factory ProfileModel.fromJson(dynamic json){
    return ProfileModel(
      id: json['id'],
      fullname: json['fullname'],
      departement: json['departement'],
      position: json['position'],
      is_consultant: json['is_consultant'],
      url_photo: json['url_photo'],


    );
  }

  static List<ProfileModel> ProfileModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ProfileModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, fullname: $fullname, departement: $departement, position: $position, is_consultant: $is_consultant, url_photo: $url_photo}';
  }
  
}