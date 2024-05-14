package idv.william

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button
import androidx.annotation.IdRes
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import com.google.android.material.bottomnavigation.BottomNavigationView
import idv.william.Extensions._Intent._setClass
import idv.william.Extensions._String._base64String
import org.json.JSONObject
import java.io.File

/** 擴充方法 - class function */
class Extensions {

    /** 擴充String */
    object _String {

        /**
         * [JSON String => JSON Object](https://jc7003.pixnet.net/blog/post/293480218-android-解析json用法)
         * @return [JSONObject](https://hsuhsiaohsuan.gitbooks.io/my-android-tips/content/interact-webview-js.html)
         */
        fun String._jsonObject(): JSONObject {
            return JSONObject(this)
        }

        /**
         * [JSONString => JSONObject[<KEY>] => Base64String](https://blog.csdn.net/jiangjiang1220/article/details/72997236)
         * @param key [String](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types)
         * @param prefix [Base64的前綴字](https://www.jianshu.com/p/e31e38dc4eb5)
         * @return String?
         */
        fun String._base64String(key: String, prefix: String): String? {

            val jsonObject = this._jsonObject()

            return try {
                val base64String = "${jsonObject[key]}"
                base64String.substring(prefix.length)
            } catch (error: java.lang.Exception) {
                null
            }
        }
    }

    /** 擴充Activity */
    object _Activity {

        /**
         * lazy版的findViewById
         * @param id Int
         * @return Lazy<T>
         */
        fun <T : View> Activity._findViewById(@IdRes id: Int): Lazy<T> {
            return lazy { findViewById(id) }
        }

        /**
         * [換頁傳值](https://blog.csdn.net/qq_33748378/article/details/53023036)
         * @param context Context
         * @param class 換到哪一頁
         * @param bundle 要傳的值
         */
        fun <T> Activity._startActivity(context: Context, `class`: Class<T>, bundle: Bundle? = null) {

            val intent = Intent()
            intent._setClass(context = context, `class` = `class`, bundle = bundle)

            startActivity(intent)
        }
    }

    /** 擴充AppCompatActivity */
    object _AppCompatActivity {

        /**
         * [隱藏標籤列](https://blog.csdn.net/weixin_44002043/article/details/122825878)
         * @return Boolean
         */
        fun AppCompatActivity._actionBarHidden(): Boolean {
            supportActionBar?.let { it.hide(); return true }
            return false
        }
    }

    /** 擴充FragmentManager */
    object _FragmentManager {

        /**
         * [切換Fragment](https://medium.com/@hongminlai/fragment最基本的理解-基礎篇-58d8cc7c4e36)
         * @param id [Int](https://www.youtube.com/watch?v=-JwbrsKr9FE)
         * @param fragment [Fragment?](https://blog.csdn.net/NoMasp/article/details/49742475)
         * @param backStackName [String?](https://ithelp.ithome.com.tw/articles/10249249)
         * @return Int
         */
        fun FragmentManager._replaceFragment(@IdRes id: Int, fragment: Fragment?, backStackName: String? = null): Int {

            fragment?.let {

                if (backStackName != null) {
                    beginTransaction().replace(id, fragment).addToBackStack(backStackName).commit()
                } else {
                    beginTransaction().replace(id, fragment).commit()
                }
            }

            return backStackEntryCount
        }

        /**
         * [加入Fragment](https://risk0917.medium.com/android-fragment-add-or-replace-c782183b854b)
         * @param id [Int](https://blog.csdn.net/BigBoySunshine/article/details/105774561)
         * @param fragment Fragment?
         * @param backStackName String?
         * @return Int
         */
        fun FragmentManager._addFragment(@IdRes id: Int, fragment: Fragment?, backStackName: String? = null): Int {

            fragment?.let {

                if (backStackName != null) {
                    beginTransaction().add(id, fragment).addToBackStack(backStackName).commit()
                } else {
                    beginTransaction().add(id, fragment).commit()
                }
            }

            return backStackEntryCount
        }
    }

    /** 擴充Context */
    object _Context {

