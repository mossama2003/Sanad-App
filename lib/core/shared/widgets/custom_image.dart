// class CustomImage extends StatelessWidget {
//   const CustomImage({
//     super.key,
//     this.fit,
//     this.width,
//     this.height,
//     this.radius,
//     required this.image,
//   });
//
//   final BoxFit? fit;
//   final String image;
//   final double? width;
//   final double? height;
//   final BorderRadius? radius;
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: radius ?? BorderRadius.zero,
//       child: CachedNetworkImage(
//         fit: fit,
//         width: width,
//         height: height,
//         imageUrl: image,
//
//         /// LOADING FOR IMAGE
//         placeholder: (context, url) => Center(
//           child: SizedBox(
//             width: AppSize.getSize(25),
//             height: AppSize.getSize(25),
//             child: const CircularProgressIndicator(
//               strokeWidth: 2.0,
//               color: AppColors.primary,
//             ),
//           ),
//         ),
//
//         /// ERROR IN IMAGE LINK
//         errorWidget: (context, url, error) => const Icon(
//           Icons.error_outline,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }
