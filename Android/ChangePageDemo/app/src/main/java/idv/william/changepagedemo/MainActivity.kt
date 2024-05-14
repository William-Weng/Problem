package idv.william.changepagedemo

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.widget.Toast
import androidx.annotation.IdRes
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.material.bottomnavigation.BottomNavigationView
import idv.william.Extensions._Activity._findViewById
import idv.william.Extensions._AppCompatActivity._actionBarHidden
import idv.william.Extensions._BottomNavigationView._originalIconColor
import idv.william.Extensions._FragmentManager._addFragment
import idv.william.Utility
import idv.william.changepagedemo.tabFragment.Tab1Fragment
import idv.william.changepagedemo.tabFragment.Tab2Fragment
import idv.william.changepagedemo.tabFragment.Tab3Fragment

class MainActivity : AppCompatActivity() {

    private val helper = Helper()
    private val listener = Listener()

    private val bottomNavigationView by _findViewById<BottomNavigationView>(R.id.bottomNavigationView)

    private val tab1Fragment by lazy { Tab1Fragment() }
    private val tab2Fragment by lazy { Tab2Fragment() }
    private val tab3Fragment by lazy { Tab3Fragment() }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initSetting()
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {

        var isSuccess = true

        Utility._Instance.wwLog(`class` = javaClass, message = keyCode.toString())

        isSuccess = when (keyCode) {
            KeyEvent.KEYCODE_BACK -> { helper.backKeyDownAction(context = this) }
            else -> { true }
        }

        return super.onKeyDown(keyCode, event) && isSuccess
    }

    /**
     * 初始化設定
     */
    private fun initSetting() {

        this._actionBarHidden()

        helper.defaultSetting(activity = this)
        listener.bottomNavigationViewOnItemSelectedListener(bottomNavigationView = bottomNavigationView, selectedAction = ::bottomNavigationViewSelectedAction, reselectedAction = ::bottomNavigationViewReselectedAction)

        bottomNavigationView._originalIconColor()
        supportFragmentManager._addFragment(id = R.id.fragmentContainer, fragment = tab1Fragment)
    }

    /**
     * 使用BottomNavigationView換頁
     * @param id Int
     * @return Boolean
     */
    private fun bottomNavigationViewSelectedAction(@IdRes id: Int): Boolean {

        val fragmentManager = supportFragmentManager
        val fragments = fragmentManager.fragments
        val transaction = fragmentManager.beginTransaction()

        when (id) {

            R.id.action_search -> {

                if (fragments.contains(tab1Fragment)) { transaction.show(tab1Fragment).hide(tab2Fragment).hide(tab3Fragment).commit(); return true }
                fragmentManager._addFragment(id = R.id.fragmentContainer, fragment = tab1Fragment)

                return true
            }

            R.id.action_settings -> {

                if (fragments.contains(tab2Fragment)) { transaction.show(tab2Fragment).hide(tab1Fragment).hide(tab3Fragment).commit(); return true }
                fragmentManager._addFragment(id = R.id.fragmentContainer, fragment = tab2Fragment)

                return true
            }

            R.id.action_navigation -> {

                if (fragments.contains(tab3Fragment)) { transaction.show(tab3Fragment).hide(tab2Fragment).hide(tab1Fragment).commit(); return true }
                fragmentManager._addFragment(id = R.id.fragmentContainer, fragment = tab3Fragment)

                return true
            }

            else -> return false
        }
    }

    /**
     * 使用BottomNavigationView換頁 (再一次被選到)
     * @param id Int
     * @return Boolean
     */
    private fun bottomNavigationViewReselectedAction(@IdRes id: Int): Unit {
        Log.d("Main_Reselected", id.toString())
    }

    /**
     * 小工具
     */
    private class Helper {

        /**
         * 系統預設設定值
         * @param activity AppCompatActivity
         */
        fun defaultSetting(activity: AppCompatActivity) {

            // activity.enableEdgeToEdge()
            activity.setContentView(R.layout.activity_main)

            ViewCompat.setOnApplyWindowInsetsListener(activity.findViewById(R.id.main)) { view, insets ->
                val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
                view.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
                insets
            }
        }

        /**
         * [按下Back鍵的功能處理](https://ithelp.ithome.com.tw/articles/10216949)
         * @param context Context
         * @return Boolean
         */
        fun backKeyDownAction(context: Context): Boolean {
            Toast.makeText(context, "你按到Back鍵了…", Toast.LENGTH_SHORT).show()
            return true
        }
    }

    /**
     * 監聽器事件
     */
    private class Listener {

        /**
         * 設定BottomNavigationView的OnItemSelectedListener功能
         * @param bottomNavigationView BottomNavigationView
         * @param selectedAction (Int) -> Unit
         * @param reselectedAction (Int) -> Unit
         */
        fun bottomNavigationViewOnItemSelectedListener(bottomNavigationView: BottomNavigationView, selectedAction: (Int) -> Boolean, reselectedAction: ((Int) -> Unit)? = null) {

            bottomNavigationView.setOnItemSelectedListener {
                return@setOnItemSelectedListener selectedAction(it.itemId)
            }

            bottomNavigationView.setOnItemReselectedListener {
                reselectedAction?.invoke(it.itemId)
            }
        }
    }
}