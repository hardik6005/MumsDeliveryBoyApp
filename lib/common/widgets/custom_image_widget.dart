import 'package:cached_network_image/cached_network_image.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  const CustomImageWidget({Key? key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.isNotification = false, this.placeholder = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image, height: height, width: width, fit: fit,
      placeholder: (context, url) => Image.asset(placeholder.isNotEmpty ? placeholder : Images.placeholderImage, height: height, width: width, fit: fit),
      errorWidget: (context, url, error) => Image.asset(placeholder.isNotEmpty ? placeholder : Images.placeholderImage, height: height, width: width, fit: fit),
    );
  }
}
