//
//  DailyApp.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/8.
//

import Foundation

enum  MeditationType:String, CaseIterable,Identifiable,Codable{
    case loop="loop"
    case first="once"
    case firstLast="start & end"
    
    var name:String{
        rawValue.capitalized
    }
    
    var id:String{
        name
    }
}

//写入数据库的类型(支持csv，因此都写成一列的)，实际通过data类型来修改
struct DailyApp:Identifiable,Codable{
    var id:UUID=UUID()
    var title:String
    var mType:MeditationType
//    var attendees:[String]
//
//    var attendees:[Attendee]
//    var attendees:[String]
    var attendees:String="Medidator"
    var backgroundMusic:String
    var lengthInMinutes:Double
    var startTime: Date?
    var theme:Theme
    var startTimeString:String
    var df=currentDataFormatter()
    var backgroundMusicLocation:Music.musicLocation=Music.musicLocation.inapp
    
    
    static var csvHeaders=["id","title","mType","attendees","backgroundMusic","backgroundMusicLocation","lengthInMinutes","theme","startTimeString"]
    private enum CodingKeys:Int, CodingKey{
        case id=0
        case title=1
        case mType=2
        case attendees=3
        case backgroundMusic=4
        case backgroundMusicLocation=5
        case lengthInMinutes=6
        case theme=7
        case startTimeString=8
    }

    init (id:UUID=UUID(),title:String, mType: MeditationType, attendees: String, backgroundMusic: String,backgroundMusicLocation:Music.musicLocation=Music.musicLocation.inapp, lengthInMinutes: Double, theme: Theme, startTimeString: String)
    {
        self.id=id
        self.title=title
        self.mType=mType
//        self.attendees=attendees
        //map是把list里面每个数都执行同样函数操作，返回值还是个list
//        self.attendees=attendees.map{Attendee(name: $0)}
        self.attendees=attendees
        self.backgroundMusic=backgroundMusic
        self.backgroundMusicLocation=backgroundMusicLocation
        self.lengthInMinutes=Double(lengthInMinutes)
        self.theme=theme
        self.startTimeString=startTimeString
        self.startTime=df.date(from: startTimeString)
    }
    
    func getStartTimeString()->String{
        guard let st=startTime else {return ""}
        return df.string(from: st)
    }

}

struct currentDataFormatter:Codable{
    static var df:DateFormatter=DateFormatter()
//    init(){
//        df=DateFormatter()
//        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    }
    func filenameString(from:Date) -> String{
        currentDataFormatter.df.dateFormat = "-yyyyMMdd-HHmmss"
        return currentDataFormatter.df.string(from: from)
    }
    func string(from:Date) -> String{
        currentDataFormatter.df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return currentDataFormatter.df.string(from: from)
    }
    func date(from:String)->Date?{
        currentDataFormatter.df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return currentDataFormatter.df.date(from: from)
    }
}
//var df=DateFormatter()
//df.dateFormate="yyyyMMdd-HH,mm,ss"

extension DailyApp{
    struct Attendee:Identifiable,Codable {
        var id: UUID=UUID()
        var name:String
        
        init(id:UUID = UUID(),name:String){
            self.id=id
            self.name=name
        }
        private enum CodingKeys:Int, CodingKey{
            case id=0
            case name=1
        }
    }
    struct Data:Codable{
        var title:String=""
        var mType:MeditationType=MeditationType.firstLast
        var attendees:String
//        var attendees:[Attendee]=[]
        var backgroundMusic:Music
        //由于slider的输入要求必须是Double
        var lengthInMinutes:Double=5
        var theme:Theme=Theme.seafoam
        var startTimeString:String = "2022-1-1 0:0:0"
        var df=currentDataFormatter()
        
        init(){
            title="Meditation"
            //loop,first,firstlast
            mType=MeditationType.firstLast
            attendees=""
            lengthInMinutes=1.0
            backgroundMusic=Music(mname: "xietianhua",mlocation:Music.musicLocation.inapp)
            theme=Theme.orange
            df=currentDataFormatter()
            startTimeString=df.string(from: Date())
        }
        
        init(title: String , mType: MeditationType, attendees: String, backgroundMusic: String,backgroundMusicLocation:Music.musicLocation=Music.musicLocation.inapp, lengthInMinutes: Double, theme: Theme, startTimeString: String){
            self.title=title
            self.mType=mType
            self.attendees=attendees
            self.backgroundMusic=Music(mname: backgroundMusic,mlocation:backgroundMusicLocation)
            self.lengthInMinutes=lengthInMinutes
            self.theme=theme
            self.startTimeString=startTimeString
        }
        
        mutating func update(setting:Setting){
            self.title=setting.title
            self.mType=setting.mType
            self.attendees=setting.attendees
            self.backgroundMusic=setting.backgroundMusic
            self.lengthInMinutes=Double(setting.lengthInMinutes)
            self.theme=setting.theme
            self.startTimeString=df.string(from: Date())
        }
    }
    
    init(id:UUID=UUID(),data:Data){
        self.id=id
        self.title=data.title
        self.mType=data.mType
//        self.attendees=attendees
        //map是把list里面每个数都执行同样函数操作，返回值还是个list
        self.attendees=data.attendees
        self.backgroundMusic=data.backgroundMusic.mname
        self.backgroundMusicLocation=data.backgroundMusic.mlocation
        self.lengthInMinutes=Double(data.lengthInMinutes)
        self.theme=data.theme
        self.startTimeString=data.startTimeString
        self.startTime=df.date(from: data.startTimeString)
    }
    
    
    
    mutating func update(setting:Setting){
        self.title=setting.title
        self.mType=setting.mType
        self.attendees=setting.attendees
        self.backgroundMusic=setting.backgroundMusic.mname
        self.backgroundMusicLocation=setting.backgroundMusic.mlocation
        self.lengthInMinutes=Double(setting.lengthInMinutes)
        self.theme=setting.theme
        self.startTimeString=df.string(from: Date())
    }
    
    
    var data:Data{
        Data(title: title, mType: mType, attendees: attendees, backgroundMusic: backgroundMusic, lengthInMinutes: Double(lengthInMinutes), theme: theme, startTimeString: startTimeString)
    }
    
    //必须声明称mutating，不然不能改变量类型
    mutating func update(from:Data){
        self.title=from.title
        self.mType=from.mType
    //        self.attendees=attendees
            //map是把list里面每个数都执行同样函数操作，返回值还是个list
        self.attendees=from.attendees
        self.backgroundMusic=from.backgroundMusic.mname
        self.backgroundMusicLocation=from.backgroundMusic.mlocation
        self.lengthInMinutes=Double(from.lengthInMinutes)
        self.theme=from.theme
        self.startTimeString=from.startTimeString
        self.startTime=df.date(from: from.startTimeString)
    }
}



extension DailyApp{
    static let sampleData:[DailyApp] =
    [
        DailyApp(title: "Meditation", mType: MeditationType.first, attendees: "Showna", backgroundMusic: "yujian.mp3", lengthInMinutes: 1, theme: Theme.orange, startTimeString: "2020-10-8 10:10:10"),
        DailyApp(title: "Meditation", mType: MeditationType.loop, attendees: "Yang", backgroundMusic: "a.mp3", lengthInMinutes: 15, theme: Theme.bubblegum, startTimeString: "2020-10-8 10:10:20"),
        DailyApp(title: "Meditation", mType: MeditationType.firstLast, attendees: "FangCun", backgroundMusic: "a.mp3", lengthInMinutes: 20, theme: Theme.yellow, startTimeString: "2020-10-8 10:10:30")
    ]
}
