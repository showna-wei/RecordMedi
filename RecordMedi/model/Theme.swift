//
//  Theme.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/8.
//

import SwiftUI

//满足Identifiable，必须扩展id变量
enum Theme: String,CaseIterable,Identifiable,Codable {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var accentColor: Color {
        switch self{
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return Color.black
        case .indigo, .magenta, .navy, .oxblood, .purple: return Color.white
        }
    }
    var mainColor: Color{
        Color(self.rawValue)
       
    }
    var name:String{
        rawValue.capitalized
    }
    var id:String{
        name
    }
}
