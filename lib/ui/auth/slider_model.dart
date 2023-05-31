class SliderModel{
  String? image;
  String? title;
  String? description;

// Constructor for variables
  SliderModel({this.title, this.description, this.image});

  void setImage(String getImage){
    image = getImage;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }
  void setDescription(String getDescription){
    description = getDescription;
  }

  String? getImage(){
    return image;
  }

  String? getTitle(){
    return title;
  }
  String? getDescription(){
    return description;
  }
}

// List created
// List<SliderModel> getSlides(){
//   // List<SliderModel> slides = List<SliderModel>();
//   SliderModel sliderModel = SliderModel();
//
// // Item 1
//   sliderModel.setImage("images/slider2.png");
//   sliderModel.setTitle("Copper Articles");
//   sliderModel.setDescription("Interested in buying Copper Handicrafts");
//   // slides.add(sliderModel);
//
//   sliderModel = SliderModel();
//
// // Item 2
//   sliderModel.setImage("images/slider2.png");
//   sliderModel.setTitle("Copper Articles");
//   sliderModel.setDescription("Interested in buying Copper Handicrafts");
//   // slides.add(sliderModel);
//
//   sliderModel = SliderModel();
//
// // Item 3
//   sliderModel.setImage("images/slider2.png");
//   sliderModel.setTitle("Copper Articles");
//   sliderModel.setDescription("Interested in buying Copper Handicrafts");
//   // slides.add(sliderModel);
//
//   sliderModel = SliderModel();
//   // return slides;
// }
