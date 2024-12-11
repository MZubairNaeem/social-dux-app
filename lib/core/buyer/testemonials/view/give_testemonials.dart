import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/constant/path.dart';
import 'package:scp/core/buyer/testemonials/view/add_give_testemonials.dart';
import 'package:scp/core/buyer/testemonials/view_model/give_testemonials_view_model.dart';
import 'package:scp/model/bookings_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:video_player/video_player.dart';

class GiveTestemonials extends ConsumerWidget {
  final BookingsModel booking;
  const GiveTestemonials({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(buyerTestemonialForService(booking.id!));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Testemonial',
          icon: true,
        ),
      ),
      body: bookingState.when(
        data: (value) {
          if (value.isEmpty) {
            return Center(
              child: TextButton(
                onPressed: () async {
                  try {
                    final cameras = await availableCameras();

                    // Filter for the front camera
                    final frontCamera = cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.front,
                      orElse: () =>
                          throw Exception('No front camera available'),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddGiveTestemonials(
                          booking: booking,
                          camera: frontCamera,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: Text(
                  'Give a testimonial now',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: hintText.withOpacity(0.2),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '💬',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        value[index].review ?? "",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textColor,
                          wordSpacing: 0.1,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    if (value[index].rating != null)
                      Row(
                        children: [
                          for (var i = 0; i < value[index].rating!; i++)
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16.sp,
                            ),
                        ],
                      ),
                    SizedBox(height: 1.h),
                    if (value[index].videoUrl != null &&
                        value[index].videoUrl!.isNotEmpty)
                      VideoPlayerWidget(
                          videoUrl: storageUrl + value[index].videoUrl!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (value[index].userId != null)
                              Text(
                                value[index].userId!.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            SizedBox(
                              width: 1.w,
                            ),
                            if (value[index].serviceId != null)
                              Text(
                                "(${value[index].serviceId!.title})",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: textColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => const Center(
          child: CustomProgressIndicator(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({required this.videoUrl, super.key});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
