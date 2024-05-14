package idv.william

import java.io.File
import java.io.FileOutputStream

/** Models */
object Models {

    /**
     * [下載Base64會用到的參數值](https://carterchen247.medium.com/kotlin使用心得-六-data-class-1689b1782abb)
     * @param script 變數名稱
     * @param mine 檔案類型
     * @param fieldKey JSON的Key值
     * @param prefix 檔案前綴字
     * @param suffix 副檔名
     */
    data class Base64DownloadModel(val script: String, val mine: String, val fieldKey: String, val prefix: String, val suffix: String)

    /**
     * Base64 => File會用到的參數值
     * @param file 檔案
     * @param stream 檔案輸出串流
     */
    data class FileOutputStreamModel(val file: File, val stream: FileOutputStream)
}
