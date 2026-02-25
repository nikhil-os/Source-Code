// To parse this JSON data, do
//
//     final settingsModal = settingsModalFromJson(jsonString);

import 'dart:convert';

SettingsModal settingsModalFromJson(String str) => SettingsModal.fromJson(json.decode(str));

String settingsModalToJson(SettingsModal data) => json.encode(data.toJson());

class SettingsModal {
  bool? status;
  String? message;
  Setting? setting;

  SettingsModal({
    this.status,
    this.message,
    this.setting,
  });

  factory SettingsModal.fromJson(Map<String, dynamic> json) => SettingsModal(
        status: json["status"],
        message: json["message"],
        setting: json["setting"] == null ? null : Setting.fromJson(json["setting"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "setting": setting?.toJson(),
      };
}

class Setting {
  String? id;
  String? googlePlayEmail;
  String? stripePublishableKey;
  String? stripeSecretKey;
  String? razorPayId;
  String? razorSecretKey;
  String? privacyPolicyLink;
  String? privacyPolicyText;
  bool? googlePlaySwitch;
  bool? stripeSwitch;
  bool? razorPaySwitch;
  bool? isAppActive;
  List<dynamic>? paymentGateway;
  String? currency;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? googlePlayKey;
  bool? isIptvApi;
  PrivateKey? privateKey;
  String? flutterWaveId;
  bool? flutterWaveSwitch;
  String? termConditionLink;

  Setting({
    this.id,
    this.googlePlayEmail,
    this.stripePublishableKey,
    this.stripeSecretKey,
    this.razorPayId,
    this.razorSecretKey,
    this.privacyPolicyLink,
    this.privacyPolicyText,
    this.googlePlaySwitch,
    this.stripeSwitch,
    this.razorPaySwitch,
    this.isAppActive,
    this.paymentGateway,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.googlePlayKey,
    this.isIptvApi,
    this.privateKey,
    this.flutterWaveId,
    this.flutterWaveSwitch,
    this.termConditionLink,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["_id"],
        googlePlayEmail: json["googlePlayEmail"],
        stripePublishableKey: json["stripePublishableKey"],
        stripeSecretKey: json["stripeSecretKey"],
        razorPayId: json["razorPayId"],
        razorSecretKey: json["razorSecretKey"],
        privacyPolicyLink: json["privacyPolicyLink"],
        privacyPolicyText: json["privacyPolicyText"],
        googlePlaySwitch: json["googlePlaySwitch"],
        stripeSwitch: json["stripeSwitch"],
        razorPaySwitch: json["razorPaySwitch"],
        isAppActive: json["isAppActive"],
        paymentGateway: json["paymentGateway"] == null ? [] : List<dynamic>.from(json["paymentGateway"]!.map((x) => x)),
        currency: json["currency"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        googlePlayKey: json["googlePlayKey"],
        isIptvApi: json["isIptvAPI"],
        privateKey: json["privateKey"] == null ? null : PrivateKey.fromJson(json["privateKey"]),
        flutterWaveId: json["flutterWaveId"],
        flutterWaveSwitch: json["flutterWaveSwitch"],
        termConditionLink: json["termConditionLink"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "googlePlayEmail": googlePlayEmail,
        "stripePublishableKey": stripePublishableKey,
        "stripeSecretKey": stripeSecretKey,
        "razorPayId": razorPayId,
        "razorSecretKey": razorSecretKey,
        "privacyPolicyLink": privacyPolicyLink,
        "privacyPolicyText": privacyPolicyText,
        "googlePlaySwitch": googlePlaySwitch,
        "stripeSwitch": stripeSwitch,
        "razorPaySwitch": razorPaySwitch,
        "isAppActive": isAppActive,
        "paymentGateway": paymentGateway == null ? [] : List<dynamic>.from(paymentGateway!.map((x) => x)),
        "currency": currency,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "googlePlayKey": googlePlayKey,
        "isIptvAPI": isIptvApi,
        "privateKey": privateKey?.toJson(),
        "flutterWaveId": flutterWaveId,
        "flutterWaveSwitch": flutterWaveSwitch,
        "termConditionLink": termConditionLink,
      };
}

class PrivateKey {
  String? type;
  String? projectId;
  String? privateKeyId;
  String? privateKey;
  String? clientEmail;
  String? clientId;
  String? authUri;
  String? tokenUri;
  String? authProviderX509CertUrl;
  String? clientX509CertUrl;
  String? universeDomain;

  PrivateKey({
    this.type,
    this.projectId,
    this.privateKeyId,
    this.privateKey,
    this.clientEmail,
    this.clientId,
    this.authUri,
    this.tokenUri,
    this.authProviderX509CertUrl,
    this.clientX509CertUrl,
    this.universeDomain,
  });

  factory PrivateKey.fromJson(Map<String, dynamic> json) => PrivateKey(
        type: json["type"],
        projectId: json["project_id"],
        privateKeyId: json["private_key_id"],
        privateKey: json["private_key"],
        clientEmail: json["client_email"],
        clientId: json["client_id"],
        authUri: json["auth_uri"],
        tokenUri: json["token_uri"],
        authProviderX509CertUrl: json["auth_provider_x509_cert_url"],
        clientX509CertUrl: json["client_x509_cert_url"],
        universeDomain: json["universe_domain"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "project_id": projectId,
        "private_key_id": privateKeyId,
        "private_key": privateKey,
        "client_email": clientEmail,
        "client_id": clientId,
        "auth_uri": authUri,
        "token_uri": tokenUri,
        "auth_provider_x509_cert_url": authProviderX509CertUrl,
        "client_x509_cert_url": clientX509CertUrl,
        "universe_domain": universeDomain,
      };
}
