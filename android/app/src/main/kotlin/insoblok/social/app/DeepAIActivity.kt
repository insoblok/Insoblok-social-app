package insoblok.social.app

import ai.deepar.ar.ARErrorType
import ai.deepar.ar.AREventListener
import ai.deepar.ar.ARTouchInfo
import ai.deepar.ar.ARTouchType
import ai.deepar.ar.CameraResolutionPreset
import ai.deepar.ar.DeepAR
import ai.deepar.ar.DeepARImageFormat
import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.media.Image
import android.os.Bundle
import android.os.Environment
import android.text.format.DateFormat
import android.util.DisplayMetrics
import android.util.Log
import android.util.Size
import android.view.MotionEvent
import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.text.SimpleDateFormat
import java.util.Date
import java.util.concurrent.ExecutionException
import com.google.common.util.concurrent.ListenableFuture


@Suppress("DEPRECATION")
class DeepAIActivity : AppCompatActivity(), SurfaceHolder.Callback,
    AREventListener {
    // Default camera lens value, change to CameraSelector.LENS_FACING_BACK to initialize with back camera
    private val defaultLensFacing = CameraSelector.LENS_FACING_FRONT
    private var surfaceProvider: ARSurfaceProvider? = null
    private var lensFacing = defaultLensFacing
    private var cameraProviderFuture: ListenableFuture<ProcessCameraProvider>? =
        null
    private lateinit var buffers: Array<ByteBuffer?>
    private var currentBuffer = 0
    private var deepAR: DeepAR? = null

    private var currentEffect = 0

    private val screenOrientation: Int
        /*
                       get interface orientation from
                       https://stackoverflow.com/questions/10380989/how-do-i-get-the-current-orientation-activityinfo-screen-orientation-of-an-a/10383164
                    */
        get() {
            val rotation: Int = windowManager.defaultDisplay.rotation
            val dm = DisplayMetrics()
            windowManager.defaultDisplay.getMetrics(dm)
            width = dm.widthPixels
            height = dm.heightPixels
            // if the device's natural orientation is portrait:
            val orientation = if ((rotation == Surface.ROTATION_0
                        || rotation == Surface.ROTATION_180) && height > width ||
                (rotation == Surface.ROTATION_90
                        || rotation == Surface.ROTATION_270) && width > height
            ) {
                when (rotation) {
                    Surface.ROTATION_0 -> ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    Surface.ROTATION_90 -> ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                    Surface.ROTATION_180 -> ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT
                    Surface.ROTATION_270 -> ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE
                    else -> ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                }
            } else {
                when (rotation) {
                    Surface.ROTATION_0 -> ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                    Surface.ROTATION_90 -> ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                    Surface.ROTATION_180 -> ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE
                    Surface.ROTATION_270 -> ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT
                    else -> ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                }
            }

            return orientation
        }

    private var effects: ArrayList<String>? = null

    private var recording = false
    private var currentSwitchRecording = false

    private var width = 0
    private var height = 0

    private var videoFile: File? = null

    private val TAG = "DeepAIActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_deep_ai)
    }

    override fun onStart() {
        val cameraPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.CAMERA
        )
        Log.d(TAG, cameraPermission.toString())

        val recordPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO
        )
        Log.d(TAG, recordPermission.toString())

        if (cameraPermission != PackageManager.PERMISSION_GRANTED ||
            recordPermission != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this, arrayOf(Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO),
                1
            )
        } else {
            Log.d(TAG, "Start initialize")
            initialize()
        }
        super.onStart()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 1 && grantResults.isNotEmpty()) {
            for (grantResult in grantResults) {
                if (grantResult != PackageManager.PERMISSION_GRANTED) {
                    return  // no permission
                }
            }
            initialize()
        }
    }

    private fun initialize() {
        initializeDeepAR()
        initializeFilters()
        initializeViews()
    }

    private fun initializeFilters() {
        Log.d(TAG, "Start initializeFilters")
        effects = ArrayList()
        effects!!.add("none")
        effects!!.add("viking_helmet.deepar")
        effects!!.add("MakeupLook.deepar")
        effects!!.add("Split_View_Look.deepar")
        effects!!.add("Emotions_Exaggerator.deepar")
        effects!!.add("Emotion_Meter.deepar")
        effects!!.add("Stallone.deepar")
        effects!!.add("flower_face.deepar")
        effects!!.add("galaxy_background.deepar")
        effects!!.add("Humanoid.deepar")
        effects!!.add("Neon_Devil_Horns.deepar")
        effects!!.add("Ping_Pong.deepar")
        effects!!.add("Pixel_Hearts.deepar")
        effects!!.add("Snail.deepar")
        effects!!.add("Hope.deepar")
        effects!!.add("Vendetta_Mask.deepar")
        effects!!.add("Fire_Effect.deepar")
        effects!!.add("burning_effect.deepar")
        effects!!.add("Elephant_Trunk.deepar")
        Log.d(TAG, "End initializeFilters")
    }

    @SuppressLint("ClickableViewAccessibility", "SimpleDateFormat")
    private fun initializeViews() {
        Log.d(TAG, "Start initializeViews")

        val previousMask: ImageButton = findViewById(R.id.previousMask)
        val nextMask: ImageButton = findViewById(R.id.nextMask)

        val arView: SurfaceView = findViewById(R.id.surface)

        arView.setOnTouchListener { _: View?, motionEvent: MotionEvent ->
            when (motionEvent.action) {
                MotionEvent.ACTION_DOWN -> {
                    deepAR?.touchOccurred(
                        ARTouchInfo(
                            motionEvent.x,
                            motionEvent.y,
                            ARTouchType.Start
                        )
                    )
                    return@setOnTouchListener true
                }

                MotionEvent.ACTION_MOVE -> {
                    deepAR?.touchOccurred(
                        ARTouchInfo(
                            motionEvent.x,
                            motionEvent.y,
                            ARTouchType.Move
                        )
                    )
                    return@setOnTouchListener true
                }

                MotionEvent.ACTION_UP -> {
                    deepAR?.touchOccurred(
                        ARTouchInfo(
                            motionEvent.x,
                            motionEvent.y,
                            ARTouchType.End
                        )
                    )
                    return@setOnTouchListener true
                }
            }
            false
        }

        arView.holder.addCallback(this)

        // Surface might already be initialized, so we force the call to onSurfaceChanged
        arView.visibility = View.GONE
        arView.visibility = View.VISIBLE

        val screenshotBtn: ImageButton = findViewById(R.id.recordButton)
        screenshotBtn.setOnClickListener { deepAR?.takeScreenshot() }

        val switchCamera: ImageButton = findViewById(R.id.switchCamera)
        switchCamera.setOnClickListener {
            lensFacing =
                if (lensFacing == CameraSelector.LENS_FACING_FRONT) CameraSelector.LENS_FACING_BACK else CameraSelector.LENS_FACING_FRONT
            //unbind immediately to avoid mirrored frame.
            val cameraProvider: ProcessCameraProvider?
            try {
                cameraProvider = cameraProviderFuture!!.get()
                cameraProvider.unbindAll()
            } catch (e: ExecutionException) {
                e.printStackTrace()
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
            setupCamera()
        }

        val openActivity: ImageButton = findViewById(R.id.openActivity)
        openActivity.setOnClickListener {
            setResult(Activity.RESULT_CANCELED)
            finish()
        }


        val screenShotModeButton: TextView = findViewById(R.id.screenshotModeButton)
        val recordModeBtn: TextView = findViewById(R.id.recordModeButton)

        recordModeBtn.background.alpha = 0x00
        screenShotModeButton.background.alpha = 0xA0

        screenShotModeButton.setOnClickListener(View.OnClickListener {
            if (currentSwitchRecording) {
                if (recording) {
                    Toast.makeText(
                        applicationContext,
                        "Cannot switch to screenshots while recording!",
                        Toast.LENGTH_SHORT
                    ).show()
                    return@OnClickListener
                }

                recordModeBtn.background.alpha = 0x00
                screenShotModeButton.background.alpha = 0xA0
                screenshotBtn.setOnClickListener { deepAR?.takeScreenshot() }

                currentSwitchRecording = !currentSwitchRecording
            }
        })



        recordModeBtn.setOnClickListener {
            if (!currentSwitchRecording) {
                recordModeBtn.background.alpha = 0xA0
                screenShotModeButton.background.alpha = 0x00
                screenshotBtn.setOnClickListener {
                    if (recording) {
                        deepAR?.stopVideoRecording()
                        // val mediaScanIntent =
                        //     Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
                        // val contentUri = Uri.fromFile(videoFileName)
                        // mediaScanIntent.setData(contentUri)
                        // sendBroadcast(mediaScanIntent)
                        Toast.makeText(
                            applicationContext,
                            "Recording " + videoFile!!.name + " saved.",
                            Toast.LENGTH_LONG
                        ).show()

                        val resultIntent = Intent()
                        resultIntent.putExtra("result", videoFile!!.path)
                        setResult(Activity.RESULT_OK, resultIntent)
                        finish()
                    } else {
                        videoFile = File(
                            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES),
                            "video_" + SimpleDateFormat("yyyy_MM_dd_HH_mm_ss")
                                .format(Date()) + ".mp4"
                        )
                        deepAR?.startVideoRecording(
                            videoFile.toString(),
                            width / 2,
                            height / 2
                        )
                        Toast.makeText(
                            applicationContext,
                            "Recording started.",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                    recording = !recording
                }

                currentSwitchRecording = !currentSwitchRecording
            }
        }

        previousMask.setOnClickListener { gotoPrevious() }

        nextMask.setOnClickListener { gotoNext() }

        Log.d(TAG, "End initializeViews")
    }

    private fun initializeDeepAR() {
        Log.d(TAG, "Start initializeDeepAR")
        deepAR = DeepAR(this)
        deepAR?.setLicenseKey("3be3727479198503050f6abbeeb068065c3a196e3f3e8c5bc0233f37fb01efece1d07e97a14e4925")
        deepAR?.initialize(this, this)
        setupCamera()
        Log.d(TAG, "End initializeDeepAR")
    }

    private fun setupCamera() {
        Log.d(TAG, "Start Camera Setup")
        cameraProviderFuture = ProcessCameraProvider.getInstance(this)
        cameraProviderFuture!!.addListener({
            try {
                val cameraProvider: ProcessCameraProvider = cameraProviderFuture!!.get()
                bindImageAnalysis(cameraProvider)
            } catch (e: ExecutionException) {
                e.printStackTrace()
            } catch (e: InterruptedException) {
                e.printStackTrace()
            }
        }, ContextCompat.getMainExecutor(this))
        Log.d(TAG, "End Camera Setup")
    }

    private fun bindImageAnalysis(cameraProvider: ProcessCameraProvider) {
        val cameraResolutionPreset: CameraResolutionPreset = CameraResolutionPreset.P1920x1080
        val width: Int
        val height: Int
        val orientation = screenOrientation
        if (orientation == ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE || orientation == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
            width = cameraResolutionPreset.width
            height = cameraResolutionPreset.height
        } else {
            width = cameraResolutionPreset.height
            height = cameraResolutionPreset.width
        }

        val cameraResolution = Size(width, height)
        val cameraSelector = CameraSelector.Builder().requireLensFacing(lensFacing).build()

        if (useExternalCameraTexture) {
            val preview = Preview.Builder()
                .setTargetResolution(cameraResolution)
                .build()

            cameraProvider.unbindAll()
            cameraProvider.bindToLifecycle(this as LifecycleOwner, cameraSelector, preview)
            if (surfaceProvider == null) {
                surfaceProvider = ARSurfaceProvider(this, deepAR!!)
            }
            preview.surfaceProvider = surfaceProvider
            surfaceProvider!!.setMirror(lensFacing == CameraSelector.LENS_FACING_FRONT)
        } else {
            buffers = arrayOfNulls(NUMBER_OF_BUFFERS)
            for (i in 0..<NUMBER_OF_BUFFERS) {
                buffers[i] = ByteBuffer.allocateDirect(width * height * 4)
                buffers[i]?.order(ByteOrder.nativeOrder())
                buffers[i]?.position(0)
            }

            val imageAnalysis = ImageAnalysis.Builder()
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                .setTargetResolution(cameraResolution)
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()
            imageAnalysis.setAnalyzer(ContextCompat.getMainExecutor(this), imageAnalyzer)
            cameraProvider.unbindAll()
            cameraProvider.bindToLifecycle(this as LifecycleOwner, cameraSelector, imageAnalysis)
        }
    }

    private val imageAnalyzer =
        ImageAnalysis.Analyzer { image ->
            val buffer = image.planes[0].buffer
            buffer.rewind()
            buffers[currentBuffer]!!.put(buffer)
            buffers[currentBuffer]!!.position(0)
            if (deepAR != null) {
                deepAR!!.receiveFrame(
                    buffers[currentBuffer],
                    image.width, image.height,
                    image.imageInfo.rotationDegrees,
                    lensFacing == CameraSelector.LENS_FACING_FRONT,
                    DeepARImageFormat.RGBA_8888,
                    image.planes[0].pixelStride
                )
            }
            currentBuffer = (currentBuffer + 1) % NUMBER_OF_BUFFERS
            image.close()
        }


    private fun getFilterPath(filterName: String): String? {
        if (filterName == "none") {
            return null
        }
        return "file:///android_asset/$filterName"
    }

    private fun gotoNext() {
        currentEffect = (currentEffect + 1) % effects!!.size
        deepAR?.switchEffect("effect", getFilterPath(effects!![currentEffect]))
    }

    private fun gotoPrevious() {
        currentEffect = (currentEffect - 1 + effects!!.size) % effects!!.size
        deepAR?.switchEffect("effect", getFilterPath(effects!![currentEffect]))
    }

    override fun onStop() {
        recording = false
        currentSwitchRecording = false
        val cameraProvider: ProcessCameraProvider?
        try {
            cameraProvider = cameraProviderFuture?.get()
            cameraProvider?.unbindAll()
        } catch (e: ExecutionException) {
            e.printStackTrace()
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
        if (surfaceProvider != null) {
            surfaceProvider!!.stop()
            surfaceProvider = null
        }
        deepAR?.release()
        deepAR = null
        super.onStop()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (surfaceProvider != null) {
            surfaceProvider!!.stop()
        }
        if (deepAR == null) {
            return
        }
        deepAR?.setAREventListener(null)
        deepAR?.release()
        deepAR = null
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
        // If we are using on screen rendering we have to set surface view where DeepAR will render
        deepAR?.setRenderSurface(holder.surface, width, height)
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        if (deepAR != null) {
            deepAR?.setRenderSurface(null, 0, 0)
        }
    }

    override fun screenshotTaken(bitmap: Bitmap) {
        val now = DateFormat.format("yyyy_MM_dd_hh_mm_ss", Date())
        try {
            val imageFile = File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                "image_$now.jpg"
            )
            val outputStream = FileOutputStream(imageFile)
            val quality = 100
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream)
            outputStream.flush()
            outputStream.close()
            // val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
            // val contentUri = Uri.fromFile(imageFile)
            // mediaScanIntent.setData(contentUri)
            // this.sendBroadcast(mediaScanIntent)
            Toast.makeText(
                this,
                "Screenshot " + imageFile.name + " saved.",
                Toast.LENGTH_SHORT
            ).show()

            val resultIntent = Intent()
            resultIntent.putExtra("result", imageFile.path)
            setResult(Activity.RESULT_OK, resultIntent)
            finish()
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    override fun videoRecordingStarted() {
    }

    override fun videoRecordingFinished() {
    }

    override fun videoRecordingFailed() {
    }

    override fun videoRecordingPrepared() {
    }

    override fun shutdownFinished() {
    }

    override fun initialized() {
        // Restore effect state after deepar release
        deepAR?.switchEffect("effect", getFilterPath(effects!![currentEffect]))
    }

    override fun faceVisibilityChanged(b: Boolean) {
    }

    override fun imageVisibilityChanged(s: String?, b: Boolean) {
    }

    override fun frameAvailable(image: Image?) {
    }

    override fun error(arErrorType: ARErrorType?, s: String?) {
    }


    override fun effectSwitched(s: String?) {
    }

    companion object {
        private const val NUMBER_OF_BUFFERS = 2
        private const val useExternalCameraTexture = false
    }
}
