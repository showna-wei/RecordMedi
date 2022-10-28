//
//  Music.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/18.
//

import Foundation
import SwiftUI

struct Music:Codable,Identifiable,Hashable{
    var id:UUID=UUID()
    var mname:String
    var mlocation:musicLocation=musicLocation.user
    
    init(id:UUID=UUID(),mname:String="",mlocation:musicLocation=musicLocation.user){
        self.id=id
        self.mname=mname
        self.mlocation=mlocation
    }
    enum musicLocation:String,Codable{
        case inapp = "default set in the app"
        case user = "set in document folder of the app"
    }
    //hashable 的协议必须的
    func hash(into hasher:inout Hasher){
        hasher.combine(id)
    }
    
    func getMusicURL(name:String, location:musicLocation=musicLocation.user)->URL?{
        switch location {
        case .inapp:
//            var musicFilePath=Bundle.main.path(forResource: name, ofType: "mp3")
            //name contain ofType,mp3
                let musicFilePath=Bundle.main.path(forResource: name, ofType: nil)
            return musicFilePath != nil ? URL(fileURLWithPath: musicFilePath!):nil
        default:
            do{
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                //new data file
                .appendingPathComponent(name)
            }catch{
                return nil
            }
        }
    }
    func getMusicURL()->URL?{
        getMusicURL(name: self.mname, location: self.mlocation)
    }
}
