//
//  BeautyfaceSwiftSDK.swift
//  Example
//
//  Created by iOS on 2024/7/18.
//
/// [Meihu-Beautyface-SDK](https://github.com/zhanghao5683934/Meihu-Beautyface-sdk)
/// [GPURenderKitDemo](https://github.com/Dongdong1991/GPURenderKitDemo)
/// [測試圖片來源](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSna7ATlHsHsAyrXI1ViNJrjpRApZCqrHW2-g&s)

import WWPrint
import AVFoundation
import GPURenderKit

open class BeautyfaceSwiftSDK: NSObject {
    
    public class Filter {}
    
    public typealias BeautyfaceLicense = (sdk: BeautyfaceSwiftSDK, type: AuthorizationType)
    
    /// SDK授權類型
    public enum AuthorizationType {
        
        case success    // 聯網授權成功
        case fail       // 聯網授權失敗
        case error      // 聯網授權碼錯誤
        
        func message() -> String {
            
            switch self {
            case .success: return "聯網授權成功"
            case .fail: return "聯網授權失敗"
            case .error: return "聯網授權碼錯誤"
            }
        }
    }
    
    /// 自訂錯誤
    public enum BeautyfaceError: Error {
        case unknown
    }
        
    private var authorizationType: AuthorizationType = .fail
    private var markManager: MGFacepp?
    private var previewImageView: GPUImageView?
    private var filterGroup: GLImageFaceChangeFilterGroup?
    private var preview: GPUImageView?
    private var currentPosition: AVCaptureDevice.Position = .unspecified
    private var beautifyFilter: BBGPUImageBeautifyFilter?
    private var vignetteFilter: GPUImageVignetteFilter?
    private var sketchFilter: GPUImageSketchFilter?
    
    private override init() {}
}

// MARK: - 公開函式 (static function)
public extension BeautyfaceSwiftSDK {
    
    /// 測試SDK授權 (存起來)
    /// - Parameters:
    ///   - licenseKey: 授權碼
    ///   - licenseSecret: 授權密鑰
    ///   - result: (BeautyfaceLicense) -> Void
    static func authorization(licenseKey: String = MG_LICENSE_KEY, licenseSecret: String = MG_LICENSE_SECRET, result: @escaping (BeautyfaceLicense) -> Void) {
        
        let sdk = BeautyfaceSwiftSDK()
        let isNeedLicense = MGFaceLicenseHandle.getNeedNetLicense()
        
        defer { result((sdk, sdk.authorizationType)) }
        
        if (!isNeedLicense) { sdk.authorizationType = .error; return }
        
        MGFaceLicenseHandle.licenseKey(licenseKey, licenseSecret: licenseSecret) { isSuccess, data in
            if (!isSuccess) { sdk.authorizationType = .fail; return }
            sdk.authorizationType = .success
        }
    }
}

// MARK: - 公開函式 (function)
public extension BeautyfaceSwiftSDK {
    
    /// 管理器設定
    /// - Parameters:
    ///   - maxFaceCount: 人臉數量
    ///   - minFaceSize: 人臉大小
    ///   - interval: 全局檢測間隔
    ///   - orientation: 旋轉角度
    ///   - detectionMode: 檢測類型
    ///   - detectROI: 檢測區域
    ///   - pixelFormatType: 影片串流格式
    func markManagerSetting(maxFaceCount: Int = 0, minFaceSize: Int32 = 100, interval: Int32 = 40, orientation: Int32 = 90, detectionMode: MGFppDetectionMode = .trackingFast, detectROI: MGDetectROI = MGDetectROIMake(0, 0, 0, 0), pixelFormatType: MGPixelFormatType = .PixelFormatTypeNV21) -> Result<Bool, Error> {
        
        let result = faceModel(name: KMGFACEMODELNAME)
        
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let model):
            
            guard let model = model else { return .success(false) }
            
            markManager = MGFacepp(model: model, maxFaceCount: maxFaceCount, faceppSetting: { configure in
                
                guard let configure = configure else { return }
                
                configure.minFaceSize = minFaceSize
                configure.interval = interval
                configure.orientation = orientation
                configure.detectionMode = detectionMode
                configure.detectROI = detectROI
                configure.pixelFormatType = pixelFormatType
            })
            
