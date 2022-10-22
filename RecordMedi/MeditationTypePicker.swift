//
//  MeditationTypePicker.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/17.
//

import SwiftUI

struct MeditationTypePicker: View {
    @Binding var selection:MeditationType
    var mtyptImages=[MeditationType.loop:"arrow.triangle.capsulepath",MeditationType.first:"record.circle",MeditationType.firstLast:"recordingtape"]
    var body: some View {
        HStack{
        Text("Meditation Music Type:")
            .font(.headline)
        Picker("Meditation Music Type", selection: $selection, content:{
            ForEach(MeditationType.allCases){mtype in
                Label(mtype.rawValue, systemImage: mtyptImages[mtype]!)
                    //  把选择和具体变量联系
                    .tag(mtype)
            }
        } )
//        .pickerStyle(WheelPickerStyle())
        .pickerStyle(SegmentedPickerStyle())
//        .padding()
        }
    }
}

struct MeditationTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        MeditationTypePicker(selection: .constant(MeditationType.loop))
    }
}
