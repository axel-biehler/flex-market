/// Represents the response of the API call used to add images and get urls
///
/// This class is used to store the urls used to upload and display pictures.
class AddPicsResponse {
  /// Creates a [AddPicsResponse] with the given arrays of [presignedUrls] and [imageUrls].
  AddPicsResponse({required this.presignedUrls, required this.imageUrls});

  /// A list of presigned urls that will be used to upload pictures
  final List<String> presignedUrls;

  /// A list of urls that will be used to display pictures
  final List<String> imageUrls;
}
