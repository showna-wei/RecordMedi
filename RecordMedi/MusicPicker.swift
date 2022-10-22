//
//  MusicPicker.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/18.
//


import SwiftUI

struct MusicPicker: View {
    @Binding var selection:Music
    @Binding var setting:Setting
//    @State var isPlay:Bool=false
    @State var isPresentingMusicListView:Bool=false
    var splayer:SimplePlayer=SimplePlayer()
    
    var body: some View {
        VStack(alignment:.leading){
            
//            Toggle("Auto Play:", isOn: $isPlay).padding()
            NavigationLink(
            destination:MusicListView(selection:$selection,setting: $setting)){
                HStack(alignment:.center){
                
                    Text("Backgound Music:")
                        .font(.headline)
                    Spacer(minLength: 10)
                Button(action: {
//                    isPresentingMusicListView=true
                }, label: {
                    Label("\(selection.mname)", systemImage: "music.note").font(.headline).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }).padding()
            }
        }
    }
    }
}

struct MusicPicker_Previews: PreviewProvider {
    static var previews: some View {
        //用constant去创建一个内置不可更改变量的binding引用，主要用在preveiw里面
        MusicPicker(selection: .constant(Setting.DefaultMusic[0]),setting:.constant(Setting()))
    }
}
