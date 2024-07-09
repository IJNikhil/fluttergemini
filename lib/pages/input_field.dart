import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';

class InputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final ChatBloc chatBloc;

  const InputField({
    required this.textEditingController,
    required this.chatBloc,
    Key? key,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isTyping = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 600;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isMobile ? MediaQuery.of(context).viewInsets.bottom + 16 : 0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 0,
          vertical: isMobile ? 8 : 0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 10 : 0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 0 : 0,
                            horizontal: isMobile ? 12 : 0),
                        child: TextField(
                          controller: widget.textEditingController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                            Icon(Icons.search, color: Colors.white),
                            hintText: 'Enter prompt to start...',
                            hintStyle: TextStyle(color: Colors.white70),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          onChanged: (text) {
                            setState(() {
                              isTyping = text.isNotEmpty;
                            });
                          },
                          onSubmitted: (text) {
                            _sendMessage();
                          },
                          enabled: !isLoading, // Disable input during loading
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isLoading && isTyping,
                      child: Stack(
                        children: [
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                if (!isLoading) {
                                  _sendMessage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              splashColor: Colors.white.withOpacity(0.5),
                              hoverColor: Colors.white.withOpacity(0.1),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                                    : const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 24,
                                ),
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
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (widget.textEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String text = widget.textEditingController.text;
      widget.textEditingController.clear();
      widget.chatBloc.add(
        ChatGenerateNewTextMessageEvent(inputMessage: text),
      );

      // Simulating server response delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isTyping = false;
          isLoading = false;
        });
      });
    }
  }
}
