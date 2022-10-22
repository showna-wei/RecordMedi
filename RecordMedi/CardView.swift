//
//  CardView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/8.
//

import SwiftUI

struct CardView: View {
    let rmedi:DailyApp
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()                    .fill(rmedi.theme.mainColor)
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.trailing)

                    
                Text(rmedi.title).font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Label("\(rmedi.startTimeString)", systemImage: "calendar")
                    .labelStyle(CenterIconLabelStyle.centerIcon)
                    .padding(.leading)
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                Label("\(rmedi.attendees)", systemImage: "person")
                    .padding(.trailing)
                    .labelStyle(TrailingIconLabelStyle.trailingIcon)
                    .accessibilityLabel("hold \(rmedi.attendees) attendees")
//                Text(rmedi.attendees.joined(separator: ", "))
//                    .padding(.trailing)
                Label("\(rmedi.lengthInMinutes, specifier: "%.1f") m", systemImage: "clock")
                    .accessibilityLabel("last \(rmedi.lengthInMinutes, specifier: "%.1f") minute")
                    .padding(.trailing)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var rmedi = DailyApp.sampleData[0]
    static var previews: some View {
        CardView(rmedi: rmedi)
//            .background(Color.blue)
//            .foregroundColor(rmedi.theme.accentColor)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: 60.0))
        
        
    }
}