            return .success(true)
        }
    }
    
    /// 完整的Filiter (授權通過時)
    /// - Parameters:
    ///   - preview: GPUImageView
    ///   - position: AVCaptureDevice.Position
    /// - Returns: BBGPUImageBeautifyFilter?
    func filterGroupSetting(preview: GPUImageView, position: AVCaptureDevice.Position) -> BBGPUImageBeautifyFilter? {
        
        let filterGroup = GLImageFaceChangeFilterGroup()
        let beautifyFilter = Filter.beautify(intensity: 0.0)
        let vignetteFilter = Filter.vignette(start: 0.3, end: 0.75)
        let sketchFilter = Filter.sketch(edgeStrength: 1.0)
        
        filterGroup.isShowFaceDetectPointBool = false;
        filterGroup.setCaptureDevicePosition(position)
        filterGroup.addTarget(preview)
        
        self.preview = preview
        self.filterGroup = filterGroup
        self.currentPosition = position
        
        beautifyFilter.addTarget(filterGroup)
        vignetteFilter.addTarget(beautifyFilter)
        sketchFilter.addTarget(vignetteFilter)
        
        self.beautifyFilter = beautifyFilter
        self.vignetteFilter = vignetteFilter
        self.sketchFilter = sketchFilter
        
        return beautifyFilter
    }
    
    /// 基本的Filiter (授權未通過時)
    /// - Parameter preview: GPUImageView
    /// - Returns: BBGPUImageBeautifyFilter?
    func baseFilterSetting(preview: GPUImageView) -> BBGPUImageBeautifyFilter? {
        
        let beautifyFilter = Filter.beautify(intensity: 0.0)
        
        self.preview = preview
        self.beautifyFilter = beautifyFilter
        beautifyFilter.addFilter(beautifyFilter)

        return beautifyFilter
    }
    
    /// 產生拍攝影片的鏡頭
    /// - Parameters:
    ///   - preset: 鏡頭的解析度
    ///   - outputImageOrientation: 鏡頭的方向
    ///   - position: 哪個位置的鏡頭
    /// - Returns: GPUImageVideoCamera
    func videoCamera(preset: AVCaptureSession.Preset = .hd1280x720, outputImageOrientation: UIInterfaceOrientation = .portrait, position: AVCaptureDevice.Position) -> GPUImageVideoCamera? {
        
        guard let camera = GPUImageVideoCamera(sessionPreset: preset.rawValue, cameraPosition: position) else { return nil }
        
        camera.runBenchmark = false
        camera.horizontallyMirrorFrontFacingCamera = true
        camera.outputImageOrientation = outputImageOrientation
        camera.delegate = self
        
        return camera
    }
    
    /// 產生預覽層
    /// - Parameters:
    ///   - view: 預覽層的view
    func previewSetting(on view: UIView) -> GPUImageView {
        
        let preview = previewImageView(frame: view.frame)
        view.addSubview(preview)
        
        return preview
    }
    
    /// 顯示人臉特徵點
    /// - Parameter isDisplay: Bool
    func displayFaceDetectPoint(_ isDisplay: Bool = false) {
        filterGroup?.isShowFaceDetectPointBool = isDisplay
    }
    
    /// 更改磨皮的強度
    /// - Parameter intensity: Float
    func changeBeautifyFilter(intensity: Float) {
        self.beautifyFilter?.intensity = CGFloat(intensity)
    }
}

// MARK: - GPUImageVideoCameraDelegate
extension BeautyfaceSwiftSDK: GPUImageVideoCameraDelegate {}
public extension BeautyfaceSwiftSDK {
    
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        
        guard let markManager = markManager else { return }
        
        switch authorizationType {
        case .error, .fail: break
        case .success:
            
            switch markManager.status {
            case .markPrepareWork, .markStopped, .markWaiting:
                let faceCount = detectSampleBuffer(sampleBuffer, markManager: markManager)
                wwPrint("faceCount = \(faceCount)")
            case .markWorking: break
            @unknown default: break
            }
        }
    }
}

// MARK: - 小工具
private extension BeautyfaceSwiftSDK {
    
    /// 取得Model資料
    /// - Returns: Result<Data?, Error>
    func faceModel(name: String) -> Result<Data?, Error> {
        
        guard let url = Bundle.main.resourceURL?.appendingPathComponent(name) else { return .failure(BeautyfaceError.unknown) }
        
        do {
            let data = try Data(contentsOf: url)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    /// 檢測相機取得的影像Buffer
    /// - Parameters:
    ///   - sampleBuffer: CMSampleBuffer
    ///   - markManager: MGFacepp
    func detectSampleBuffer(_ sampleBuffer: CMSampleBuffer, markManager: MGFacepp) -> Int {
        
        guard let filterGroup = filterGroup else { return 0 }
        
        let imageData = MGImageData(sampleBuffer: sampleBuffer)
        
        markManager.beginDetectionFrame()
        
        let faceInfos = markManager.detect(with: imageData)
        let faceCount = faceInfos?.count ?? 0
        
        if (faceCount == 0) {
            filterGroup.isHaveFace = false
            filterGroup.setFacePointsArray([])
        } else {
            filterGroup.isHaveFace = true
        }
                
        faceInfos?.forEach({ faceInfo in
            markManager.getGetLandmark(faceInfo, isSmooth: true, pointsNumber: 106)
            filterGroup.setFacePointsArray(faceInfo.points)
        })
        
        markManager.endDetectionFrame()
        
        return faceCount
    }
    
    /// 產生預覽層
    /// - Parameter frame: CGRect
    /// - Returns: GPUImageView
    func previewImageView(frame: CGRect) -> GPUImageView {
        
        let imageView = GPUImageView(frame: frame)
        
        imageView.layer.contentsScale = 2.0
        imageView.backgroundColor = .black.withAlphaComponent(0.8)
        imageView.setBackgroundColorRed(0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        return imageView
    }
}

// MARK: - 濾鏡
private extension BeautyfaceSwiftSDK.Filter {
    
    /// 磨皮 (去斑點)
    /// - Parameter intensity: 強度 (0% ~ 100%)
    /// - Returns: BBGPUImageBeautifyFilter
    static func beautify(intensity: CGFloat) -> BBGPUImageBeautifyFilter {
        
        let filiter = BBGPUImageBeautifyFilter()
        filiter.intensity = intensity
        
        return filiter
    }
    
    /// sketch
    /// - Returns: GPUImageSketchFilter
    static func sketch(edgeStrength: CGFloat) -> GPUImageSketchFilter {
        
        let filter = GPUImageSketchFilter()
        filter.edgeStrength = edgeStrength
        
        return filter
    }
    
    /// vignette
    /// - Parameters:
    ///   - start: CGFloat
    ///   - end: CGFloat
    /// - Returns: GPUImageVignetteFilter
    static func vignette(start: CGFloat, end: CGFloat) -> GPUImageVignetteFilter {
        
        let filiter = GPUImageVignetteFilter()
        filiter.vignetteStart = start
        filiter.vignetteEnd = end
        
        return filiter
    }
}
