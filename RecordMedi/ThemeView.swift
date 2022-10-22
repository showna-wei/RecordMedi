//
//  ThemeView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/11.
//

import SwiftUI

struct ThemeView: View {
    let theme:Theme
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius:4)
            .fill(theme.mainColor)
            //必须用zstack，不如看不到label的内容在图上
            Label(theme.rawValue,systemImage:"paintpalette").font(.headline)
                
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal:false,vertical:true)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme:Theme.buttercup)
    }
}
