// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  Welcome({
    this.id,
    this.original,
    this.originalName,
    this.name,
    this.amount,
    this.unit,
    this.unitShort,
    this.unitLong,
    this.possibleUnits,
    this.estimatedCost,
    this.consistency,
    this.aisle,
    this.image,
    this.meta,
    this.nutrition,
  });

  int id;
  String original;
  String originalName;
  String name;
  double amount;
  String unit;
  String unitShort;
  String unitLong;
  List<String> possibleUnits;
  EstimatedCost estimatedCost;
  String consistency;
  String aisle;
  String image;
  List<String> meta;
  Nutrition nutrition;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    id: json["id"],
    original: json["original"],
    originalName: json["originalName"],
    name: json["name"],
    amount: json["amount"],
    unit: json["unit"],
    unitShort: json["unitShort"],
    unitLong: json["unitLong"],
    possibleUnits: List<String>.from(json["possibleUnits"].map((x) => x)),
    estimatedCost: EstimatedCost.fromJson(json["estimatedCost"]),
    consistency: json["consistency"],
    aisle: json["aisle"],
    image: json["image"],
    meta: List<String>.from(json["meta"].map((x) => x)),
    nutrition: Nutrition.fromJson(json["nutrition"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "original": original,
    "originalName": originalName,
    "name": name,
    "amount": amount,
    "unit": unit,
    "unitShort": unitShort,
    "unitLong": unitLong,
    "possibleUnits": List<dynamic>.from(possibleUnits.map((x) => x)),
    "estimatedCost": estimatedCost.toJson(),
    "consistency": consistency,
    "aisle": aisle,
    "image": image,
    "meta": List<dynamic>.from(meta.map((x) => x)),
    "nutrition": nutrition.toJson(),
  };
}

class EstimatedCost {
  EstimatedCost({
    this.value,
    this.unit,
  });

  double value;
  String unit;

  factory EstimatedCost.fromJson(Map<String, dynamic> json) => EstimatedCost(
    value: json["value"].toDouble(),
    unit: json["unit"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "unit": unit,
  };
}

class Nutrition {
  Nutrition({
    this.nutrients,
    this.properties,
    this.flavanoids,
    this.caloricBreakdown,
    this.weightPerServing,
  });

  List<Flavanoid> nutrients;
  List<Flavanoid> properties;
  List<Flavanoid> flavanoids;
  CaloricBreakdown caloricBreakdown;
  WeightPerServing weightPerServing;

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
    nutrients: List<Flavanoid>.from(json["nutrients"].map((x) => Flavanoid.fromJson(x))),
    properties: List<Flavanoid>.from(json["properties"].map((x) => Flavanoid.fromJson(x))),
    flavanoids: List<Flavanoid>.from(json["flavanoids"].map((x) => Flavanoid.fromJson(x))),
    caloricBreakdown: CaloricBreakdown.fromJson(json["caloricBreakdown"]),
    weightPerServing: WeightPerServing.fromJson(json["weightPerServing"]),
  );

  Map<String, dynamic> toJson() => {
    "nutrients": List<dynamic>.from(nutrients.map((x) => x.toJson())),
    "properties": List<dynamic>.from(properties.map((x) => x.toJson())),
    "flavanoids": List<dynamic>.from(flavanoids.map((x) => x.toJson())),
    "caloricBreakdown": caloricBreakdown.toJson(),
    "weightPerServing": weightPerServing.toJson(),
  };
}

class CaloricBreakdown {
  CaloricBreakdown({
    this.percentProtein,
    this.percentFat,
    this.percentCarbs,
  });

  double percentProtein;
  double percentFat;
  double percentCarbs;

  factory CaloricBreakdown.fromJson(Map<String, dynamic> json) => CaloricBreakdown(
    percentProtein: json["percentProtein"],
    percentFat: json["percentFat"],
    percentCarbs: json["percentCarbs"],
  );

  Map<String, dynamic> toJson() => {
    "percentProtein": percentProtein,
    "percentFat": percentFat,
    "percentCarbs": percentCarbs,
  };
}

class Flavanoid {
  Flavanoid({
    this.name,
    this.amount,
    this.unit,
    this.percentOfDailyNeeds,
  });

  String name;
  double amount;
  Unit unit;
  double percentOfDailyNeeds;

  factory Flavanoid.fromJson(Map<String, dynamic> json) => Flavanoid(
    name: json["name"],
    amount: json["amount"].toDouble(),
    unit: unitValues.map[json["unit"]],
    percentOfDailyNeeds: json["percentOfDailyNeeds"] == null ? null : json["percentOfDailyNeeds"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "unit": unitValues.reverse[unit],
    "percentOfDailyNeeds": percentOfDailyNeeds == null ? null : percentOfDailyNeeds,
  };
}

enum Unit { EMPTY, MG, KCAL, G, UNIT_G }

final unitValues = EnumValues({
  "": Unit.EMPTY,
  "g": Unit.G,
  "kcal": Unit.KCAL,
  "mg": Unit.MG,
  "µg": Unit.UNIT_G
});

class WeightPerServing {
  WeightPerServing({
    this.amount,
    this.unit,
  });

  int amount;
  Unit unit;

  factory WeightPerServing.fromJson(Map<String, dynamic> json) => WeightPerServing(
    amount: json["amount"],
    unit: unitValues.map[json["unit"]],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "unit": unitValues.reverse[unit],
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
