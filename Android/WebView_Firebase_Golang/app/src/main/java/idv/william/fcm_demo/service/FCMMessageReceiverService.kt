package idv.william.fcm_demo.service

import android.os.Bundle
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import idv.william.Utility
import idv.william.fcm_demo.MainActivity
import idv.william.fcm_demo.R

class FCMMessageReceiverService : FirebaseMessagingService() {

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("[TOKEN]", token)
    }

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)

        message.notification?.body?.let { body ->

            val bundle = Bundle()

            message.data.let {
                val url = it["url"]
                bundle.putString("url", url)
                Log.d("[TOKEN_Message]", it.toString())
            }

            message.notification?.title?.let { title ->
                val icon = R.drawable.next_page
                Utility._Notification.dialog(MainActivity::class.java,this, "channelId", "channelName", title, body, icon, bundle)
            }
        }
    }
}