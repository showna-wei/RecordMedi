//
//  TimeLengthViewer.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/21.
//

import SwiftUI

struct TimeLengthViewer: View {
    @Binding var lengthInMinutes:Double
    
    var body: some View {
        HStack{
            Text("Length:")
                .font(.headline)
            
            Spacer(minLength: 10)
            Slider(value: $lengthInMinutes, in: 0.5...60,step:0.5){
                Text("Time Length")
                    .font(.headline)
            }
            .accessibilityValue("\(Int(lengthInMinutes)) minutes")
            Spacer()
            Spacer(minLength: 5)
//                    var strTime=String(data.lengthInMinutes)
//                    TextField("minutes:", text: strTime)
            Text("\(Int(lengthInMinutes)) Mins \(getSeconds(intMins:lengthInMinutes)) Secs").font(.headline).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
    }
    func getSeconds(intMins:Double)->Int{
        let secs=(intMins-Double(Int(intMins)))*60
        return Int(secs)
    }
}

struct TimeLengthViewer_Previews: PreviewProvider {
    static var previews: some View {
        TimeLengthViewer(lengthInMinutes:.constant(Setting().lengthInMinutes))
    }
}
