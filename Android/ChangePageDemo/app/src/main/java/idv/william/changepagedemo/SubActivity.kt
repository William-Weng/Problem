package idv.william.changepagedemo

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import idv.william.Extensions._Activity._findViewById

class SubActivity : AppCompatActivity() {

    private val subButton by _findViewById<Button>(R.id.subButton)
    private val bundleTextView1 by _findViewById<TextView>(R.id.bundleTextView1)
    private val bundleTextView2 by _findViewById<TextView>(R.id.bundleTextView2)

    private val helper = SubActivity.Helper()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initSetting()
    }

    private fun initSetting() {

        helper.defaultSetting(activity = this)

        subButton.setOnClickListener {

            val bundle = intent.extras
            val intArray = bundle?.getIntArray("intArray")
            val stringArray = bundle?.getStringArray("stringArray")

            bundleTextView1.text = intArray?.joinToString()
            bundleTextView2.text = stringArray?.joinToString()
        }
    }

    private class Helper {

        /**
         * 系統預設設定值
         * @param activity AppCompatActivity
         */
        fun defaultSetting(activity: AppCompatActivity) {

            activity.enableEdgeToEdge()
            activity.setContentView(R.layout.activity_sub)

            ViewCompat.setOnApplyWindowInsetsListener(activity.findViewById(R.id.main)) { v, insets ->
                val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
                v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
                insets
            }
        }
    }
}