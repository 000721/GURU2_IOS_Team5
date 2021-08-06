//
//  ViewControllerGallery.swift
//  SchedulerSWU
//
//  Created by CHAERIN KANG on 2021/07/29.
//

import UIKit
import FMDB

class ViewControllerGallery:UIViewController{
    //@IBOutlet weak var EmoCell: UIView!
    
    @IBAction func nextVC(_ sender: UIButton) {
        //storyboard를 통해 두번쨰 화면의 storyboard ID를 참조하여 뷰 컨트롤러를 가져옵니다.
            guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "GalleryShow") else {
                return
            }
           svc.modalPresentationStyle = .fullScreen
            //화면 전환 애니메이션을 설정합니다. coverVertical 외에도 다양한 옵션이 있습니다.
        svc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            //인자값으로 다음 뷰 컨트롤러를 넣고 present 메소드를 호출합니다.
            self.present(svc, animated: true)
    }
    //이모지
    var emojiarray = Array<String>()
    //이모지 배경이미지
    var EbgImages = ["emobg1","emobg2","emobg3","emobg4"]
    //갤러리 배경이미지
    var GryImages = ["gallery1","gallery2","gallery3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDB()
        doLoadData()
        // Do any additional setup after loading the view.
        //배경색 설정
        bgView.setGradient(color1: #colorLiteral(red: 0.8470588326454163, green: 0.7098039388656616, blue: 1, alpha: 1), color2: #colorLiteral(red: 1, green: 0.5490196347236633, blue: 0.5490196347236633, alpha: 1), color3: #colorLiteral(red: 1, green: 1, blue: 0.7803921699523926, alpha: 1))
    }
    //배경색 설정
    @IBOutlet weak var bgView: UIView!

    //db 생성
    func initDB(){
        let fileMgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        
        ViewControllerDaily.databasePath = docDir + "/record.db"
        if !fileMgr.fileExists(atPath: ViewControllerDaily.databasePath){
            //디비 만들기
            let db = FMDatabase(path: ViewControllerDaily.databasePath)
            if db.open(){
                //테이블 만들기
                //SQL: 질의문
                let query = "create table if not exists record (id integer primary key autoincrement, date text, emoji text, title text)"
                if !db.executeStatements(query){
                    NSLog("디비 생성 실패")
                }else{
                    NSLog("디비 생성 성공")
                }
            }
        }else{
                NSLog("디비 생성 성공")
        }
    }

    //do load
    func doLoadData() {
        emojiarray = Array<String>()
        let db = FMDatabase(path: ViewControllerDaily.databasePath)
        if db.open(){
            let query = "select distinct emoji from record"

            if let result = db.executeQuery(query, withArgumentsIn: []){
                while result.next() {
                    emojiarray.append(result.string(forColumn: "emoji")!)
                }
               // self.tableView.reloadData()
            }else{
                NSLog("결과 없음")
            }
        }else{
            NSLog("DB Connection Error")
        }
    }
}


//배경색 설정
extension UIView{
    func setGradient(color1:UIColor,color2:UIColor, color3:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor, color3.cgColor]
        gradient.locations = [0.0 , 0.484375, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: -3.0616171314629196e-17)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.9999999999999999)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    
}

extension ViewControllerGallery: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiarray.count
        //return EbgImages.count * 5
        //return GryImages.count * 8
    
    }
  
    //이모지 콜렉션뷰
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emojicell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
        //이모지 변경
        let text = emojiarray[indexPath.row]
        emojicell.EmoLabel.text = "\(text)"
        //이모지 배경 변경
        emojicell.EbgImage.image = UIImage(named: EbgImages[indexPath.row%4])
        
        collectionView.backgroundColor = UIColor.clear
        emojicell.backgroundColor = UIColor.clear
        return emojicell
       
//
//        //갤러리 콜렉션뷰
//        let grycell = collectionView.dequeueReusableCell(withReuseIdentifier: "gryCell", for: indexPath) as! GalleryCell
//        //갤러리 사진 변경
//        grycell.gryImage.image = UIImage(named: GryImages[indexPath.row%3])
//        return grycell
        
    }
    
    
}

//콜렉션뷰 크기조정
extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat.init(104)
        let height = CGFloat.init(101)
        return CGSize(width: width, height: height)
    }
    
    
}


