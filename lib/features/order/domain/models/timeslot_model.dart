class TimeSlotModel {
  int? id;
  String? startTime;
  String? endTime;
  String? date;
  int? status;
  String? createdAt;
  String? updatedAt;

  TimeSlotModel(
      {this.id,
        this.startTime,
        this.endTime,
        this.date,
        this.status,
        this.createdAt,
        this.updatedAt});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['date'] = date;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
