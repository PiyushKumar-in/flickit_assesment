package com.example.flickit_assesment

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Base64
import androidx.core.net.toUri
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.objects.ObjectDetection
import com.google.mlkit.vision.objects.defaults.ObjectDetectorOptions
import java.io.File
import java.io.IOException

class MainActivity : FlutterActivity(){
    private val options = ObjectDetectorOptions.Builder()
        .setDetectorMode(ObjectDetectorOptions.SINGLE_IMAGE_MODE)
        .enableMultipleObjects()
        .enableClassification()  // Optional
        .build()
    val objectDetector = ObjectDetection.getClient(options)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"ML_KIT_CHANNEL")
        channel.setMethodCallHandler { call, result ->
            if (call.method == "MlMethod"){
                val filePath = call.argument<String>("filePath")!!
                val fileName = call.argument<String>("fileName")!!

                val file = File(filePath)
                val image: InputImage
                try {
                    image = InputImage.fromFilePath(context, file.toUri())
                    objectDetector.process(image)
                        .addOnSuccessListener { detectedObjects ->
                            val resultList = detectedObjects.map { obj ->
                                val boundingBox = obj.boundingBox
                                val labels = obj.labels.map { label ->
                                    mapOf(
                                        "text" to label.text,
                                        "confidence" to label.confidence,
                                        "index" to label.index
                                    )
                                }

                                mapOf(
                                    "trackingId" to obj.trackingId,
                                    "boundingBox" to mapOf(
                                        "left" to boundingBox.left,
                                        "top" to boundingBox.top,
                                        "right" to boundingBox.right,
                                        "bottom" to boundingBox.bottom
                                    ),
                                    "labels" to labels
                                )
                            }

                            result.success(resultList)
                        }
                        .addOnFailureListener {}
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }else if (call.method == "MlMethodStream"){
                val filePath = call.argument<String>("filePath")!!
                val fileName = call.argument<String>("fileName")!!

                val file = File(filePath)
                val image: InputImage
                try {
                    image = InputImage.fromFilePath(context, file.toUri())
                    objectDetector.process(image)
                        .addOnSuccessListener { detectedObjects ->
                            val resultList = detectedObjects.map { obj ->
                                val boundingBox = obj.boundingBox
                                val labels = obj.labels.map { label ->
                                    mapOf(
                                        "text" to label.text,
                                        "confidence" to label.confidence,
                                        "index" to label.index
                                    )
                                }

                                mapOf(
                                    "trackingId" to obj.trackingId,
                                    "boundingBox" to mapOf(
                                        "left" to boundingBox.left,
                                        "top" to boundingBox.top,
                                        "right" to boundingBox.right,
                                        "bottom" to boundingBox.bottom
                                    ),
                                    "labels" to labels
                                )
                            }

                            result.success(resultList)
                        }
                        .addOnFailureListener {}
                } catch (e: IOException) {
                    e.printStackTrace()
                }
            }
        }
    }
}