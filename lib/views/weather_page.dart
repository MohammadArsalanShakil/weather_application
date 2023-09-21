import 'dart:developer';
import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../logic/models/weather_model.dart';
import '../logic/services/call_to_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<WeatherModel> getData(bool isCurrentCity, String cityName) async {
    return await CallToApi().callWeatherAPi(isCurrentCity, cityName);
  }

  TextEditingController textController = TextEditingController(text: "");
  Future<WeatherModel>? _myData;

  @override
  void initState() {
    setState(() {
      _myData = getData(true, "");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If error occured
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error.toString()} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if data has no errors
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as WeatherModel;
              return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color.fromARGB(96, 168, 50, 255),
                        Color.fromARGB(229, 128, 255, 255),
                        Color.fromARGB(200, 86, 88, 177),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: SafeArea(
                    child: Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 05.0, sigmaY: 05.0),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade500.withOpacity(0.4)),
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimSearchBar(
                                      rtl: true,
                                      width: 400,
                                      color: const Color(0xffffffff),
                                      textController: textController,
                                      suffixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                      onSuffixTap: () async {
                                        textController.text == ""
                                            ? log("No city entered")
                                            : setState(() {
                                                _myData = getData(
                                                    false, textController.text);
                                              });

                                        FocusScope.of(context).unfocus();
                                        textController.clear();
                                      },
                                      style: f14RblackLetterSpacing2,
                                      onSubmitted: (String) {},
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Image.network(
                                              "https://openweathermap.org/img/wn/${data.icon}@4x.png"),
                                        ),
                                        Text(
                                          data.city,
                                          style: f24Rwhitebold,
                                        ),
                                        height25,
                                        Text(
                                          data.desc,
                                          style: f16PW,
                                        ),
                                        height25,
                                        Text(
                                          "${data.temp}°C",
                                          style: f42Rwhitebold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // child: Column(
                      //   children: [
                      //     AnimSearchBar(
                      //       rtl: true,
                      //       width: 400,
                      //       color: const Color(0xffffb56b),
                      //       textController: textController,
                      //       suffixIcon: const Icon(
                      //         Icons.search,
                      //         color: Colors.black,
                      //         size: 26,
                      //       ),
                      //       onSuffixTap: () async {
                      //         textController.text == ""
                      //             ? log("No city entered")
                      //             : setState(() {
                      //                 _myData = getData(false, textController.text);
                      //               });
                      //
                      //         FocusScope.of(context).unfocus();
                      //         textController.clear();
                      //       },
                      //       style: f14RblackLetterSpacing2,
                      //       onSubmitted: (String) {},
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           Center(
                      //             child: Image.network(
                      //                 "https://openweathermap.org/img/wn/${data.icon}@4x.png"),
                      //           ),
                      //           Text(
                      //             data.city,
                      //             style: f24Rwhitebold,
                      //           ),
                      //           height25,
                      //           Text(
                      //             data.desc,
                      //             style: f16PW,
                      //           ),
                      //           height25,
                      //           Text(
                      //             "${data.temp}°C",
                      //             style: f42Rwhitebold,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("${snapshot.connectionState} occured"),
            );
          }
          return const Center(
            child: Text("Server timed out!"),
          );
        },
        future: _myData!,
      ),
    );
  }
}
