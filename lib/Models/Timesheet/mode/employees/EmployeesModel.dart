class EmployeesModel{
  final int id;
  final String fullname;
  final String? url_photo;

  EmployeesModel({required this.id, required this.fullname, this.url_photo});

  factory EmployeesModel.fromJson(dynamic json){
    return EmployeesModel(
      id: json['id'],
      fullname: json['fullname'],
      url_photo: json['url_photo']
    );
  }

  static List<EmployeesModel> EmployeesModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return EmployeesModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, fullname: $fullname, url_photo: $url_photo}';
  }
  
}