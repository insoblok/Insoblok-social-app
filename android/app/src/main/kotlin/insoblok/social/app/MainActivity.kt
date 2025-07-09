package insoblok.social.app

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val TAG = "MainActivity"

  private val REQUEST_VIDEO_CODE = 10001

  private val eventsChannel = "insoblok.social.app/events"

  private val videoFilterChannel = "insoblok.social.app/video-filter"
  private lateinit var videoFilterResult: MethodChannel.Result

  private var linksReceiver: BroadcastReceiver? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    EventChannel(flutterEngine?.dartExecutor?.binaryMessenger, eventsChannel).setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(args: Any?, events: EventChannel.EventSink) {
          linksReceiver = createChangeReceiver(events)
        }
        override fun onCancel(args: Any?) {
          linksReceiver = null
        }
      }
    )
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
      super.configureFlutterEngine(flutterEngine)

      MethodChannel(
          flutterEngine.dartExecutor.binaryMessenger,
          videoFilterChannel
      ).setMethodCallHandler { call, result ->
          if (call.method == "onPicker") {
              this.videoFilterResult = result

              val videoIntent = Intent(
                  this@MainActivity,
                  DeepAIActivity::class.java
              )
              this@MainActivity.startActivityForResult(videoIntent, REQUEST_VIDEO_CODE)
          } else {
              result.notImplemented()
          }
      }
  }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    if (intent.action === Intent.ACTION_VIEW) {
      linksReceiver?.onReceive(this.applicationContext, intent)
    }
  }

  fun createChangeReceiver(events: EventChannel.EventSink): BroadcastReceiver {
    return object : BroadcastReceiver() {
      override fun onReceive(context: Context, intent: Intent) {
        val dataString = intent.dataString ?:
        events.error("UNAVAILABLE", "Link unavailable", null)
        events.success(dataString)
      }
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    
    when (requestCode) {
        REQUEST_VIDEO_CODE -> {
            Log.d(TAG, "onActivityResult")
            if (resultCode == Activity.RESULT_OK) {
                val result = data?.getStringExtra("result")
                Log.d(TAG, result!!)
                videoFilterResult.success(result)
            } else if (resultCode == Activity.RESULT_CANCELED) {
                videoFilterResult.notImplemented()
            }
        }
    }
}
}
