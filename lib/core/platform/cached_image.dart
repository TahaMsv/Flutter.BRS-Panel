import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/apis.dart';
import 'spiners.dart';

class CachedImage {
  CachedImage._();

  static Widget showProfile(String url) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Image.network(
        url,
        headers: const {"Api-Key": Apis.imageServiceToken},
        loadingBuilder: (_, __, ___) => Padding(padding: const EdgeInsets.all(1), child: Spinners.circle2()),
        errorBuilder: (_, __, ___) {
          print("give me an error mf!");
          return const CircleAvatar(child: Icon(Icons.add_a_photo, size: 17));
        },
      ),
    );
  }

  static Widget showImage2(String url) {
    print("image url");
    print(url);
    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: const {"Api-Key": Apis.imageServiceToken},
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
