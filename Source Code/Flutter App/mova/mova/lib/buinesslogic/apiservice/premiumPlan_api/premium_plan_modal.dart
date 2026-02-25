// status : true
// message : "Success!!"
// premiumPlan : [{"_id":"6374db8a4dfaba297326ce1e","name":"test","isAutoRenew":false,"validity":1,"validityType":"month","dollar":1,"tag":"60%","productKey":"test","createdAt":"2022-11-16T12:46:02.893Z","updatedAt":"2022-11-21T05:12:17.962Z","planBenefit":["enjoy watching premium movie","enjoy watching ads free movie"]},{"name":"","_id":"639ae9ded7148d39e15d10dc","planBenefit":["enjoy watching premium movie","enjoy watching ads free movie"],"isAutoRenew":false,"validity":1,"validityType":"month","dollar":10,"tag":"60% OFF","productKey":"asd","createdAt":"2022-12-15T09:33:18.017Z","updatedAt":"2022-12-15T09:33:18.017Z"},{"_id":"6374d9077dc9ce96eb6cf49f","name":"test","isDelete":false,"isAutoRenew":false,"validity":1,"validityType":"year","dollar":1,"tag":"50%","productKey":"test","createdAt":"2022-11-16T12:35:19.256Z","updatedAt":"2022-11-17T06:20:35.580Z","planBenefit":["enjoy watching premium movie","enjoy watching ads free movie"]}]

import 'dart:convert';

PremiumPlanModal premiumPlanModalFromJson(String str) => PremiumPlanModal.fromJson(json.decode(str));

String premiumPlanModalToJson(PremiumPlanModal data) => json.encode(data.toJson());

class PremiumPlanModal {
  bool? status;
  String? message;
  List<PremiumPlan>? premiumPlan;

  PremiumPlanModal({
    this.status,
    this.message,
    this.premiumPlan,
  });

  factory PremiumPlanModal.fromJson(Map<String, dynamic> json) => PremiumPlanModal(
        status: json["status"],
        message: json["message"],
        premiumPlan: json["premiumPlan"] == null ? [] : List<PremiumPlan>.from(json["premiumPlan"]!.map((x) => PremiumPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "premiumPlan": premiumPlan == null ? [] : List<dynamic>.from(premiumPlan!.map((x) => x.toJson())),
      };
}

class PremiumPlan {
  String? id;
  String? name;
  bool? isAutoRenew;
  num? validity;
  String? validityType;
  num? dollar;
  String? tag;
  String? productKey;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? planBenefit;

  PremiumPlan({
    this.id,
    this.name,
    this.isAutoRenew,
    this.validity,
    this.validityType,
    this.dollar,
    this.tag,
    this.productKey,
    this.createdAt,
    this.updatedAt,
    this.planBenefit,
  });

  factory PremiumPlan.fromJson(Map<String, dynamic> json) => PremiumPlan(
        id: json["_id"],
        name: json["name"],
        isAutoRenew: json["isAutoRenew"],
        validity: json["validity"],
        validityType: json["validityType"],
        dollar: json["dollar"],
        tag: json["tag"],
        productKey: json["productKey"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        planBenefit: json["planBenefit"] == null ? [] : List<String>.from(json["planBenefit"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "isAutoRenew": isAutoRenew,
        "validity": validity,
        "validityType": validityType,
        "dollar": dollar,
        "tag": tag,
        "productKey": productKey,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "planBenefit": planBenefit == null ? [] : List<dynamic>.from(planBenefit!.map((x) => x)),
      };
}
