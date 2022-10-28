//
//  DefaultSetting.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/18.
//

import Foundation

struct Setting:Codable{
    
    var musicList:[Music]
    var autoPlayMusic:Bool=false
    
    var title:String
    var mType:MeditationType
    var attendees:String
    var backgroundMusic:Music
    var lengthInMinutes:Double
    var theme:Theme
    
    init(){
        title="Meditation"
        mType=MeditationType.firstLast
        attendees="Silent Mediddator"
        backgroundMusic=Music(mname: "xietianhua.mp3", mlocation: Music.musicLocation.inapp)
        lengthInMinutes=15
        theme=Theme.navy
//        musicList=Setting.DefaultMusic
        musicList=[]
    }
    
    static var DefaultMusic=[Music(mname: "None", mlocation: Music.musicLocation.inapp),Music(mname: "yujian.mp3", mlocation: Music.musicLocation.inapp),Music(mname: "xietianhua.mp3", mlocation: Music.musicLocation.inapp)]
}
