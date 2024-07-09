import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_message_display.dart';
import 'google_sign_in_service.dart';
import 'input_field.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/chat_bloc.dart';
import '../models/chat_message_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      return _buildDesktopLayout(messages, currentUser);
                    } else {
                      return _buildMobileLayout(messages, currentUser);
                    }
                  },
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(
      List<ChatMessageModel> messages, User? currentUser) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "AI Chat Bot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                currentUser != null
                    ? IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          _googleSignInService.signOut(context);
                        },
                      )
                    : OutlinedButton(
                        onPressed: () {
                          _googleSignInService.signInWithGoogle(
                              context, '/home');
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                            (states) {
                              return BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              );
                            },
                          ),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1);
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ChatMessageDisplay(messages: messages),
          if (chatBloc.generating)
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Lottie.asset('../assets/starloader.json'),
                ),
                const Text(
                  "Loading...",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          InputField(
            textEditingController: textEditingController,
            chatBloc: chatBloc,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
      List<ChatMessageModel> messages, User? currentUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 300,
          color: Colors.grey.shade800,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (currentUser != null) {
                      _googleSignInService.signOut(context);
                    } else {
                      _googleSignInService.signInWithGoogle(context, '/home');
                    }
                  },
                  icon: Icon(currentUser != null ? Icons.logout : Icons.login),
                  label: Text(
                    currentUser != null ? 'Logout' : 'Login',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AI Chat Bot",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.image_search,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ChatMessageDisplay(messages: messages),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InputField(
                      textEditingController: textEditingController,
                      chatBloc: chatBloc,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
