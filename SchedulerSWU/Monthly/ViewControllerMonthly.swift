//
//  ViewControllerMonthly.swift
//  SchedulerSWU
//
//  Created by 이지연 on 2021/08/01.
//

import UIKit
import FMDB
import FSCalendar

class ViewControllerMonthly: UIViewController, FSCalendarDataSource,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var calback: UIView!
    @IBOutlet weak var calHeadBg: UIView!
    //좌우 이동버튼 추가
    @IBOutlet weak var headerLabel: UILabel!
    @IBAction func preBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: true)
    }
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: false)
    }
    
    private var currentPage: Date?
    private lazy var today: Date = { return Date() }()
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true) }

    //좌우 이동버튼 추가 끝
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        setCalendar()
        
    }
    
    //let dateFormatter = DateFormatter()
    var currentDate = String()
    
    func setDate(){
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy/MM/dd"
        currentDate = formatter_year.string(from: Date())
    }
    
    
    var tableArray2 = Array<Array<String>>()
    
    func setTableView() {
        tableArray2 = Array<Array<String>>()
        let db = FMDatabase(path: ViewControllerDaily.databasePath)
        if db.open(){
            let query = "select * from record where date like '\(currentDate)'"
            if let result = db.executeQuery(query, withArgumentsIn: []){
                while result.next() {
                    var columnArray = Array<String>()
                    
                    columnArray.append(result.string(forColumn: "emoji")!)
                    columnArray.append(result.string(forColumn: "title")!)
                    
                    tableArray2.append(columnArray)
                }
                self.tableView2.reloadData()
                print("했는데")
            }else{
                NSLog("결과 없음")
            }
        }else{
            NSLog("DB Connection Error")
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        initDB()
        setDate()
        setTableView()
        view.addSubview(calendarView)

        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // Do any additional setup after loading the view.
        calendarView.appearance.titleDefaultColor = .black
        // 달력의 토,일 날짜 색깔
        calendarView.appearance.titleWeekendColor = .red
        // 달력의 맨 위의 년도, 월의 색깔
        calendarView.appearance.headerTitleColor = .systemPink
        // 달력의 요일 글자 색깔
        calendarView.appearance.weekdayTextColor = .black
        // 년월에 흐릿하게 보이는 애들 없애기
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        
        // 달력의 년월 글자 바꾸기
        calendarView.appearance.headerDateFormat = "YYYY / MM"
        // 달력의 요일 글자 바꾸는 방법 1
        //calendarView.locale = Locale(identifier: "ko_KR")
        // 달력의 요일 글자 바꾸는 방법2
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "SUN"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "MON"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "TUE"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "WED"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "THU"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "FRI"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "SAT"
        
        //선택날짜 색상
        calendarView.appearance.selectionColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        calendarView.appearance.borderSelectionColor = #colorLiteral(red: 1, green: 0.5490196078, blue: 0.5490196078, alpha: 1)
        calendarView.appearance.titleSelectionColor = .black
        //오늘날짜 색상
        calendarView.appearance.todayColor = #colorLiteral(red: 0.8470588235, green: 0.7098039216, blue: 1, alpha: 0.7)
        calendarView.appearance.titleTodayColor = .black
        //calendarView.appearance.borderColors
        //선택날짜 테두리 둥글게
        calendarView.appearance.borderRadius = 0.5
        //캘린더 배경색
        calendarView.backgroundColor = UIColor.clear
        //calendarView.draw(CGRect, for: calendarView)
        
        //배경색
        bg.setGradient(color1: #colorLiteral(red: 0.8470588326, green: 0.7098039389, blue: 1, alpha: 1), color2: #colorLiteral(red: 1, green: 0.5490196347236633, blue: 0.5490196347236633, alpha: 1), color3: #colorLiteral(red: 1, green: 1, blue: 0.7803921699523926, alpha: 1))
        
        //캘린더 배경색,모양
        calback.layer.cornerRadius = 15
        calback.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        calback.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calback.layer.borderWidth = 2
        
        //캘린더 헤더 모양
        calHeadBg.layer.cornerRadius = 15
        calHeadBg.backgroundColor = UIColor.clear
        calHeadBg.layer.borderWidth = 2.5
        calHeadBg.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        calendarView.clipsToBounds = true
        
        //헤더 라벨 초기화
        var dateFormatter2: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.dateFormat = "yyyy / MM"
            return df
        }()
        headerLabel.text = dateFormatter2.string(from: Date())

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray2.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView2.dequeueReusableCell(withIdentifier: "monthlytableCell", for: indexPath) as? MonthlyTableCell else{
            fatalError("셀 없음")
        }
        //테이블뷰 셀 폰트 크기 조정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10.0)
        
                let value = tableArray2[indexPath.row]
                cell.labelEmoji.text = "\(value[0])"
                cell.labelTitle.text = "\(value[1])"
        //셀 디자인
        cell.backgroundColor = UIColor.clear
        
        //테이블뷰 디자인
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.layer.cornerRadius = 15

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTableView()
    }
    
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter_year = DateFormatter()
        formatter_year.dateFormat = "yyyy/MM/dd"
        let collectdate = formatter_year.string(from: date)
        print(dateFormatter.string(from: date) + " 선택")
        tableArray2 = Array<Array<String>>()
        let db = FMDatabase(path: ViewControllerDaily.databasePath)
        if db.open(){
            let query = "select * from record where date like '\(collectdate)'"

            if let result = db.executeQuery(query, withArgumentsIn: []){
                while result.next() {
                    var columnArray = Array<String>()
                    
                    columnArray.append(result.string(forColumn: "emoji")!)
                    columnArray.append(result.string(forColumn: "title")!)
                    
                    tableArray2.append(columnArray)
                }
               self.tableView2.reloadData()
            }else{
                NSLog("결과 없음")
            }
        }else{
            NSLog("DB Connection Error")
        }
    
    }
    
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 해제됨")
    }
    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
////            switch dateFormatter.string(from: date) {
////            case dateFormatter.string(from: Date()):
////                return "오늘"
////            case "2021-07-22":
////                return "출근"
////            case "2021-07-23":
////                return "지각"
////            case "2021-07-24":
////                return "결근"
////            default:
////                return nil
//            }
//
//        }
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
    


    
}
extension ViewControllerMonthly: FSCalendarDelegate {
    func setCalendar() {
        calendarView.delegate = self
        calendarView.headerHeight = 15
        calendarView.calendarHeaderView.isHidden = true
        calendarView.scope = .month
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

        var dateFormatter2: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.dateFormat = "yyyy년 M월"
            return df
        }()
        self.headerLabel.text = dateFormatter2.string(from: calendar.currentPage)
    }
}
