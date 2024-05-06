package idv.william

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.util.Base64
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContract
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentActivity
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException

/** 擴充方法  - static function */
class Utility {

    class _Shared {
        companion object {

            /**
             * [取得行數](https://stackoverflow.com/questions/17473148/dynamically-get-the-current-line-number)
             * @return Int
             */
            fun lineNumber(): Int { return ___8drrd3148796d_Xaf() }

            /**
             * [取得行數](https://stackoverflow.com/questions/17473148/dynamically-get-the-current-line-number)
             * @return Int
             */
            private fun ___8drrd3148796d_Xaf(): Int {

                var thisOne = false
                var thisOneCountDown = 1
                val elements = Thread.currentThread().getStackTrace()

                for (element in elements) {
                    val methodName = element.methodName
                    val lineNum = element.lineNumber

                    if (thisOne && thisOneCountDown == 0) {
                        return lineNum
                    } else if (thisOne) {
                        thisOneCountDown = 0
                    }

                    if (methodName == "___8drrd3148796d_Xaf") {
                        thisOne = true
                    }
                }

                return -1
            }
        }
    }

    /** 擴充Build */
    class _Build {
        companion object {

            /**
             * 取得APP的作業系統版本號
             * @return Int
             */
            fun currentVersion(): Int {
                return Build.VERSION.SDK_INT
            }

            /**
             * APP的作業系統版本號 >= 某作業系統版本號
             * @return Boolean
             */
            fun currentVersionMoreThanOrEqual(version: Int): Boolean {
                return currentVersion() >= version
            }

            /**
             * APP的作業系統版本號 < 某作業系統版本號
             * @param version Int
             * @return Boolean
             */
            fun currentVersionLessThan(version: Int): Boolean {
                return currentVersion() < version
            }
        }
    }

    /** 擴充Intent */
    class _Intent {
        companion object {

            /**
             * - [啟動Activity並獲取返回的結果 / 取代startActivityForResult](https://thumbb13555.pixnet.net/blog/post/337551269-registerforactivityr)
             * @param activity [FragmentActivity?](https://juejin.cn/post/7237014602751279161)
             * @param contract ActivityResultContract<T, ActivityResult>
             * @param action (ActivityResult) -> Unit
             * @return ActivityResultLauncher<T>?
             */
            fun <T: Intent> resultLauncher(activity: FragmentActivity?, contract: ActivityResultContract<T, ActivityResult>, action: ((ActivityResult) -> Unit)? = null): ActivityResultLauncher<T>? {

                val launcher = activity?.registerForActivityResult(contract) { result: ActivityResult ->
                    action?.invoke(result)
                }

                return launcher
            }
        }
    }

    /** 擴充File */
    class _File {
        companion object {

            /**
             * [取得手機下載資料夾(Downloads)的路徑](https://stackoverflow.com/questions/20472409/i-write-a-file-to-environment-directory-downloads-why-cant-i-see-it-via-the-do)
             * @return [File?](https://www.jianshu.com/p/ba3869f16389)
             */
            fun downloadsFilePath(): File? {
                return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            }

            /**
             * 取得手機文件資料夾(Documents)的路徑
             * @return File?
             */
            fun documentsFilePath(): File? {
                return Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS)
            }

            /**
             * [儲存Base64字串 => 暫存資料夾](https://stackoverflow.com/questions/30005815/convert-encoded-base64-image-to-file-object-in-android)
             * @param directory 存在哪個資料夾內
             * @param data String?
             * @param prefix 檔名前綴字
             * @param suffix 副檔名
             * @return Result<File>?
             */
            fun storeDownloadFile(directory: File?, data: String?, prefix: String = "temp_", suffix: String): Result<File>? {

                val result = fileOutputStream(directory = directory, prefix = prefix, suffix = suffix)

                result.onFailure { error -> return Result.failure(error) }
                    .onSuccess { model ->
                        val sResult = bufferedOutputStream(model = model, data = data)
                        sResult.onFailure { _error -> return Result.failure(_error) }
                            .onSuccess { file -> return Result.success(file) }
                    }

                return null
            }

            /**
             * [產生檔案串流](https://juejin.cn/post/7129322604636307464)
             *  @param directory 存在哪個資料夾內
             *  @param prefix 檔名前綴字
             *  @param suffix 副檔名
             *  @return Result<FileOutputStreamModel>
             */
            private fun fileOutputStream(directory: File?, prefix: String = "temp_", suffix: String): Result<Models.FileOutputStreamModel> {

                val file = File.createTempFile(prefix, suffix, directory)

                return try {
                    val fileOutputStream = FileOutputStream(file)
                    Result.success(Models.FileOutputStreamModel(file = file, stream = fileOutputStream))
                } catch (error: FileNotFoundException) {
                    Result.failure(error)
                }
            }

