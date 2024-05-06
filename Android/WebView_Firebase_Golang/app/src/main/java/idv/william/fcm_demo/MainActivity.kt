package idv.william.fcm_demo

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.KeyEvent
import android.webkit.WebView
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.firebase.messaging.FirebaseMessaging
import idv.william.Extensions._Activity._findViewById
import idv.william.Extensions._AppCompatActivity._actionBarHidden
import idv.william.Extensions._AppCompatActivity._replaceFragment
import idv.william.Extensions._Intent._setClass
import idv.william.Utility

interface MainActivityService {

    /**
     * 改變Title / 按鍵的狀態
     * @param webView WebView?
     * @param title String?
     */
    fun changeTitle(webView: WebView?, title: String?)

    /**
     * 顯示Dialog
     */
    fun displayDialog()

    /**
     * 清除Dialog
     */
    fun dismissDialog()
}

/**
 * 主頁
 */
class MainActivity : AppCompatActivity(), MainActivityService {

    private val helper = Helper()

    private val titleTextView by _findViewById<TextView>(R.id.titleTextView)
    private val backPageImageButton by _findViewById<ImageButton>(R.id.backPageImageButton)
    private val nextPageImageButton by _findViewById<ImageButton>(R.id.nextPageImageButton)
    private val homePageImageButton by _findViewById<ImageButton>(R.id.homePageImageButton)

    private val webViewFragment: WebViewFragment by lazy { WebViewFragment() }

    private var resultLauncher = Utility._Intent.resultLauncher(activity = this, contract = ActivityResultContracts.StartActivityForResult(), action = ::activityResult)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        initSetting()
        initButtonsClickListener()
        firebaseSetting()
        reloadWebView(intent = intent)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return onKeyDownAction(keyCode = keyCode, event = event)
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        reloadWebView(intent = intent)
    }

    override fun changeTitle(webView: WebView?, title: String?) {
        changeTitleAction(webView = webView, title = title)
    }

    override fun displayDialog() {
        helper.displayDialogAction()
    }

    override fun dismissDialog() {
        helper.dismissDialogAction()
    }

    /**
     * 初始化設定
     */
    private fun initSetting() {

        this.webViewFragment.mainService = this
        this._actionBarHidden()
        this._replaceFragment(id = R.id.fragmentContainer, fragment = webViewFragment)

        helper.context = this
        helper.resultLauncher = resultLauncher
        helper.defaultSetting(app = this)
    }

    /**
     * 初始化ButtonOnClickListener
     */
    private fun initButtonsClickListener() {
        homePageImageButton.setOnClickListener { webViewFragment.goHome() }
        nextPageImageButton.setOnClickListener { webViewFragment.goForward() }
        backPageImageButton.setOnClickListener { webViewFragment.goBack() }
    }

    /**
     * 按下按鍵的反應 => 按下Back鍵沒反應
     * @param keyCode Int
     * @param event: KeyEvent?
     * @return Boolean
     */
    private fun onKeyDownAction(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_BACK) { return false }
        return super.onKeyDown(keyCode, event)
    }

    /**
     * 上一頁傳回來的結果
     * @param result: ActivityResult
     */
    private fun activityResult(result: ActivityResult) {

        val bundle = result.data?.extras

        if (result.resultCode == Activity.RESULT_OK) {
            Log.d("MainReturn", "${bundle?.getIntArray("arrayA")?.joinToString()}")
        }
    }

    /**
     * Firebase設定 (取得Token)
     */
    private fun firebaseSetting() {

        FirebaseMessaging.getInstance().subscribeToTopic("news")
        FirebaseMessaging.getInstance().token.addOnCompleteListener {

            if (it.isSuccessful) {
                val token = it.result
                Toast.makeText(this, token, Toast.LENGTH_LONG).show()
                Log.d("Main_Token", token)
            }
        }
    }

    /**
     * WebView更換Url
     * => android:configChanges="orientation|screenSize"
     * => android:launchMode="singleTop"
     * @param intent: Intent?
     */
    private fun reloadWebView(intent: Intent?) {

        val bundle = intent?.extras
        val url = bundle?.getString("url")

        url?.let {
            Toast.makeText(this, url, Toast.LENGTH_LONG).show()
            webViewFragment.reloadWebView(url = url)
        }
    }

    /**
     * Helper相關小工具
     */
    private class Helper {

        var context: Context? = null
        var resultLauncher: ActivityResultLauncher<Intent>? = null

        /**
         * 系統預設的設定
         * @param app: AppCompatActivity
         */
        fun defaultSetting(app: AppCompatActivity) {

            // enableEdgeToEdge()
            app.setContentView(R.layout.activity_main)

            ViewCompat.setOnApplyWindowInsetsListener(app.findViewById(R.id.main)) { view, insets ->
                val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
                view.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
                insets
            }
        }

        /**
         * 顯示Dialog
         */
        fun displayDialogAction() {
            nextPage(`class` = LoadingActivity::class.java)
        }

        /**
         * 取消Dialog
         * @param delayMillis Long
         */
        fun dismissDialogAction(delayMillis: Long = 500) {
            val handler = Handler(Looper.getMainLooper())
            handler.postDelayed({ LoadingActivity.Instance?.finish() }, delayMillis)
        }

        /**
         * 跳轉到下一頁
         * @param class 哪一頁？
         */
        fun <T: AppCompatActivity> nextPage(`class`: Class<T>) {

            context?.let {
                val intent = Intent()
                intent._setClass(context = it, `class` = `class`, bundle = null)
                resultLauncher?.launch(intent)
            }
        }
    }

    /**
     * 改變Title / 按鍵的狀態
     * @param webView WebView?
     * @param title String?
     */
    private fun changeTitleAction(webView: WebView?, title: String?) {

        val canGoBack = webView?.canGoBack() ?: false
        val canGoForward = webView?.canGoForward() ?: false
        val backButtonImage: Int = if (!canGoBack) R.drawable.back_page_disable else R.drawable.back_page
        val nextButtonImage: Int = if (!canGoForward) R.drawable.next_page_disable else R.drawable.next_page

        titleTextView.text = title

        backPageImageButton.isClickable = canGoBack
        nextPageImageButton.isClickable = canGoForward
        backPageImageButton.setImageResource(backButtonImage)
        nextPageImageButton.setImageResource(nextButtonImage)
    }
}
