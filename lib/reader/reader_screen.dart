import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:rehearse_app/reader/camreader_handler.dart';
import 'package:rehearse_app/reader/speed_read.dart';
import 'package:rehearse_app/shared/dismissable_bottom_sheet.dart';
import 'package:rehearse_app/shared/styles.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
  });
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  TextEditingController textController = TextEditingController();
  SpeedReadCounter counter = SpeedReadCounter();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "option.select",
        child: Builder(builder: (context) {
          var widgetColor = accent.withAlpha(125);
          var outlineInputBorder = const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                  style: BorderStyle.solid, width: 4, color: accent));
          var buttonStyle = ElevatedButton.styleFrom(
              backgroundColor: accent,
              shape: const BeveledRectangleBorder(),
              foregroundColor: white);
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: accentLight,
              appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: widgetColor,
                  title: Text(
                    "ReaderApp",
                    style: pBold.copyWith(color: black),
                  ),
                  leading: SizedBox(
                      width: 20,
                      child: IconButton.filled(
                        style: IconButton.styleFrom(
                            backgroundColor: widgetColor,
                            shape: const RoundedRectangleBorder()),
                        icon: const Icon(
                          FontAwesomeIcons.backward,
                          color: black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))),
              body: Builder(builder: (context) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ukoliko trebaš nešto brzo prenijeti iz sveske ili pročitati, na pravom si mjestu.",
                            textAlign: TextAlign.center,
                            style: p3,
                          ),
                        ),
                      ),
                      Text(
                        "Riječi po minuti (WPM):",
                        style: pBold.copyWith(color: black),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        counter.wordsPerMinute.toString(),
                        style: dialogText.copyWith(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      Slider(
                        value: counter.wordsPerMinute.toDouble(),
                        activeColor: black,
                        min: 1,
                        max: 1000,
                        onChanged: (value) {
                          setState(() {
                            counter.wordsPerMinute = value.ceil();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: IconButton.filled(
                                style: IconButton.styleFrom(
                                  shape: const RoundedRectangleBorder(),
                                  backgroundColor: widgetColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    counter.wordsPerMinute--;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.minus,
                                  size: 20,
                                )),
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: IconButton.filled(
                                style: IconButton.styleFrom(
                                    shape: const RoundedRectangleBorder(),
                                    backgroundColor: accent),
                                onPressed: () {
                                  setState(() {
                                    counter.wordsPerMinute++;
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  size: 20,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: textController,
                          style: p1,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              label: Text(
                                "Napiši ili skeniraj vlastiti tekst",
                                style: p2.copyWith(color: Colors.black38),
                              ),
                              fillColor: accentLight,
                              filled: true,
                              focusedBorder: outlineInputBorder,
                              enabledBorder: outlineInputBorder),
                          minLines: 5,
                          maxLines: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => _cameraView(
                                        textController: textController,
                                      ),
                                    ));
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.cameraRetro,
                                  ),
                                  style: buttonStyle,
                                  label: Text(
                                    "Skeniraj tekst",
                                    softWrap: false,
                                    style: p3,
                                  )),
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (textController.text.isEmpty) return;
                                    Clipboard.setData(ClipboardData(
                                        text: textController.text));
                                    DismissableBottomSheet.show(
                                        context: context,
                                        durationInSeconds: 5,
                                        content: Text(
                                            "Uspješno kopirano u međuspremnik!",
                                            textAlign: TextAlign.center,
                                            style: p1.copyWith(color: white)));
                                  },
                                  icon: const Icon(FontAwesomeIcons.clipboard),
                                  style: buttonStyle,
                                  label: Text(
                                    "Kopiraj",
                                    softWrap: false,
                                    style: p3,
                                  )),
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (textController.text.isEmpty) return;
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SpeedReedScreen(
                                          designatedText: textController.text,
                                          speed: counter.wordsPerMinute),
                                    ));
                                  },
                                  icon: const Icon(FontAwesomeIcons.play),
                                  style: buttonStyle,
                                  label: Text(
                                    "Pokreni brzo čitanje",
                                    softWrap: false,
                                    style: p3,
                                  )),
                            ),
                          ],
                        ),
                      )
                    ]);
              }));
        }));
  }
}

