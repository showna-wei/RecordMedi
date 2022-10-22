//
//  ThemePicker.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/11.
//

import SwiftUI

struct ThemePicker: View {
    @Binding var selection:Theme
    var body: some View {
        HStack{
            Text("Theme:")
                .font(.headline)
            Spacer(minLength: 10)
        Picker("", selection: $selection, content:{
            ForEach(Theme.allCases){theme in
                ThemeView(theme: theme)
                    //  把选择和具体变量联系
                    .tag(theme)
            }
        } )
//        .navigationTitle("Select A Theme")
        }
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        //用constant去创建一个内置不可更改变量的binding引用，主要用在preveiw里面
        ThemePicker(selection: .constant(.periwinkle))
    }
}
