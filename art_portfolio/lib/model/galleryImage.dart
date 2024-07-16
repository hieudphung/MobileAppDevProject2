//Mostly need this for image streaming

class GalleryImage {
  final String imageID;
  final String src;   
  final String userID;
  final String imageName;
  final String description;

  GalleryImage({
    required this.imageID,
    required this.src,
    required this.userID,
    required this.imageName,
    required this.description
  });
}
