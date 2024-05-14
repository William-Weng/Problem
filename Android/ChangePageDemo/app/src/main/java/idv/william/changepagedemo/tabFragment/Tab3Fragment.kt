package idv.william.changepagedemo.tabFragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import idv.william.Extensions._Activity._startActivity
import idv.william.Utility
import idv.william.changepagedemo.R
import idv.william.changepagedemo.SubActivity

class Tab3Fragment : Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_tab3, container, false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Utility._Instance.wwLog(`class` = javaClass, message = "onCreate")
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        Utility._Instance.wwLog(`class` = javaClass, message = "onViewCreated")
    }

    override fun onDestroyView() {
        super.onDestroyView()
        Utility._Instance.wwLog(`class` = javaClass, message = "onDestroyView")
    }

    override fun onDestroy() {
        super.onDestroy()
        Utility._Instance.wwLog(`class` = javaClass, message = "onDestroy")
    }
}