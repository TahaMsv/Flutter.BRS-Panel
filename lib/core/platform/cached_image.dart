import 'package:brs_panel/core/util/basic_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../screens/user_setting/user_setting_state.dart';
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
        errorBuilder: (_, __, ___) => const CircleAvatar(child: Icon(Icons.add_a_photo, size: 17)),
      ),
    );
  }

  static Widget showImage(String url, {double iconSize = 20}) {
    return CachedNetworkImage(
      imageUrl: url,
      httpHeaders: const {"Api-Key": Apis.imageServiceToken},
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            // colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn),
          ),
        ),
      ),
      placeholder: (context, url) =>Icon(Icons.person, size: iconSize),
      errorWidget: (context, url, error) {
        return Icon(Icons.person, size: iconSize);
      },
    );
  }
}
