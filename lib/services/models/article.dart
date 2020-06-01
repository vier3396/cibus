class Article {
  final String articleID;
  final String title;
  final String subTitle;
  final String subsubtitle;
  final String description;
  final List<dynamic> steps;
  final String ending;
  final String greeting;
  final String topImage;
  final String bottomImage;

  Article(
      {this.articleID,
      this.title,
      this.subTitle,
      this.subsubtitle,
      this.description,
      this.steps,
      this.ending,
      this.greeting,
      this.topImage,
      this.bottomImage});
}
