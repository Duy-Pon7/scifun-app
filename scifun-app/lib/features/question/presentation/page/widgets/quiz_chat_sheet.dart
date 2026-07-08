import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class QuizChatController extends ChangeNotifier {
  QuizChatController({DioClient? dioClient})
      : _dioClient = dioClient ?? sl<DioClient>();

  final DioClient _dioClient;
  final List<QuizChatMessage> _messages = <QuizChatMessage>[];
  bool _isSending = false;
  bool _isDisposed = false;

  List<QuizChatMessage> get messages =>
      List<QuizChatMessage>.unmodifiable(_messages);

  bool get isSending => _isSending;

  Future<void> sendMessage(String message) async {
    final normalizedMessage = message.trim();
    if (normalizedMessage.isEmpty || _isSending || _isDisposed) {
      return;
    }

    _messages.add(
      QuizChatMessage(
        text: normalizedMessage,
        isUser: true,
      ),
    );
    _isSending = true;
    _notifySafely();

    try {
      final response = await _dioClient.post(
        url: ChatApiUrls.ask,
        data: {
          'message': normalizedMessage,
        },
      );

      if (_isDisposed) return;
      _messages.add(
        QuizChatMessage(
          text: _extractReplyText(response.data),
          isUser: false,
        ),
      );
      _notifySafely();
    } on DioException catch (error) {
      if (_isDisposed) return;
      _messages.add(
        QuizChatMessage(
          text: _extractErrorText(error),
          isUser: false,
        ),
      );
      _notifySafely();
    } catch (_) {
      if (_isDisposed) return;
      _messages.add(
        const QuizChatMessage(
          text: 'Mèo chưa gửi được câu hỏi này. Bạn thử lại giúp mình nhé!',
          isUser: false,
        ),
      );
      _notifySafely();
    } finally {
      if (!_isDisposed) {
        _isSending = false;
        _notifySafely();
      }
    }
  }

  void _notifySafely() {
    if (_isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

class QuizChatSheet extends StatefulWidget {
  const QuizChatSheet({
    super.key,
    required this.controller,
  });

  final QuizChatController controller;

  @override
  State<QuizChatSheet> createState() => _QuizChatSheetState();
}

class _QuizChatSheetState extends State<QuizChatSheet> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(_handleInputFocusChange);
    widget.controller.addListener(_handleChatStateChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(covariant QuizChatSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.controller, widget.controller)) {
      return;
    }

    oldWidget.controller.removeListener(_handleChatStateChange);
    widget.controller.addListener(_handleChatStateChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.removeListener(_handleInputFocusChange);
    _inputFocusNode.dispose();
    widget.controller.removeListener(_handleChatStateChange);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _inputController.text.trim();
    if (message.isEmpty || widget.controller.isSending) return;

    _inputController.clear();
    FocusScope.of(context).unfocus();
    await widget.controller.sendMessage(message);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleInputFocusChange() {
    if (_inputFocusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _handleInputTap() {
    _scrollToBottom();
  }

  void _handleChatStateChange() {
    if (!mounted) return;
    setState(() {});
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.78;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final messages = widget.controller.messages;
    final isSending = widget.controller.isSending;

    return SafeArea(
      top: false,
      child: Container(
        height: sheetHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22.r),
          ),
        ),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 54.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD3D8E1),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 10.h, 8.w, 8.h),
                child: Row(
                  children: [
                    Icon(
                      Symbols.pets_rounded,
                      color: AppColor.skyblue600,
                      size: 30.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Trợ lý Mèo',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A3342),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Symbols.close_rounded,
                        size: 30.sp,
                        color: const Color(0xFF8A95A7),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            'Meo meo, Mèo chỉ nhớ cuộc trò chuyện trong phiên này.\nGửi câu hỏi để Mèo hỗ trợ bạn ngay!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF667085),
                              fontSize: 18.sp,
                              height: 1.4,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                        itemCount: messages.length + (isSending ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= messages.length) {
                            return _ChatTypingBubble(fontSize: 15.sp);
                          }

                          final item = messages[index];
                          return _QuizChatBubble(
                            text: item.text,
                            isUser: item.isUser,
                          );
                        },
                      ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _inputFocusNode,
                        controller: _inputController,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.send,
                        onTap: _handleInputTap,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Hỏi Mèo điều bạn đang thắc mắc...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9AA4B2),
                            fontSize: 18.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF2F5FA),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: isSending ? null : _sendMessage,
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: isSending
                              ? const Color(0xFFB7D8EC)
                              : AppColor.skyblue500,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Symbols.send_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizChatMessage {
  const QuizChatMessage({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;
}

class _QuizChatBubble extends StatelessWidget {
  const _QuizChatBubble({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 10.h,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColor.skyblue500 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
            bottomLeft: Radius.circular(isUser ? 14.r : 4.r),
            bottomRight: Radius.circular(isUser ? 4.r : 14.r),
          ),
          border: isUser
              ? null
              : Border.all(
                  color: const Color(0xFFE3E8EF),
                ),
        ),
        child: SelectableText(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: isUser ? Colors.white : const Color(0xFF2A3342),
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ChatTypingBubble extends StatelessWidget {
  const _ChatTypingBubble({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE3E8EF)),
        ),
        child: Text(
          'Mèo đang nghĩ đáp án hay nhất...',
          style: TextStyle(
            fontSize: fontSize,
            color: const Color(0xFF667085),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

String _extractReplyText(dynamic data) {
  if (data is String && data.trim().isNotEmpty) {
    return _cleanReplyText(data);
  }

  if (data is Map<String, dynamic>) {
    final status = data['status'];
    final rootMessage = data['message'];
    if (status is num &&
        status >= 400 &&
        rootMessage is String &&
        rootMessage.trim().isNotEmpty) {
      return 'Mèo báo: ${rootMessage.trim()}';
    }

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final reply = nestedData['reply'];
      if (reply is String && reply.trim().isNotEmpty) {
        return _cleanReplyText(reply);
      }
    }

    final rootReply = data['reply'];
    if (rootReply is String && rootReply.trim().isNotEmpty) {
      return _cleanReplyText(rootReply);
    }

    if (rootMessage is String && rootMessage.trim().isNotEmpty) {
      return _cleanReplyText(rootMessage);
    }
  }

  return 'Mèo chưa đọc được phản hồi hợp lệ từ hệ thống. Bạn thử hỏi lại nha!';
}

String _extractErrorText(DioException error) {
  final responseData = error.response?.data;
  logResponseData(
    responseData,
    source: 'QuizChatSheet._extractErrorText',
  );
  if (responseData is Map<String, dynamic>) {
    final message = responseData['message'];
    if (message is String && message.trim().isNotEmpty) {
      return 'Mèo báo: ${message.trim()}';
    }
  }

  final errorMessage = error.message;
  if (errorMessage != null && errorMessage.trim().isNotEmpty) {
    return 'Mèo gặp trục trặc: ${errorMessage.trim()}';
  }

  return 'Mèo bị rớt kết nối mất rồi. Bạn thử lại sau ít giây nhé!';
}

String _cleanReplyText(String text) {
  return text.replaceAll('**', '').trim();
}
