# image_masking_flutter

The Image Masking Flutter Plugin allows developers to create an interactive image reveal effect. It allows users to interactively reveal or color an image by dragging their fingers across the screen.

# Installation

To use this package, add `image_masking_flutter` as a dependency in your `pubspec.yaml` file:

dependencies:
```
  image_masking_flutter: ^1.0.0
```

# Usage

```bash
import 'package:image_masking_flutter/image_masking_flutter.dart';
```

# GIF

<img src="https://github.com/user-attachments/assets/353b6d19-5f55-4437-9d7b-4fa57b9ca73d" width="300" height="650"/>

# Example

```bash

  ///* Create a GlobalKey *///


  final GlobalKey<ImageMaskingWidgetState> _imageMaskingKey = GlobalKey<ImageMaskingWidgetState>();


  ///* Use the below widget with properties according to your requirements *///


  ImageMaskingWidget(
      key: _imageMaskingKey,
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/4,horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2)),
      coloredImage: "assets/images/kid_color.jpeg",
      unColoredImage: "assets/images/kid_uncolor.jpeg",
    )


   ///* For reset the view *///

   _imageMaskingKey.currentState?.resetView();


```

## Author

<a class="github-button" href="https://github.com/Sohit-Sharma" aria-label="Follow @Sohit-Sharma on GitHub">Follow GitHub @Sohit-Sharma</a>

<a class="github-button" href="https://www.linkedin.com/in/sohit-sharma-940084172/" aria-label="LinkedIn: Sohit-Sharma">Follow LinkedIn: @Sohit-Sharma</a>

# Contributing

If you find a bug or want to contribute to this project, feel free to open an issue or submit a pull request. Contributions are welcome!

### Happy Coding!


