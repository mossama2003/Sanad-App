import '../models/cases_model.dart';

const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

bool isImageAttachment(CaseAttachment attachment) {
  final contentType = attachment.attachment.contentType.toLowerCase();
  final nameExtension = attachment.attachment.name.split('.').last.toLowerCase();

  return imageExtensions.contains(contentType) ||
      imageExtensions.contains(nameExtension);
}