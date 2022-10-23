//
//  MeditationListView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/8.
//

import SwiftUI

struct MeditationListView: View {
    @Binding var setting:Setting
    @Binding var rmedis:[DailyApp]
    //new record default data
    
    @State var newRecord:DailyApp=DailyApp.sampleData[0]
    var body: some View {
        NavigationView{
            Form{
            Section(header: HStack {
                Image(systemName: "hands.sparkles")
                Text("(Total: \(rmedis.map{$0.lengthInMinutes}.reduce(0,+), specifier: "%.1f") minutes)")
            }
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundColor(.blue))
            {
                List{
                    //不能写成for a in as的方式，view协议不允许
                    //rmedi的类型定义为identifyer才行
                    //ios15 才支持binding和foreach结合
                    //   ForEach(rmedis){ $rmedi in
                    //之前用foreach，索引，然后代码里面根据索引引用数组变量
                    ForEach(rmedis.indices,id:\.self){ rmedii in
                        // 在列表尾部增加》符号图标来跳转，到CardView
                        
                            CardView(rmedi: rmedis[rmedii])
//                        NavigationLink(destination:DetailEditView(data:$rmedis[rmedii],setting:$setting)){
//                            CardView(rmedi: rmedis[rmedii])
//                        }
                        //                .listRowBackground(rmedis[rmedii].theme.mainColor)
                        .padding()
                    }
                    .onDelete(perform: { indexSet in
                        rmedis.remove(atOffsets: indexSet)
                    })
                    .font(.headline)
                }
            }}
                
                .navigationBarHidden(false)
                .navigationBarTitle("Record list",displayMode:.large)
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MeditationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MeditationListView(setting: .constant(Setting()),rmedis:.constant(DailyApp.sampleData))
        }
    }
}
