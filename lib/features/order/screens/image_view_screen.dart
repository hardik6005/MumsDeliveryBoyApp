import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_app_bar_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ImageViewScreen extends StatefulWidget {
  final String? title;
  final String? baseUrl;
  final List<String>? imageList;
  const ImageViewScreen({Key? key, required this.title, required this.imageList, required this.baseUrl}) : super(key: key);

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  int? pageIndex;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    pageIndex = 0;
    _pageController = PageController(initialPage: pageIndex = 0);
    //NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: SizedBox(
          width: 1170,
          child: Column(children: [

            CustomAppBarWidget(title: widget.title),

            Expanded(
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        onScaleEnd: (context, scaleEndDetails, photoViewControllerValue){
                        },
                        imageProvider: NetworkImage('${widget.baseUrl}/${widget.imageList![index]}'),
                        initialScale: PhotoViewComputedScale.contained,
                      );
                    },
                    backgroundDecoration: BoxDecoration(color: Theme.of(context).cardColor),
                    itemCount: widget.imageList!.length,
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    pageController: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                  ),

                  pageIndex != 0 ? Positioned(
                    left: 5, top: 0, bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          if(pageIndex! > 0) {
                            _pageController!.animateToPage(pageIndex!-1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          }
                        },
                        child: const Icon(Icons.chevron_left_outlined, size: 40),
                      ),
                    ),
                  ) : const SizedBox.shrink(),

                  pageIndex != widget.imageList!.length-1 ? Positioned(
                    right: 5, top: 0, bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          if(pageIndex! < widget.imageList!.length) {
                            _pageController!.animateToPage(pageIndex!+1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                          }
                        },
                        child: const Icon(Icons.chevron_right_outlined, size: 40),
                      ),
                    ),
                  ) : const SizedBox.shrink(),
                ],
              ),
            ),

          ]),
        ),
      ),
    );
  }
}

