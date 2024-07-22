//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint
import WWHUD

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
    
    @IBAction func rotateCamera(_ sender: UIBarButtonItem) {
        videoCamera.rotateCamera()
        position = videoCamera.cameraPosition()
        license.sdk.filiterGroupPosition(position)
    }
}

// MARK: - BeautyfaceSwiftSDKDelegate
extension ViewController: BeautyfaceSwiftSDKDelegate {
    
    func faceCount(sdk: BeautyfaceSwiftSDK, count: Int) {
        wwPrint("出現\(count)張臉")
    }
}

// MARK: - 小工具
private extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        
        BeautyfaceSwiftSDK.authorization { [unowned self] license in
            
            let preview = license.sdk.previewSetting(on: self.previewView)
            
            self.license = license
            self.license.sdk.delegate = self
            self.videoCamera = license.sdk.videoCamera(position: position)
            
            switch license.type {
            case .fail, .error: self.displayHUD(errorMessage: license.type.message())
            case .success:
                
                let result = license.sdk.markManagerSetting()
                
                switch result {
                case .failure(let error): 
                    let filter = license.sdk.baseFilterSetting(preview: preview)
                    self.videoCamera.addTarget(filter)
                    self.displayHUD(errorMessage: error.localizedDescription)
                    
                case .success(let isSuccess): wwPrint(isSuccess)
                    
                    if (!isSuccess) { return }
                    
                    let filter = license.sdk.filterGroupSetting(preview: preview, position: position)
                    
                    self.videoCamera.addTarget(filter)
                    self.videoCamera?.startCapture()
                }
            }
        }
    }
    
    /// 顯示錯誤的提示HUD
    /// - Parameter errorMessage: error
    func displayHUD(errorMessage: String) {
        
        guard let gifUrl = Bundle.main.url(forResource: "Error", withExtension: ".gif") else { return }
        
        WWHUD.shared.flash(effect: .gif(url: gifUrl, options: nil), height: 256)
        wwPrint(errorMessage)
    }
}
