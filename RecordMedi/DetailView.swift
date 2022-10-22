//
//  DetailView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/10.
//

import SwiftUI

struct DetailView: View {
    @Binding var rmedi:DailyApp
    //临时存储可编辑变量，只在编辑时从rmedi赋值
    @State private var data=DailyApp.Data()
    @State private var isShowEditView=false
    
    var body: some View {
        List{
            Section(header: Text("Meditation Info")){
                HStack{
                    Label("Meditation Type", systemImage: "hurricane")
                    Spacer()
                    Text("\(rmedi.mType.rawValue)")
                }
                .accessibilityElement(children: .combine)
                HStack{
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(rmedi.lengthInMinutes)")
                }
                .accessibilityElement(children: .combine)
                HStack{
                    Label("Theme",systemImage:"paintpalette")
                    Spacer()
                    Text(rmedi.theme.rawValue)
                        .padding(4)
                        .foregroundColor(rmedi.theme.accentColor)
                        .background(rmedi.theme.mainColor)
                        .cornerRadius(4)
                    
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Attendees")){
                Label(data.attendees,systemImage:"person")
//                ForEach(data.attendees.indices,id:\.self){ i in
//                    HStack{
//                        Label(data.attendees[i],systemImage:"person")
//                    }
//                }
            }
            
        }.navigationTitle(rmedi.title)
        .toolbar{
            Button("Edit")
            {
                isShowEditView=true
                data = rmedi.data
            }
        }
        .sheet(isPresented:$isShowEditView){
            NavigationView{
//                DetailEditView(data:$data)
//                    .navigationTitle(rmedi.title)
//                    .toolbar{
//                        ToolbarItem(placement:.cancellationAction){
//                            Button("Cancel")
//                            {
//                                isShowEditView = false
//                            }
//                        }
//                        ToolbarItem(placement:.confirmationAction){
//                            Button("Done")
//                            {
//                                isShowEditView = false
//                                rmedi.update(from:data)
//                            }
//                        }
//                    }
            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(rmedi:.constant(DailyApp.sampleData[0]))
        }
    }
}
