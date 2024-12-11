import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/main.dart';
import 'package:scp/model/bookings_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../view_model/give_testemonials_view_model.dart';

class AddGiveTestemonials extends ConsumerStatefulWidget {
  final BookingsModel booking;
  final CameraDescription camera;
  const AddGiveTestemonials({
    super.key,
    required this.booking,
    required this.camera,
  });

  @override
  AddGiveTestemonialsState createState() => AddGiveTestemonialsState();
}

class AddGiveTestemonialsState extends ConsumerState<AddGiveTestemonials> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;
  int _selectedStars = 0;
  String filePATH = '';

  bool isLoad = false;

  void _onStarTapped(int star) {
    setState(() {
      _selectedStars = star;
    });
  }

  final review = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      await _controller
          .startVideoRecording(); // No need to specify the path here
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      log('Error starting video recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting video recording: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final videoFile = await _controller
          .stopVideoRecording(); // The recorded video is in a temporary location

      // Now move it to the desired path
      final directory = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().toIso8601String().replaceAll(':', '-');
      final newFilePath = '${directory.path}/$fileName.mp4';

      final recordedFile = File(videoFile.path);
      final savedFile = await recordedFile.copy(newFilePath);

      filePATH = savedFile.path;

      setState(() {
        _isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved at $filePATH')),
      );
    } catch (e) {
      log('Error stopping video recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping video recording: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Add Testemonial',
          icon: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.w,
        ),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Review',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            //outline textfield
            TextFormField(
              maxLines: 3,
              controller: review,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Review is required';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.sp,
                  horizontal: 12.sp,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hintText),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              cursorColor: primaryColorDark,
            ),
            SizedBox(
              height: 2.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rating',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int starNumber = index + 1;
                return GestureDetector(
                  onTap: () => _onStarTapped(starNumber),
                  child: Icon(
                    Icons.star,
                    size: 40,
                    color: starNumber <= _selectedStars
                        ? Colors.amber
                        : Colors.grey,
                  ),
                );
              }),
            ),
            SizedBox(
              height: 2.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Video Testemonial',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: 0.8,
                    child: CameraPreview(_controller),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                child:
                    Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
            ),
            isLoad
                ? const Center(
                    child: CustomProgressIndicator(color: primaryColor),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      if (review.text.isEmpty) {
                        CustomSnackbar.showSnackbar(
                            context, 'Please write review', false);
                        return;
                      }

                      if (_selectedStars == 0) {
                        CustomSnackbar.showSnackbar(
                            context, 'Please give rating', false);
                        return;
                      }

                      isLoad = true;

                      String? videoUrl; // Nullable to handle no video case

                      if (filePATH.isNotEmpty) {
                        try {
                          final avatarFile = File(filePATH);
                          String time = DateTime.now()
                              .toIso8601String()
                              .replaceAll(
                                  ':', '-'); // Replace ':' for valid file name
                          String fileExtension = '.mp4';
                          videoUrl = await supabase.storage
                              .from('digital_products')
                              .upload(
                                '${supabase.auth.currentUser!.id}/$time$fileExtension',
                                avatarFile,
                                fileOptions: const FileOptions(
                                    cacheControl: '3600', upsert: false),
                              );
                        } catch (e) {
                          log(e.toString());
                          isLoad = false;
                          CustomSnackbar.showSnackbar(
                              context, 'Video upload failed: $e', false);
                          return;
                        }
                      }

                      try {
                        await supabase.from('testimonials').insert({
                          'review': review.text.trim(),
                          'rating': _selectedStars,
                          'service_id': widget.booking.serviceId!.id!,
                          'booking_id': widget.booking.id,
                          'video_url': videoUrl, // Pass null if no video
                        });

                        CustomSnackbar.showSnackbar(
                            context, 'Testimonial Submitted', true);
                        ref.invalidate(
                            buyerTestemonialForService(widget.booking.id!));
                        Navigator.pop(context);
                      } catch (e) {
                        log(e.toString());
                        CustomSnackbar.showSnackbar(
                            context, 'Error submitting testimonial: $e', false);
                      } finally {
                        isLoad = false;
                      }
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateColor.resolveWith(
                        (states) => primaryColorDark,
                      ),
                      minimumSize: WidgetStateProperty.all(
                        Size(100.w, 5.h),
                      ),
                      backgroundColor: WidgetStateColor.resolveWith(
                        (states) => primaryColor,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(
                          vertical: 12.sp,
                          horizontal: 20.sp,
                        ),
                      ),
                    ),
                    child: Text(
                      'Submit Testemonial',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