            /**
             * [Base64 => File](https://www.droidcon.com/2022/04/06/resilient-use-cases-with-kotlin-result-coroutines-and-annotations/)
             *  @param model 存在哪個資料夾內
             *  @param data 二進制資料
             *  @return Result<File>
             */
            private fun bufferedOutputStream(model: Models.FileOutputStreamModel, data: String?): Result<File> {

                val bytesData = Base64.decode(data, Base64.DEFAULT)
                val bufferedOutputStream = BufferedOutputStream(model.stream)
                var fileError: IOException? = null

                try {
                    bufferedOutputStream.write(bytesData)
                } catch (error: IOException) {
                    fileError = error
                } finally {

                    try {
                        bufferedOutputStream.close()
                    } catch (error: IOException) {
                        fileError = error
                    }
                }

                fileError?.let { _fileError -> return Result.failure(_fileError) }
                return Result.success(model.file)
            }
        }
    }

    /** 擴充Notification */
    class _Notification {

        companion object {

            /**
             * [產生在前景顯示的推播視窗](https://developer.android.com/develop/ui/views/notifications/build-notification?hl=zh-tw)
             * @param class [Class<T>](https://medium.com/evan-android-note/kotlin-線上讀書會-筆記-十一-泛型-generics-3080538b5b22)
             * @param context [Context](https://www.tutorialspoint.com/how-to-create-a-notification-with-notificationcompat-builder-in-android)
             * @param channelId [String](https://blog.csdn.net/weixin_43174412/article/details/82629985)
             * @param channelName [String](https://www.jianshu.com/p/b74c5299eb76)
             * @param title String
             * @param description String
             * @param icon Int
             * @param extras: Bundle?
             */
            fun <T: AppCompatActivity>dialog(`class`: Class<T>, context: Context, channelId: String, channelName: String, title: String, description: String, icon: Int, extras: Bundle? = null) {

                val notificationManager = context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                val notificationBuilder = Notification.Builder(context, channelId)
                val intent = _PendingIntent._build(context, extras, `class`)
                val id = System.currentTimeMillis().toInt()

                _NotificationChannel._build(channelId, channelName, description)?.let { channel ->
                    notificationManager.createNotificationChannel(channel)
                }

                notificationBuilder.setAutoCancel(true)
                    .setAutoCancel(true)
                    .setWhen(System.currentTimeMillis())
                    .setSmallIcon(icon)
                    .setTicker("Ticker")
                    .setContentTitle(title)
                    .setContentText(description)
                    .setContentIntent(intent)

                notificationManager.notify(id, notificationBuilder.build())
            }
        }
    }

    class _PendingIntent {
        companion object {

            /**
             * 建立PendingIntent
             * @param context Context
             * @param build Bundle?
             * @param javaClass Class<T>
             * @return PendingIntent
             */
            fun <T: Context> _build(context: Context, build: Bundle? = null, javaClass: Class<T>): PendingIntent {

                val notificationIntent = Intent(context, javaClass)
                val flags = PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                val requestCode = System.currentTimeMillis().toInt()

                build?.let { notificationIntent.putExtras(it) }
                notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)

                return PendingIntent.getActivity(context, requestCode, notificationIntent, flags)
            }
        }
    }

    /** 擴充NotificationChannel */
    class _NotificationChannel {
        companion object {

            /**
             * [產生NotificationChannel](https://litotom.com/2017/08/23/android-8-0-oreo-notification-channels/)
             * @param id [ChannelId](https://medium.com/@stevdza-san/create-a-basic-notification-in-android-b0d4fd29ad89)
             * @param name Channel名稱
             * @param description 述敘
             * @param importance 重要性
             * @return NotificationChannel?
             */
            @SuppressLint("WrongConstant")
            fun _build(id: String, name: String, description: String, importance: Int = NotificationManager.IMPORTANCE_MAX): NotificationChannel? {

                if (_Build.currentVersionLessThan(Build.VERSION_CODES.O)) { return null }

                val channel = NotificationChannel(id, name, importance)

                channel.description = description
                channel.lightColor = Color.RED
                channel.vibrationPattern = longArrayOf(0, 1000, 500, 1000)
                channel.enableLights(true)
                channel.enableVibration(true)

                return channel
            }
        }
    }
}
