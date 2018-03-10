//
//  ViewController.swift
//  UIImagePickerController_Test
//
//  Created by William-Weng on 2018/3/10.
//  Copyright © 2018年 William-Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private enum MediaType: String {
        case image = "public.image"
        case movie = "public.movie"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func 按下相機(_ sender: UIButton) {
        
        let pickerController = imagePickerController(with: .camera)
        
        pickerController.cameraCaptureMode = .photo
        present(pickerController, animated: true)
    }
}

// MARK: @UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let mediaTypeString = info[UIImagePickerControllerMediaType] as? String,
              let mediaType = MediaType.init(rawValue: mediaTypeString)
        else {
            return
        }
        
        var pickerImage: UIImage? = nil
        
        if mediaType == .image {
            
            pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if let pickerImage = pickerImage {
                UIImageWriteToSavedPhotosAlbum(pickerImage, self, nil, nil)
            }
        }
        
        /* 問題：一定要退掉相機才能到另一個頁面嗎？ */
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "SegueForNext", sender: nil)
        })
    }
}

extension ViewController {
    
    /// UIImagePicker基本相關設定
    fileprivate func imagePickerController(with sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [MediaType.image.rawValue]
        imagePickerController.modalTransitionStyle = .flipHorizontal
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        
        return imagePickerController
    }
}
