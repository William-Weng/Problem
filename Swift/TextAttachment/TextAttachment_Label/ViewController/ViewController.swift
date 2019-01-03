//
//  ViewController.swift
//  TextAttachment_Label
//
//  Created by William-Weng on 2018/12/28.
//  Copyright © 2018年 William-Weng. All rights reserved.
//
/// [50行代碼實現圖文混排 - NSTextAttachment](https://juejin.im/post/5a90bdb2f265da4e6f17fa21)
/// [用 NSAttributedString 在文字行中加入圖片](https://qiita.com/vc7/items/4fae890b363348eb335d)

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myTextView: UITextView!
    
    let text = "[色] ddsds [害羞] sddsfds [睡]"

    var infos: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infos = readPlistContent("Emoticons.plist")
        
        let emoticon = "[色]"
        let imagename = findEmoticonImageName(with: emoticon)
        let image = UIImage(named: imagename ?? "010")

        myImageView.image = image
    }
    
    @IBAction func detectText(_ sender: UIBarButtonItem) {
        // let regex = "\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"
        testAttributedText()
    }
    
    /// 測試 UILabel / UITextField / UITextView 的 AttributedText
    private func testAttributedText() {
        
        let mutableAttributedString = NSMutableAttributedString(string: "this is a smile :)")
        let textAttachment = NSTextAttachment()
        let image = #imageLiteral(resourceName: "008")
        
        textAttachment.image = image
        textAttachment.bounds = CGRect(x: 0, y: 0, width: 14, height: 14)
        
        let iconAttributedString = NSAttributedString(attachment: textAttachment)
        mutableAttributedString.replaceCharacters(in: NSMakeRange(10, 2), with: iconAttributedString)
        
        myLabel.attributedText = mutableAttributedString
        myTextField.attributedText = mutableAttributedString
        myTextView.attributedText = mutableAttributedString
    }
}

// MARK: 小工具
extension ViewController {
    
    /// 讀取plist檔案內容
    private func readPlistContent(_ plistname: String) -> [String: String]? {
        
        guard let filePath = Bundle.main.path(forResource: plistname, ofType: nil),
              let dictionary = NSDictionary(contentsOfFile: filePath) as? [String: String]
        else {
            return nil
        }
        
        return dictionary
    }
    
    /// 找尋圖文文字的圖片名稱
    private func findEmoticonImageName(with emoticon: String) -> String? {
        return infos?[emoticon]
    }
    
    /// 測試符合的字串 -> [微笑]
    private func textCheckingResult(_ text: String, with regex: String) throws -> [NSTextCheckingResult] {

        let regular = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
        let checkingResults = regular.matches(in: text, options: .reportCompletion, range: NSRange(location: 0, length: text.count))
        
        return checkingResults
    }
}

