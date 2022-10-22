//
//  MeditationListView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/8.
//

import SwiftUI

struct MeditationListView: View {
    @Binding var rmedis:[DailyApp]
    //new record default data
    @State var newRecord:DailyApp=DailyApp.sampleData[0]
    var body: some View {
        NavigationView{
            Form{
            Section(header: HStack {
                //                Text("Meditation Records")
                //                    .font(.title2)
                //                    .padding(.leading)
                Image(systemName: "hands.sparkles")
                Text("(Total: \(rmedis.map{$0.lengthInMinutes}.reduce(0,+), specifier: "%.1f") minutes)")
            }.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)){
                List{
//
//                    HStack {
//                        //                Text("Meditation Records")
//                        //                    .font(.title2)
//                        //                    .padding(.leading)
//                        Image(systemName: "hands.sparkles")
//                        Text("(Total: \(rmedis.map{$0.lengthInMinutes}.reduce(0,+), specifier: "%.1f") minutes)")
//                    }.padding()
                    //不能写成for a in as的方式，view协议不允许
                    //rmedi的类型定义为identifyer才行
                    //ios15 才支持binding和foreach结合
                    //   ForEach(rmedis){ $rmedi in
                    //之前用foreach，索引，然后代码里面根据索引引用数组变量
                    ForEach(rmedis.indices,id:\.self){ rmedii in
                        // 在列表尾部增加》符号图标来跳转，到CardView
                        NavigationLink(destination:DetailView(rmedi:$rmedis[rmedii])){
                            CardView(rmedi: rmedis[rmedii])
                        }
                        //                .listRowBackground(rmedis[rmedii].theme.mainColor)
                        .padding()
                    }.font(.headline)
                }
                //这整个列表是一个引导页面，在主页面左上角会有》符号，点击，会出现这个view的列表，然后选择每列以后，这个引导view隐藏，主view更改
                //        .navigationTitle("Meditation Records")
                //最上方增加一个+号按钮，点击有行为
                //        .toolbar{
                //            NavigationLink(
                //                destination: MeditationView(rmedis: $rmedis),
                //                label: {
                //                    Image(systemName: "plus")
                //                })
                //            .accessibilityLabel("start new meditation record")
                //
            }}}
            .navigationBarHidden(false)
            .navigationBarTitle("Record list",displayMode:.large)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MeditationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MeditationListView(rmedis:.constant(DailyApp.sampleData))
        }
    }
}
