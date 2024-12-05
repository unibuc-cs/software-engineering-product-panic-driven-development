import "package:flutter/material.dart";

import "media.dart";

abstract class MediaType {
  Future<Media> get media async {
    throw UnimplementedError("Getter media was not defined for this type");
  }

  Future<Widget> get additionalButtons async {
    throw UnimplementedError("Getter additionalButtons was not defined for this type");
  }
}