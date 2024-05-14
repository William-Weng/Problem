package idv.william.changepagedemo.tabFragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.fragment.app.Fragment
import idv.william.Extensions._Activity._startActivity
import idv.william.Extensions._FragmentManager._replaceFragment
import idv.william.changepagedemo.R
import idv.william.changepagedemo.SubActivity
import idv.william.changepagedemo.intentDemo.SubFragment

class Tab1Fragment : Fragment() {

    private val helper = Helper()
    private val listener = Listener()

    private lateinit var intentButton: Button
    private lateinit var fragmentButton: Button

    private val subFragment by lazy { SubFragment() }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_tab1, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initSetting()
        Log.d("Main_Tab1Fragment", "onViewCreated")
    }

    override fun onDestroyView() {
        super.onDestroyView()
        Log.d("Main_onDestroyView", "onDestroyView")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("Main_onDestroy", "onDestroy")
    }

    /**
     * 初始化設定
     */
    private fun initSetting() {

        intentButton = requireActivity().findViewById(R.id.intentButton)
        fragmentButton = requireActivity().findViewById(R.id.fragmentButton)

        listener.buttonOnClickListener(button = intentButton, action = ::startSubActivityAction)
        listener.buttonOnClickListener(button = fragmentButton, action = ::changeFragmentAction)
    }

    /**
     * 使用Intent換頁
     */
    private fun startSubActivityAction() {

        context?.let {
            val bundle = helper.fakeBundleMaker()
            requireActivity()._startActivity(context = it, `class` = SubActivity::class.java, bundle = bundle)
        }
    }

    /**
     * 使用Fragment換頁
     */
    private fun changeFragmentAction() {
        requireActivity().supportFragmentManager._replaceFragment(id = R.id.tabFragmentContainer, fragment = subFragment, backStackName = "Main")
    }

    /**
     * 小工具
     */
    private class Helper {

        /**
         * 設定假資料 (Bundle)
         */
        fun fakeBundleMaker(): Bundle {

            val intArray = intArrayOf(1, 2, 3)
            val stringArray = arrayOf("java", "kotlin", "3939889")
            val bundle = Bundle()

            bundle.putIntArray("intArray", intArray)
            bundle.putStringArray("stringArray", stringArray)

            return bundle
        }
    }

    /**
     * 監聽器事件
     */
    private class Listener {

        /**
         * 設定Button的OnClickListener功能
         * @param button Button
         * @param action () -> Unit
         */
        fun buttonOnClickListener(button: Button, action: () -> Unit) {
            button.setOnClickListener { action() }
        }
    }
}