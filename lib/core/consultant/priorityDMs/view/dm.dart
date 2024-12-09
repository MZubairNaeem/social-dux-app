// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scp/core/buyer/buyer_dashboard/providers/user_provider.dart';
import 'package:scp/main.dart';
import 'package:scp/model/chat_model.dart';
import 'package:scp/theme/colors/colors.dart';
import 'package:scp/utils/format_time.dart';
import 'package:scp/widgets/appBar/primary_app_bar.dart';
import 'package:scp/widgets/progressIndicator/progress_indicator.dart';
import 'package:scp/widgets/snackbar_message/snackbar_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class MessageScreen extends StatefulWidget {
  final String chatRoomId;
  const MessageScreen({super.key, required this.chatRoomId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late final Stream<List<ChatModel>> _messagesStream;

  @override
  void initState() {
    _messagesStream = supabase
        .from('chat')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) {
          return maps
              .where((map) => map['chat_room_id'] == widget.chatRoomId)
              .map((map) => ChatModel.fromJson(map))
              .toList();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8.h),
        child: const PrimaryAppBar(
          title: 'Chat DMs 🚀',
          icon: true,
        ),
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            /// I know it's not good to include code that is not related
                            /// to rendering the widget inside build method, but for
                            /// creating an app quick and dirty, it's fine 😂

                            return _ChatBubble(
                              message: message,
                            );
                          },
                        ),
                ),
                _MessageBar(
                  chatRoomId: widget.chatRoomId,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching messages'),
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  final String chatRoomId;
  const _MessageBar({required this.chatRoomId});

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _submitMessage(),
                child: const Icon(
                  TablerIcons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('chat').insert({
        'message': text,
        'chat_room_id': widget.chatRoomId,
      });

      await supabase.from('chat_rooms').update({
        'last_message': text,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq(
        'id',
        widget.chatRoomId,
      );
    } on PostgrestException catch (e) {
      CustomSnackbar.showSnackbar(context, e.toString(), false);
    } catch (_) {
      CustomSnackbar.showSnackbar(context, 'Error sending message', false);
    }
  }
}

class _ChatBubble extends ConsumerWidget {
  const _ChatBubble({
    required this.message,
  });

  final ChatModel message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> chatContents = [
      if (message.userId != supabase.auth.currentUser!.id)
        Consumer(
          builder: (context, watch, child) {
            final userState =
                ref.watch(userProvider(supabase.auth.currentUser!.id));

            return userState.when(
              data: (value) {
                return CircleAvatar(
                  child: value.dp == null
                      ? Text(value.name.substring(0, 2))
                      : Image.network(value.dp!),
                );
              },
              error: (e, st) {
                return const Text('Error');
              },
              loading: () => preloader,
            );
          },
        ),
      SizedBox(width: 3.w),
      Flexible(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 3.w,
          ),
          decoration: BoxDecoration(
            color: message.userId == supabase.auth.currentUser!.id
                ? primaryColor
                : accentColor,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              fontSize: 16.sp,
              color: white,
            ),
          ),
        ),
      ),
      SizedBox(width: 2.w),
      Text(
        formatTime(message.createdAt!),
        style: TextStyle(
          color: neutral400,
          fontSize: 14.sp,
        ),
      ),
      const SizedBox(
        width: 60,
      ),
    ];
    if (message.userId == supabase.auth.currentUser!.id) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment: message.userId == supabase.auth.currentUser!.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
