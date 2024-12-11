import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/constant/path.dart';
import 'package:scp/core/consultant/testimonials/view_model/testimonials_view_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Testimonials extends ConsumerWidget {
  const Testimonials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonialsState = ref.watch(testimonialsViewModelProvider);
    ref.listen<String?>(deleteTestimonialErrorMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, false);
        ref.read(deleteTestimonialErrorMsgProvider.notifier).state = null;
      }
    });

    ref.listen<String?>(deleteTestimonialSuccessMsgProvider, (previous, next) {
      if (next != null) {
        CustomSnackbar.showSnackbar(context, next, true);
        ref.read(deleteTestimonialSuccessMsgProvider.notifier).state = null;
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Testimonials ❤',
          icon: true,
        ),
      ),
      body: testimonialsState.when(
        data: (value) {
          if (value.isEmpty) {
            return Center(
              child: Text(
                'No testimonial has been given to you. :(',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
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
                    SizedBox(
                      height: 1.h,
                    ),
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (value[index].userId != null)
                                  Text(
                                    'by ${value[index].userId!.name}',
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
                            //menu
                            IconButton(
                              onPressed: () async {
                                await ref
                                    .read(
                                        testimonialsViewModelProvider.notifier)
                                    .delete(
                                      ref,
                                      value[index].id!,
                                    );
                              },
                              icon: Icon(
                                CupertinoIcons.delete,
                                color: textColor,
                                size: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                // Share video URL and review text on LinkedIn
                                String message = value[index].review ??
                                    "Check out this video!";
                                String videoUrl =
                                    storageUrl + (value[index].videoUrl ?? "");
                                String linkedInUrl =
                                    "https://www.linkedin.com/shareArticle?url=${Uri.encodeComponent(videoUrl)}&title=${Uri.encodeComponent(message)}";
                                if (await canLaunchUrl(
                                    Uri.parse(linkedInUrl))) {
                                  await launchUrl(Uri.parse(linkedInUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  CustomSnackbar.showSnackbar(context,
                                      "LinkedIn app is not installed!", false);
                                }
                              },
                              icon: Icon(
                                TablerIcons.brand_linkedin,
                                color: textColor,
                                size: 16.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                // Share video URL and review text on Twitter
                                String message = value[index].review ??
                                    "Check out this video!";
                                String videoUrl =
                                    storageUrl + (value[index].videoUrl ?? "");
                                String twitterUrl =
                                    "https://twitter.com/intent/tweet?text=${Uri.encodeComponent('$message $videoUrl')}";
                                if (await canLaunchUrl(Uri.parse(twitterUrl))) {
                                  await launchUrl(Uri.parse(twitterUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  CustomSnackbar.showSnackbar(context,
                                      "Twitter app is not installed!", false);
                                }
                              },
                              icon: Icon(
                                TablerIcons.brand_twitter,
                                color: textColor,
                                size: 16.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                // Share video URL and review text on Facebook
                                String message = value[index].review ??
                                    "Check out this video!";
                                String videoUrl =
                                    storageUrl + (value[index].videoUrl ?? "");
                                String facebookUrl =
                                    "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(videoUrl)}";
                                if (await canLaunchUrl(
                                    Uri.parse(facebookUrl))) {
                                  await launchUrl(Uri.parse(facebookUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  CustomSnackbar.showSnackbar(context,
                                      "Facebook app is not installed!", false);
                                }
                              },
                              icon: Icon(
                                TablerIcons.brand_facebook,
                                color: textColor,
                                size: 16.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                // Share video URL and review text on Instagram (via share intent)
                                String message = value[index].review ??
                                    "Check out this video!";
                                String videoUrl =
                                    storageUrl + (value[index].videoUrl ?? "");
                                String instagramUrl =
                                    "instagram://story-camera?background=${Uri.encodeComponent(videoUrl)}";
                                if (await canLaunchUrl(
                                    Uri.parse(instagramUrl))) {
                                  await launchUrl(Uri.parse(instagramUrl),
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  CustomSnackbar.showSnackbar(context,
                                      "Instagram app is not installed!", false);
                                }
                              },
                              icon: Icon(
                                TablerIcons.brand_instagram,
                                color: textColor,
                                size: 16.sp,
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
