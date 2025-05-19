package insoblok.social.app

import io.flutter.embedding.android.FlutterActivity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
  private val eventsChannel = "insoblok.social.app/events"
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

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    if (intent.action === Intent.ACTION_VIEW) {
      linksReceiver?.onReceive(this.applicationContext, intent)
    }
  }

  fun createChangeReceiver(events: EventChannel.EventSink): BroadcastReceiver? {
    return object : BroadcastReceiver() {
      override fun onReceive(context: Context, intent: Intent) {
        val dataString = intent.dataString ?:
        events.error("UNAVAILABLE", "Link unavailable", null)
        events.success(dataString)
      }
    }
  }
}
