import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/buyer_dashboard/providers/user_provider.dart';
import 'package:scp/core/buyer/direct_messages/view/message.dart';
import 'package:scp/main.dart';
import 'package:scp/model/chat_room_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/utils/format_time.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';

class ChatRoom extends ConsumerStatefulWidget {
  const ChatRoom({super.key});

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends ConsumerState<ChatRoom> {
  late final Stream<List<ChatRoomModel>> chatRoomStream;
  final userId = supabase.auth.currentUser!.id;

  @override
  void initState() {
    chatRoomStream = supabase
        .from('chat_rooms')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) {
          return maps
              .where((map) => map['buyer_id'] == userId)
              .map((map) => ChatRoomModel.fromJson(map))
              .toList();
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: const PrimaryAppBar(
            title: 'Chat Room 🔥',
            icon: true,
          ),
        ),
        body: StreamBuilder<List<ChatRoomModel>>(
          stream: chatRoomStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final chatRoom = snapshot.data!;
              if (chatRoom.isEmpty) {
                return const Center(
                  child: Text('Buy a service to start conversation now :)'),
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chatRoom.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        Stack(
                          children: [
                            InkWell(
                              splashColor: primaryColor.withOpacity(0.2),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                    chatRoomId: chatRoom[index].id!,
                                  ),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 3.w,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColorLight.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12.sp),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 14.sp),
                                      child: CircleAvatar(
                                        radius: 20.sp,
                                        backgroundColor:
                                            primaryColor.withOpacity(0.8),
                                        child: Image.asset(
                                          'lib/assets/icons/avatar.png',
                                          height: 10.w,
                                          width: 10.w,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Consumer(
                                          builder: (context, ref, child) {
                                            final user = ref.watch(userProvider(
                                                chatRoom[index].consultantId!));
                                            return user.when(
                                              data: (data) {
                                                return Text(
                                                  data.name,
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              },
                                              error: (e, st) =>
                                                  const SizedBox(),
                                              loading: () => const SizedBox(),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 30.w,
                                          child: Text(
                                            chatRoom[index].lastMessage,
                                            style: TextStyle(
                                              color: hintText,
                                              fontSize: 14.sp,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      formatTime(chatRoom[index].updatedAt!),
                                      style: TextStyle(
                                        color: hintText,
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching messages'),
              );
            } else {
              return preloader;
            }
          },
        ),
      ),
    );
  }
}


// Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 4.w,
//                         vertical: 2.h,
//                       ),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 1.h,
//                             horizontal: 5.w,
//                           ),
//                           hintText: 'Search . . .',
//                           suffixIcon: Padding(
//                             padding: EdgeInsets.only(right: 2.w),
//                             child: Icon(
//                               CupertinoIcons.search,
//                               color: hintText.withOpacity(0.3),
//                             ),
//                           ),
//                           border: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: hintText.withOpacity(0.5)),
//                             borderRadius: BorderRadius.circular(12.sp),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: primaryColor,
//                               width: 1.5,
//                             ),
//                             borderRadius: BorderRadius.circular(12.sp),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: hintText.withOpacity(0.3)),
//                             borderRadius: BorderRadius.circular(12.sp),
//                           ),
//                         ),
//                       ),
//                     ),