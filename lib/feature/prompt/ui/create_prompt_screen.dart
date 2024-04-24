import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midjourney_flutter_app/feature/prompt/bloc/prompt_bloc.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  TextEditingController controller = TextEditingController();

  final PromptBloc promptBloc = PromptBloc();

  @override
  void initState() {
    promptBloc.add(PromptInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color.fromARGB(255, 64, 165, 248),
                Color.fromARGB(255, 167, 119, 249),
                Color.fromARGB(255, 238, 109, 100)
              ],
            ).createShader(bounds);
          },
          child: const Text(
            'Generate Image',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // title: const Text(
        //   "Generate Images",
        //   style: TextStyle(
        //       fontStyle: FontStyle.italic, fontFamily: 'Schyler-Regular'),
        // ),
        centerTitle: true,
      ),
      body: BlocConsumer<PromptBloc, PromptState>(
        bloc: promptBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PromptGeneratingImageLoadState:
              return const Center(child: CircularProgressIndicator());

            case PromptGeneratingImageErrorState:
              return const Center(child: Text("Something went wrong"));
            case PromptGeneratingImageSuccessState:
              final successState = state as PromptGeneratingImageSuccessState;
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Colors.grey.shade900,
                      Colors.grey.shade900,
                      Color.fromRGBO(72, 19, 163, 100),

                      // Color.fromRGBO(217, 101, 113, 100),
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        MemoryImage(successState.uint8list))))),
                    Container(
                      height: 240,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Enter your prompt",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 48,
                            child: TextField(
                              controller: controller,
                              cursorColor: Colors.deepPurple,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 48,
                            width: double.maxFinite,
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            255, 133, 75, 234))),
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    promptBloc.add(PromptEnteredEvent(
                                        prompt: controller.text));
                                  }
                                },
                                icon: const Icon(
                                  Icons.generating_tokens,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Generate",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