class _cameraView extends StatefulWidget {
  const _cameraView({
    super.key,
    required this.textController,
  });
  final TextEditingController textController;

  @override
  State<_cameraView> createState() => _cameraViewState();
}

class _cameraViewState extends State<_cameraView> {
  @override
  void initState() {
    _initializeCameraPreview();
    super.initState();
  }

  @override
  void dispose() {
    _finishCameraPreview();
    super.dispose();
  }

  Future _finishCameraPreview() async {
    await checkImageStream(assertStart: false);

    _controller?.dispose();
    CameraReaderHandler.camController = null;
    CameraReaderHandler.cameras == [];
  }

  CameraImage? _savedImage;
  CameraController? _controller;
  bool focusPointSelected = false;
  double focusPointY = 0;
  double focusPointX = 0;
  @override
  Widget build(BuildContext context) {
    if (_controller == null ||
        _controller?.value.isInitialized == false ||
        CameraReaderHandler.cameras.isEmpty) {
      _controller = CameraReaderHandler.camController;
      return const Center(
        child: CircularProgressIndicator(
          color: white,
        ),
      );
    }

    return Stack(
      children: [
        Container(
          child: CameraPreview(
            _controller!,
          ),
        ),
        GestureDetector(
          onTapUp: (details) {
            _setFocusPoint(details);
          },
          onScaleStart: (details) => CameraReaderHandler.baseZoomLevel =
              CameraReaderHandler.currentZoomLevel,
          onScaleUpdate: (details) async {
            CameraReaderHandler.currentZoomLevel =
                (CameraReaderHandler.baseZoomLevel * details.scale).clamp(
                    CameraReaderHandler.minAvailableZoom,
                    CameraReaderHandler.maxAvailableZoom);
            await _controller!
                .setZoomLevel(CameraReaderHandler.currentZoomLevel);
          },
        ),
        (focusPointSelected)
            ? Positioned(
                top: focusPointY - 10,
                left: focusPointX - 10,
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: white, width: 2))))
            : Positioned(child: Container()),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 35),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.xmark),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        (MediaQuery.of(context).size.width / 4).toDouble()),
                child: FloatingActionButton(
                  backgroundColor: Colors.white24,
                  onPressed: () async {
                    InputImage? inputImage = CameraReaderHandler()
                        .extractFromCameraImage(_savedImage!);

                    widget.textController.text =
                        await CameraReaderHandler().processImage(inputImage!);

                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future _setFocusPoint(TapUpDetails details) async {
    if (_controller?.value.isInitialized == true && _controller != null) {
      focusPointSelected = true;
      focusPointX = details.localPosition.dx;
      focusPointY = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * _controller!.value.aspectRatio;
      double xOffset = (focusPointX / fullWidth).clamp(0, 1);
      double yOffset = (focusPointX / cameraHeight).clamp(0, 1);
      Offset point = Offset(xOffset, yOffset);

      await _controller?.setFocusPoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            focusPointSelected = false;
          });
        });
      });
    }
  }

  Future _initializeCameraPreview() async {
    if (CameraReaderHandler.cameras.isEmpty) {
      CameraReaderHandler.cameras = await availableCameras();
    }
    final camera = CameraReaderHandler.cameras[0];
    _controller = CameraController(camera, ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888);
    CameraReaderHandler.camController = _controller;
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.setFocusMode(FocusMode.auto);
      _controller?.getMinZoomLevel().then((value) {
        CameraReaderHandler.currentZoomLevel = value;
        CameraReaderHandler.minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        CameraReaderHandler.maxAvailableZoom = value;
      });
      checkImageStream(assertStart: true);
      setState(() {});
    });
  }

  Future checkImageStream({required bool assertStart}) async {
    if (assertStart) {
      await _controller?.startImageStream((image) {
        _savedImage = image;
      });
    } else {
      try {
        await _controller?.stopImageStream();
      } catch (CameraException) {
        return;
      }
    }
  }
}
