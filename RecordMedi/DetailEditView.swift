//
//  DetailEditView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/11.
//

import SwiftUI

struct DetailEditView: View {
    //改了data，其他detailview也跟着改，binding，只用类型，调用函数中初始化
    @Binding var data:DailyApp.Data
    @Binding var setting:Setting
    
    
    var body: some View {
        HStack(alignment: .top){
            Form{
                Section(header: Text("Meditation Info")){
                    HStack{
                        Text("Event Name:")
                            .font(.headline)
                        Spacer(minLength: 10)
                        
                        TextField("Enter the event name", text: $data.title).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(.blue)
                    }.padding(.vertical)
                    HStack{
                        Text("Attendee's Name:")
                            .font(.headline)
                        Spacer(minLength: 10)
                        TextField("Enter the default attendee's name", text: $data.attendees).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }.padding(.vertical)
                    
                    TimeLengthViewer(lengthInMinutes:$data.lengthInMinutes).padding(.vertical)
                    MeditationTypePicker(selection: $data.mType)
                    MusicPicker(selection: $data.backgroundMusic, setting: $setting).padding(.vertical)
                    ThemePicker(selection: $data.theme).padding(.vertical)
                }
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(DailyApp.sampleData[0].data),setting:.constant(Setting()))
    }
}
