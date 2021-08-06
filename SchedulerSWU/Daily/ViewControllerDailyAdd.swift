//
//  ViewControllerDailyAdd.swift
//  SchedulerSWU
//
//  Created by CHAERIN KANG on 2021/07/29.
//

import UIKit
import FMDB
import MobileCoreServices

class ViewControllerDailyAdd: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var emojiField: UITextField!
    var parent1VC:ViewControllerDaily!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var addBg: UIView!
    @IBOutlet weak var picBG: UIView!
    
    // UIImagePickerController 인스턴스 변수 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var flagImageSave = false // 사진 저장 여부를 나타낼 변수
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //배경색
        addBg.setGradient(color1: #colorLiteral(red: 1, green: 0.7960784314, blue: 0.7960784314, alpha: 1), color2: #colorLiteral(red: 1, green: 0.7137254902, blue: 0.7137254902, alpha: 1), color3: #colorLiteral(red: 1, green: 0.6274509804, blue: 0.6274509804, alpha: 1))
        //이미지 배경 뷰
        picBG.layer.cornerRadius = 15
        picBG.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        picBG.layer.borderWidth = 2
        picBG.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        //텍스트필드 모양
        self.titleField.layer.cornerRadius = 15
        self.emojiField.layer.cornerRadius = 15
        titleField.layer.borderWidth = 2
        emojiField.layer.borderWidth = 2
        titleField.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        emojiField.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        titleField.clipsToBounds = true
        emojiField.clipsToBounds = true
//        titleField.layer.shadowRadius = 5
//        titleField.layer.shadowOffset = CGSize(width: 0, height: 4)
//        titleField.layer.shadowOpacity = 0.1
//        titleField.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    //추가 button
    //db save
    @IBAction func doSave(_ sender: Any) {
        //save content
        ViewControllerDaily.record = Array<Array<String>>()
        if let title = titleField.text{
            if let emoji = emojiField.text{
                
                var recordDetail = Array<String>();
                let date = ViewControllerDaily.currentDate
                
                recordDetail.append(date)
                recordDetail.append(emoji)
                recordDetail.append(title)
                
                ViewControllerDaily.record.append(recordDetail)
            }
        }
        //save on db
        let db = FMDatabase(path: ViewControllerDaily.databasePath)
        if db.open(){
            for text in ViewControllerDaily.record{
                let query = "insert into record(date, emoji, title) values ('\(text[0])','\(text[1])','\(text[2])')"
                if !db.executeUpdate(query, withArgumentsIn: []){
                    NSLog("저장 실패")
                }else {
                    NSLog("저장 성공")
                }
            }
        }else{
            NSLog("DB Connection Error")
        }
        //keyboard off
        view.endEditing(true)
       
        //Daily tableView reload
        self.parent1VC.testReload()
        
        //modal dismiss
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func textEndEditing(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldFinishEdit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //사진 불러오기
    @IBAction func btnLoadImage(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                    flagImageSave = false
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary // 이미지 피커의 소스 타입을 PotoLibrary로 설정
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = true // 편집을 허용
                    
                    present(imagePicker, animated: true, completion: nil)
                } else {
                    NSLog("사진 로드 실패")
                }
    }
    
    //초기화
    @IBAction func btnResetImgView(_ sender: Any) {
        imgView.image = nil
    }
    
    // 사진 촬영이나 선택이 끝났을 때 호출되는 델리게이트 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
      
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            let captureImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
            if flagImageSave {

                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            imgView.image = captureImage // 가져온 사진을 이미지 뷰에 출력
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // 사진 촬영이나 선택을 취소했을 때 호출되는 델리게이트 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
