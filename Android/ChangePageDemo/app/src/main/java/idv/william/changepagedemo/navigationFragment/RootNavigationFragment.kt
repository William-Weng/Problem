package idv.william.changepagedemo.navigationFragment

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.navigation.fragment.findNavController
import idv.william.Utility
import idv.william.changepagedemo.R

class RootNavigationFragment : Fragment() {

    private val listener = Listener()
    private val navigationController by lazy { findNavController() }

    private lateinit var navigationButton: Button

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_root_navigation, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initSetting()
        Utility._Instance.wwLog(`class` = javaClass, message = "onViewCreated")
    }

    /**
     * 初始化
     */
    private fun initSetting() {
        navigationButton = requireActivity().findViewById(R.id.navigation_button)
        listener.buttonOnClickListener(button = navigationButton, action = ::nextPage)
    }

    /**
     * 到下一頁
     */
    private fun nextPage() {
        navigationController.navigate(R.id.action_rootNavigationFragment_to_nextNavigationFragment)
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