package idv.william.changepagedemo.tabFragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import androidx.viewpager2.widget.ViewPager2
import idv.william.Utility
import idv.william.changepagedemo.R
import idv.william.changepagedemo.viewPager.Page1Fragment
import idv.william.changepagedemo.viewPager.Page2Fragment
import idv.william.changepagedemo.viewPager.Page3Fragment

class Tab2Fragment : Fragment() {

    private lateinit var viewPager: ViewPager2

    private val adapter = Adapter()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_tab2, container, false)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Utility._Instance.wwLog(`class` = javaClass, message = "onCreate")
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initSetting()
    }

    /**
     * 初始化設定
     */
    private fun initSetting() {

        val pagerAdapter = adapter.ViewPagerAdapter(this)
        pagerAdapter.fragments = arrayOf(Page1Fragment(), Page2Fragment(), Page3Fragment())

        viewPager = requireActivity().findViewById(R.id.viewPager)
        viewPager.adapter = pagerAdapter
    }

    override fun onDestroyView() {
        super.onDestroyView()
        Utility._Instance.wwLog(`class` = javaClass, message = "onDestroyView")
    }

    override fun onDestroy() {
        super.onDestroy()
        Utility._Instance.wwLog(`class` = javaClass, message = "onDestroy")
    }

    /**
     * 界面轉換器
     */
    private inner class Adapter {

        /**
         * [給ViewPager用的轉換器](https://ithelp.ithome.com.tw/articles/10247948)
         * @param fragmentActivity [Fragment](https://medium.com/wearejaya/data-structures-in-kotlin-array-parti-2984c85411b7)
         */
        inner class ViewPagerAdapter(fragmentActivity: Fragment): FragmentStateAdapter(fragmentActivity) {

            var fragments: Array<Fragment> = arrayOf()

            override fun getItemCount(): Int {
                return fragments.size
            }

            override fun createFragment(position: Int): Fragment {
                return fragments[position]
            }
        }
    }
}