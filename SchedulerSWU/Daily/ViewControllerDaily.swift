//
//  ViewControllerDaily.swift
//  SchedulerSWU
//
//  Created by CHAERIN KANG on 2021/07/29.
//

import UIKit
import FMDB

class ViewControllerDaily: UIViewController {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableBack: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    static var record = Array<Array<String>>()
    static var currentDate = String()
    static var databasePath = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDate()
        initDB()
        //cleanDB()
        
        setTableView()
    
        tableBack.layer.cornerRadius = 15
        tableBack.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        bgView.setGradient(color1: #colorLiteral(red: 0.8470588326, green: 0.7098039389, blue: 1, alpha: 1), color2: #colorLiteral(red: 1, green: 0.5490196347236633, blue: 0.5490196347236633, alpha: 1), color3: #colorLiteral(red: 1, green: 1, blue: 0.7803921699523926, alpha: 1))
    }
    
    //db 내용 정리 및 삭제
    func cleanDB(){
            let db = FMDatabase(path: ViewControllerDaily.databasePath)
            if db.open(){
                let query = "delete from record where date like '\(ViewControllerDaily.currentDate)'" 
                if !db.executeStatements(query){
                    NSLog("디비 정리 실패")
                }else{
                    NSLog("디비 정리 성공")
                }
            }
    }
    
    func setDate(){
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy/MM/dd"
        ViewControllerDaily.currentDate = formatter_year.string(from: Date())
        self.labelDate.text = ViewControllerDaily.currentDate
    }
    
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
    func setTableView() {
        ViewControllerDaily.record = Array<Array<String>>()
        let db = FMDatabase(path: ViewControllerDaily.databasePath)
        if db.open(){
            let query = "select * from record where date like '\(ViewControllerDaily.currentDate)'"
            if let result = db.executeQuery(query, withArgumentsIn: []){
                while result.next() {
                    var columnArray = Array<String>()
                    
                    columnArray.append(result.string(forColumn: "date")!)
                    columnArray.append(result.string(forColumn: "emoji")!)
                    columnArray.append(result.string(forColumn: "title")!)
                    
                    ViewControllerDaily.record.append(columnArray)
                }
                self.tableView.reloadData()
            }else{
                NSLog("결과 없음")
            }
        }else{
            NSLog("DB Connection Error")
        }
    }
}

extension ViewControllerDaily :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewControllerDaily.record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        
        let text = ViewControllerDaily.record[indexPath.row]
        cell.labelEmoji.text = "\(text[1])"
        cell.labelTitle.text = "\(text[2])"
        //셀 디자인
        cell.backgroundColor = UIColor.clear
        cell.tintColor = UIColor.clear
        
        //테이블뷰 디자인
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.layer.cornerRadius = 15        
        
        
        return cell
    }
    
    func testReload() {
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewControllerDailyAdd {
            vc.parent1VC = self
        }
    }
}
