class ModeModel{
  final Map business_travel;
  final Map chargeable_time;
  final Map development;
  final Map ishoma;
  final Map office_admisitration;
  final Map over_time;
  final Map personal_leave;
  final Map prospecting;
  final Map suport_service;
  final Map training;


  ModeModel({required this.business_travel, required this.chargeable_time, required this.development, required this.ishoma, required this.office_admisitration, required this.over_time, required this.personal_leave, required this.prospecting, required this.suport_service, required this.training});

  factory ModeModel.fromJson(dynamic json){
    return ModeModel(
      business_travel: json['1'],
      chargeable_time: json['2'],
      development: json['3'],
      ishoma: json['4'],
      office_admisitration: json['5'],
      over_time: json['6'],
      personal_leave: json['7'],
      prospecting: json['8'],
      suport_service: json['9'],
      training: json['10'],
    );
  }

  static List<ModeModel> ModeModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ModeModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{business_travel: $business_travel, chargeable_time: $chargeable_time, development: $development, ishoma: $ishoma, office_admisitration: $office_admisitration, over_time: $over_time, personal_leave: $personal_leave, prospecting: $prospecting, suport_service: $suport_service, training: $training}';
  }
  
}