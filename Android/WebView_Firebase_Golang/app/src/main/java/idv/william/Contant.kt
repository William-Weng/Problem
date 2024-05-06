package idv.william

object Contant {

    /**
     * [權限設定](https://kotlinlang.org/docs/enum-classes.html#anonymous-classes)
     */
    enum class Permission(val string: String) {
        Internet("android.permission.INTERNET"),                    // 網路連線權限
        PostNotifications("android.permission.POST_NOTIFICATIONS"), // 推播權限
    }
}