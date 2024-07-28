import 'package:flutter/material.dart';
import 'package:image_masking_flutter/image_masking_widget.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ImageMaskingWidgetState> _imageMaskingKey = GlobalKey<ImageMaskingWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mainImageView(context),
          topbarView(),
          eraserView(),
        ],
      ),
    );
  }

  Widget mainImageView(BuildContext context) {
    return ImageMaskingWidget(
      key: _imageMaskingKey,
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/4,horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2)),
      coloredImage: "assets/images/kid_color.jpeg",
      unColoredImage: "assets/images/kid_uncolor.jpeg",
    );
  }


  Widget topbarView() {
    return Container(
          color: Colors.blue,
          width: double.infinity,
          height: 120,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 20),
          child: const Text("Image Masking",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 26)),
        );
  }


  Widget eraserView() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: (){
            _imageMaskingKey.currentState?.resetView();
          },
          child: Container(
              margin: const EdgeInsets.only(bottom: 100),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.black,width: 1)
              ),
              padding: const EdgeInsets.all(15),
              child: const Icon(Icons.cleaning_services,size: 30,)),
        ));
  }

}
