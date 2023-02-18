import 'package:flutter/material.dart';

//画面遷移0秒
class CustomMaterialPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);

  CustomMaterialPageRoute({builder}) : super(builder: builder);
}
