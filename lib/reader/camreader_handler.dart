// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraReaderHandler {
  static List<CameraDescription> cameras = [];

  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  bool _recognizerBusy = false;
  bool _recognizerCanProcess = true;
  String? recognizedText;
  static CameraController? camController;

  final _cameraOrientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  static double currentZoomLevel = 1.0;
  static double minAvailableZoom = 1.0;
  static double maxAvailableZoom = 1.0;
  static double baseZoomLevel = 1.0;

  InputImage? extractFromCameraImage(CameraImage camImage) {
    final camera = cameras[0];
    final orientationFromSensor = camera.sensorOrientation;

    InputImageRotation? inputImageOrientation;
    // get the image orientation
    if (Platform.isIOS) {
      inputImageOrientation =
          InputImageRotationValue.fromRawValue(orientationFromSensor);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _cameraOrientations[camController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation =
            (orientationFromSensor + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (orientationFromSensor - rotationCompensation + 360) % 360;
      }
      inputImageOrientation =
          InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (inputImageOrientation == null) return null;

    final format = InputImageFormatValue.fromRawValue(camImage.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
    if (camImage.planes.length != 1) return null;

    return InputImage.fromBytes(
        bytes: camImage.planes.first.bytes,
        metadata: InputImageMetadata(
            size: Size(camImage.width.toDouble(), camImage.height.toDouble()),
            rotation: inputImageOrientation,
            format: format,
            bytesPerRow: camImage.planes.first.bytesPerRow));
  }

  Future processImage(InputImage? extractedImage) async {
    if (!_recognizerCanProcess || _recognizerBusy) return;
    _recognizerBusy = true;
    final recognized = await _textRecognizer.processImage(extractedImage!);
    return recognized.text;
  }
}