        /**
         * [取得App Id](https://stackoverflow.com/questions/1264397/how-to-get-android-application-id)
         * @return String
         */
        fun Context._appId(): String {
            return applicationContext.packageName
        }
    }

    /** 擴充PackageManager */
    object _PackageManager {

        /**
         * [取得gradle設定值 (versionName / versionCode)](https://stackoverflow.com/questions/4616095/how-can-you-get-the-build-version-number-of-your-android-application)
         * @param packageName [String](https://juejin.cn/post/7204285137046421564)
         * @param flags Int
         */
        fun PackageManager._info(packageName: String, flags: Int = 0): Result<PackageInfo> {

            return try {
                val info = getPackageInfo(packageName, flags)
                Result.success(info)
            } catch (error: PackageManager.NameNotFoundException) {
                Result.failure(error)
            }
        }
    }

    /** 擴充Intent */
    object _Intent {

        /**
         * Intent換頁傳值
         * @param context Context
         * @param class 換到哪一頁
         * @param bundle 要傳的值
         */
        fun <T> Intent._setClass(context: Context, `class`: Class<T>, bundle: Bundle? = null) {
            bundle?.let { putExtras(it) }
            setClass(context, `class`)
        }
    }

    /** 擴充BottomNavigationView */
    object _BottomNavigationView {

        /**
         * 顯示ICON的原始顏色
         */
        fun BottomNavigationView._originalIconColor() {
            itemIconTintList = null
        }
    }

    /** 擴充WebView */
    object _WebView {

        /**
         * - [設定WebView的Debug模式 => chrome://inspect/](https://developer.chrome.com/docs/devtools/remote-debugging/webviews/)
         * - [非https的解決方案](https://blog.csdn.net/geofferysun/article/details/88575504)
         * @param isEnable [是否開啟？](https://snippetinfo.net/media/1288)
         */
        fun WebView._debugModel(isEnable: Boolean = false) {
            if (Utility._Build.currentVersionMoreThanOrEqual(Build.VERSION_CODES.KITKAT)) { WebView.setWebContentsDebuggingEnabled(isEnable) }
        }

        /**
         * [WebView的相關設定](https://blog.csdn.net/qq_43223954/article/details/89160966)
         * @param javaScriptEnable [是否開啟javaScript](https://blog.csdn.net/nicolelili1/article/details/124555984)
         * @param domStorageEnable 是否開啟DOM儲存功能
         * @param webViewClient [處理WebView通知事件](https://blog.csdn.net/gao_chun/article/details/39180791)
         * @param webChromeClient 處理WebView javascript事件
         */
        fun WebView._settings(javaScriptEnable: Boolean = false, domStorageEnable: Boolean = false, webViewClient: WebViewClient? = null, webChromeClient: WebChromeClient? = null) {

            settings.domStorageEnabled = domStorageEnable
            settings.javaScriptEnabled = javaScriptEnable

            webViewClient?.let { this.webViewClient = it }
            webChromeClient?.let { this.webChromeClient = it }
        }

        /**
         * - [載入網頁](https://blog.csdn.net/lsyz0021/article/details/56677132)
         * - [開啟網路權限 => android.permission.INTERNET](https://janelin612.github.io/2018/09/05/android-webview-debug.html)
         * @param context Context
         * @param url String
         * @param headers Map<String, String>?
         */
        fun WebView._openUrl(context: Context, url: String, headers: Map<String, String>? = null) {
            headers?.let { loadUrl(url, headers); return }
            loadUrl(url)
        }

        /**
         * [開啟Url到外部的預設Browser](https://blog.csdn.net/dlwh_123/article/details/22944047)
         * @param context [在哪裡彈？](https://juejin.cn/post/6844903590545326088)
         * @param url [網址…](https://stackoverflow.com/questions/3487389/convert-string-to-uri)
         * @return Exception?
         */
        @SuppressLint("QueryPermissionsNeeded")
        fun WebView._openUrlWithOutside(context: Context, url: String): Exception? {

            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse(url)

            try {
                context.startActivity(intent)
            } catch (error: Exception) {
                return error
            }

            return null
        }

