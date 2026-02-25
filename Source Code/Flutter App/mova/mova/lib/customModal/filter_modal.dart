class Category {
  final String? name;
  final List? app;

  Category({this.name, this.app});
}

class Data {
  final String name;

  Data({
    required this.name,
  });
}

class Application {
  final String? name;
  final int? type;

  Application({this.name,this.type});
}class Application2 {
   final int? name;
   final int? type;

  Application2({this.name,this.type});
}

List item = [
  Data(name: "Categories"),
  Data(name: "Regions"),
  Data(name: "Genre"),
  Data(name: "Time/Periods"),
  Data(name: "Sort"),
];

List<Application> categories = [
  Application(name: "Movie",type: 1),
  Application(name: "TV Shows",type: 2),
  Application(name: "K-Drama",type: 1),
  Application(name: "Anime",type: 1),
];

List<Application> regions = [
  Application(name: "All Regions",type: 2),
  Application(name: "US",type: 1),
  Application(name: "South Korea",type: 1),
  Application(name: "Chinese",type: 1),
];

List<Application> genre = [
  Application(name: "Action",type: 1),
  Application(name: "Comedy",type: 1),
  Application(name: "Romance",type: 2),
  Application(name: "Thriller",type: 1),
];

List<Application2> timePeriods = [

  Application2(name: 2022,type: 2),
  Application2(name: 2021,type: 1),
  Application2(name: 2020,type: 1),
  Application2(name: 2019,type: 1),
  Application2(name: 2018,type: 1),
  Application2(name: 2017,type: 1),
  Application2(name: 2016,type: 1),
];

List<Application> sort = [
  Application(name: "Popularity",type: 2),
  Application(name: "Latest Release",type: 1),
];

List<Category> dataCategories = [
  Category(name: "Categories", app: categories),
  Category(name: "Regions", app: regions),
  Category(name: "Genre", app: genre),
  Category(name: "Time/Periods", app: timePeriods),
  Category(name: "Sort", app: sort),
];


