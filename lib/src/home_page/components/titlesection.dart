import 'package:flutter/material.dart';
import 'package:plant_diseases_detection_using_deep_learning/constants/constants.dart';

class TitleSection extends SliverFixedExtentList {
  TitleSection(String title, double height, {Key? key})
      : super(
          key: key,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, index) {
              return Container(
                //margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Center(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: (0.6*height), fontFamily: 'SFBold', color: kMain),
                    ),
                  ),
              );

            },
            childCount: 1,
          ),
          itemExtent: height,
        );
}