        /**
         * [開啟GooglePlay](https://stackoverflow.com/questions/11753000/how-to-open-the-google-play-store-directly-from-my-android-application)
         * @param context [在哪裡彈？](https://blog.csdn.net/harvic880925/article/details/51523983)
         * @param id Android-APP的ID
         * @return Exception?
         */
        fun WebView._openMarketWithOutside(context: Context, id: String): Exception? {
            val url = "market://details?id=$id"
            return _openUrlWithOutside(context, url)
        }

        /**
         * [WebView執行Javascript => .setWebChromeClient()](https://stackoverflow.com/questions/16494135/how-to-show-android-alert-dialog-in-webview)
         * @param webView [WebView](https://abgne.tw/android/android-code-snippets/android-os-sdk-version.html)
         * @param script [String](https://juejin.cn/post/6844904162782609416)
         * @param result [取得回傳值的block…](https://www.jianshu.com/p/8dc5afad7e44)
         */
        fun WebView._evaluateJavascript(webView: WebView?, script: String, result: (String) -> Unit) {

            if (Utility._Build.currentVersionMoreThanOrEqual(Build.VERSION_CODES.KITKAT)) {
                webView?.evaluateJavascript(script) { result(it) }; return
            }

            webView?.loadUrl("javascript:$script")
        }

        /**
         * [開啟檔案分享選擇器](https://dev.to/jakebloom/using-share-sheets-on-ios-and-android-4obi)
         * @param context [Context](https://blog.csdn.net/qq_41466437/article/details/102827692)
         * @param title [String](https://blog.csdn.net/qq_32534441/article/details/105861078)
         * @param mime [String](https://developer.mozilla.org/zh-TW/docs/Web/HTTP/Basics_of_HTTP/MIME_types)
         * @param file [File](https://developer.android.com/training/sharing/send)
         */
        fun WebView._shareChooser(context: Context, title: String, file: File, mime: String): Intent {

            val fileUri = _shareFileUri(context, file = file)

            val sendIntent = Intent().apply {
                this.action = Intent.ACTION_SEND
                this.type = mime
                this.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION)
                this.putExtra(Intent.EXTRA_STREAM, fileUri)
            }

            return Intent.createChooser(sendIntent, title)
        }

        /**
         * [分享下載回來的資料](https://www.codeproject.com/articles/778288/saving-data-to-a-file-in-your-android-application)
         * @param model [下載用的一些參數值…](https://developer.mozilla.org/zh-TW/docs/Learn/JavaScript/First_steps)
         * @param directory [存在哪裡？](https://developer.mozilla.org/zh-TW/docs/Learn/JavaScript/First_steps)
         * @param result [(Result<File>?) -> Result<File>?](https://xie.infoq.cn/article/16baba28f0df19d70d00d4604)
         */
        fun WebView._appDownloadWebFile(model: Models.Base64DownloadModel, directory: File? = Utility._File.downloadsFilePath(), result: (Result<File>?) -> Result<File>?) {

            _evaluateJavascript(this, model.script) { json ->

                val base64Prefix = "data:${model.mine};base64,"
                val base64Data = json._base64String(key = model.fieldKey, prefix = base64Prefix)
                val fileResult = Utility._File.storeDownloadFile(directory, data = base64Data, prefix = model.prefix, suffix = model.suffix)

                fileResult?.onFailure { error ->
                    result(Result.failure(error))
                }?.onSuccess { file ->
                    result(Result.success(file))
                }
            }
        }

        /**
         * [產生要分享檔案的Uri](https://blog.csdn.net/qq_41466437/article/details/102827692)
         * @param context [Context](https://blog.csdn.net/chenxue843400447/article/details/86689583)
         * @param file [File](http://gelitenight.github.io/android/2017/01/29/solve-FileUriExposedException-caused-by-file-uri-with-FileProvider.html)
         * @return Uri
         */
        private fun WebView._shareFileUri(context: Context, file: File): Uri {

            var uri = Uri.fromFile(file)

            if (Utility._Build.currentVersionMoreThanOrEqual(Build.VERSION_CODES.N)) {
                uri = FileProvider.getUriForFile(context, context.applicationContext.packageName + ".provider", file)
            }

            return uri
        }
    }
}