// "date": "2023-01-01",
// "periode_cut_off": "17 December 2022 - 16 January 2023",
// "duration": 14400,
// "adjustment": 14400,
// "adjustment_reason": null,
// "status_by": "Mahrizal",
// "status_date": "2023-01-02",
// "status": "approve"

class OTCheckModel{
  final String? date;
  final String? periode_cut_off;
  final int? duration;
  final int? adjustment;
  final String? adjustment_reason;
  final String? status_by;
  final String? status_date;
  final String? status;


  OTCheckModel({this.date, this.periode_cut_off, this.duration, this.adjustment, this.adjustment_reason, this.status_by, this.status_date, this.status});

  factory OTCheckModel.fromJson(dynamic json){
    return OTCheckModel(
        date:json['date'],
        periode_cut_off:json['periode_cut_off'],
        duration:json['duration'],
        adjustment:json['adjustment'],
        adjustment_reason:json['adjustment_reason'],
        status_by:json['status_by'],
        status_date:json['status_date'],
        status:json['status'],
    );
  }

  static List<OTCheckModel> OTCheckModelFromSnapshot(List ? snapshot){
    return snapshot!.map((e){
      return OTCheckModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{date: $date, periode_cut_off: $periode_cut_off, duration: $duration, adjustment: $adjustment, adjustment_reason: $adjustment_reason, status_by: $status_by, status_date: $status_date, status: $status}';
  }
  
}