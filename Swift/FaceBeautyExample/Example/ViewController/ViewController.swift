//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet var sliders: [UISlider]!
    
    private var position: AVCaptureDevice.Position = .back
    private var videoCamera: GPUImageVideoCamera!
    private var license: BeautyfaceSwiftSDK.BeautyfaceLicense!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    @IBAction func changeBeautyValue(_ sender: UISlider) {
        license.sdk.changeBeautifyFilter(intensity: sender.value)
    }
    
    @IBAction func displayFaceDetectPoint(_ sender: UISwitch) {
        license.sdk.displayFaceDetectPoint(sender.isOn)
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        
        BeautyfaceSwiftSDK.authorization { [unowned self] license in
            
            let preview = license.sdk.previewSetting(on: self.previewView)
            
            self.license = license
            self.videoCamera = license.sdk.videoCamera(position: position)
            
            switch license.type {
            case .fail, .error:
                
                let filter = license.sdk.baseFilterSetting(preview: preview)
                self.videoCamera.addTarget(filter)

            case .success:
                
                let result = license.sdk.markManagerSetting()
                
                switch result {
                case .failure(let error): wwPrint(error)
                case .success(let isSuccess): wwPrint(isSuccess)
                                        
                    let filter = license.sdk.filterGroupSetting(preview: preview, position: position)
                    
                    self.videoCamera.addTarget(filter)
                    self.videoCamera?.startCapture()
                }
            }
        }
    }
    
    /// 把Slider放到最前面
    func initSliderSetting() {
        sliders.forEach { view.bringSubviewToFront($0) }
    }
}
