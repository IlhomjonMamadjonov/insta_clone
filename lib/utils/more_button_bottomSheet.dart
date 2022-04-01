import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreButton{
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading:  Icon(Icons.photo_library),
                    title:  Text('Gallery'),
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading:  Icon(Icons.photo_camera),
                  title:  Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}