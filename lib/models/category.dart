class Category {

  String id;
  String name;
  String urlImage;

  Category(this.id, this.name, this.urlImage);

  static Category otherCategory = Category('0', 'Other', 'https://blogs.articulate.com/les-essentiels-du-elearning/wp-content/uploads/sites/5/2018/07/choisir-type-de-question-770x387.png');
  static List<String> categoriesIds = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'];
  static Map<String, Category> allCategories = {
    '1': Category('1', 'Cauliflower', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2FCauliflower.png?alt=media&token=6b6f02c7-ed55-4e3c-8cee-e57736a18eed'),
    '2': Category('2', 'Apple', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fapple.jfif?alt=media&token=2e07a7dd-22f6-4eeb-864c-af9435462cc8'),
    '3': Category('3', 'Bread', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fbread.jpg?alt=media&token=9c57b872-afe9-43a1-b859-af416b9f4f6b'),
    '4': Category('4', 'Carrot', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fcarrot.jpg?alt=media&token=c5e04a35-8ea7-4581-b0e2-dcdfc1cada0b'),
    '5': Category('5', 'Cheese', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fcheese.jfif?alt=media&token=d7c2809f-367c-419e-8bce-ed3ad233ae68'),
    '6': Category('6', 'Chilli', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fchilli.png?alt=media&token=8110eb9a-0c37-49d2-b197-9493de68bcbb'),
    '7': Category('7', 'Egg', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fegg.jpg?alt=media&token=783fdda8-3467-4377-8e8d-50e97f33ef76'),
    '8': Category('8', 'Ginger', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fginger.jpg?alt=media&token=4519e53d-00c3-4966-9017-b6334920a502'),
    '9': Category('9', 'Grape', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fgrape.jpg?alt=media&token=0d41db52-9a7c-4b2b-8ec9-a3b34eba56c1'),
    '10': Category('10', 'Lettuce', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Flettuce.jpg?alt=media&token=2f25a15e-255d-4b6a-bf92-824aa0d3c42d'),
    '11': Category('11', 'Maize', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fmaize.jfif?alt=media&token=f4b20f1e-5e3c-4d31-a995-60c07f1ec093'),
    '12': Category('12', 'Milk', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fmilk.jpg?alt=media&token=cbef8494-b0a2-4128-b39e-b3358c26050e'),
    '13': Category('13', 'Oil', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Foil.jpg?alt=media&token=bf45ac24-8ef4-4baf-b14f-b6fc45544303'),
    '14': Category('14', 'Onion', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fonion.jpg?alt=media&token=f032cb42-ae97-4363-aa54-ce4b05889fc6'),
    '15': Category('15', 'Rice', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Frice.jfif?alt=media&token=34db4f24-3bce-4659-aeec-2a2233743bc3'),
    '16': Category('16', 'Salt', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fsalt.jpg?alt=media&token=68913e26-106c-4220-853a-71394b058cf5'),
    '17': Category('17', 'Strawberry', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fstrawberry.png?alt=media&token=867fd0d5-4048-45f1-9251-e70a7604c88d'),
    '18': Category('18', 'Sugar', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fsugar.jpg?alt=media&token=b3d2d615-96b0-4796-939e-1d21c02b3a72'),
    '19': Category('19', 'Tomato', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Ftomato.jpg?alt=media&token=52ab40e6-f38f-408e-a0a2-05d9966f5c34'),
    '20': Category('20', 'Vinegar', 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/grocery%2Fvinegar.jpg?alt=media&token=3d72da50-16a3-4e7e-88d0-737a02ce421e'),
  };

}