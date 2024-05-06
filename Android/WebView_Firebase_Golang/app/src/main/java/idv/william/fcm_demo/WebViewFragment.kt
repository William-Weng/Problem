package idv.william.fcm_demo

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import idv.william.Extensions._WebView._debugModel
import idv.william.Extensions._WebView._settings
import idv.william.Utility

class WebViewFragment : Fragment() {

    var mainService: MainActivityService? = null

    private val helper = Helper()
    private val listener = Listener()

    private var url = "https://www.google.com/"
    private var myWebView: WebView? = null
    private var resultLauncher = Utility._Intent.resultLauncher(activity = this.activity, contract = ActivityResultContracts.StartActivityForResult())

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_web_view, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initSetting(view = view)
    }

    /**
     * 回首頁
     */
    fun goHome() { myWebView?.loadUrl(url) }

    /**
     * 回上一頁
     */
    fun goForward() { myWebView?.goForward() }

    /**
     * 回下一頁
     */
    fun goBack() { myWebView?.goBack() }

    /**
     * 重新讀取WebView
     * @param url String
     */
    fun reloadWebView(url: String) {
        this.url = url
        myWebView?.loadUrl(this.url)
    }

    /**
     * 初始化設定
     */
    private fun initSetting(view: View) {

        myWebView = view.findViewById(R.id.myWebView)

        listener.fragment = this

        helper.fragment = this
        helper.resultLauncher = resultLauncher

        myWebView?.let { webView ->
            helper.initWebViewSetting(webView = webView, url = url, action = { listener.webViewClientListener(webView = webView) })
        }
    }

    private class Listener {

        var fragment: WebViewFragment? = null

        /**
         * WebView的WebViewClient
         * @param webView: WebView
         */
        fun webViewClientListener(webView: WebView) {

            webView.webViewClient = object: WebViewClient() {

                override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                    return super.shouldOverrideUrlLoading(view, request)
                }

                override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                    super.onPageStarted(view, url, favicon)
                    fragment?.mainService?.displayDialog()
                }

                override fun onPageCommitVisible(view: WebView?, url: String?) {
                    super.onPageCommitVisible(view, url)
                    fragment?.mainService?.dismissDialog()
                }

                override fun onPageFinished(view: WebView?, url: String?) {
                    super.onPageFinished(view, url)
                    fragment?.mainService?.dismissDialog()
                    fragment?.mainService?.changeTitle(webView = fragment?.myWebView, title = view?.title)
                }
            }
        }
    }

    private class Helper {

        var fragment: WebViewFragment? = null
        var resultLauncher: ActivityResultLauncher<Intent>? = null

        /**
         * [初始化WebView設定](https://xiazdong.github.io/2017/06/15/android-fragment/)
         * @param webView WebView
         * @param url String
         * @param action (() -> Unit)?
         */
        fun initWebViewSetting(webView: WebView, url: String, action: (() -> Unit)? = null) {

            webView._debugModel(isEnable = true)
            webView._settings(javaScriptEnable = true, domStorageEnable = true)
            webView.loadUrl(url)

            action?.let { it() }
        }
    }
}