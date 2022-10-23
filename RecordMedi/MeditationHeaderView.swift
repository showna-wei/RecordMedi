//
//  MeditationHeaderView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/12.
//

import SwiftUI

struct MeditationHeaderView: View {
    //one component one variable value
    //control progress time view by input variable
    let secondsElapsed:Int
    let secondsRemaining:Int
    @Binding var rmedi:DailyApp
    
    private var totalSeconds:Int{
        secondsElapsed+secondsRemaining
    }
    
    //progress value from 0 to 1
    private var progress:Double{
        guard totalSeconds>0 else {
            return 1
        }
        return Double(secondsElapsed)/(Double(secondsRemaining+secondsElapsed))
    }
    //for accessibility voice
    private var minutesRemaining:Int{
        secondsRemaining/60
    }
    var body: some View {
        VStack{
            //top up time-line
            ProgressView(value:progress).progressViewStyle(LinearProgressViewStyle(tint:rmedi.theme.mainColor)).scaleEffect(x: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/, y: 4, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //custom self theme style
//                .progressViewStyle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Style@*/DefaultProgressViewStyle()/*@END_MENU_TOKEN@*/)
                .padding(.top, 30.0)
            //second top line: remaining time
            HStack {
                VStack {
                    Text("Seconds Elapsed").font(.title2)
                    Label("\(secondsElapsed)s", systemImage: "hourglass.bottomhalf.fill")
                }
                .padding(.leading, 20.0)
                Spacer()
                VStack {
                    Text("Seconds Remaining").font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                    Label("\(secondsRemaining)s", systemImage: "hourglass.tophalf.fill")
                        .labelStyle(TrailingIconLabelStyle.trailingIcon)
                }
                .padding(.trailing, 20.0)
            }
        }.accessibilityElement(children: /*@START_MENU_TOKEN@*/.ignore/*@END_MENU_TOKEN@*/)
        .accessibilityLabel("Time Remaining")
        .accessibilityLabel("\(minutesRemaining) minutes")
        //Vstack set to top
        .padding([.top,.horizontal])
    }
}

struct MeditationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationHeaderView(secondsElapsed: 60, secondsRemaining: 300,rmedi:.constant(DailyApp.sampleData[0])).previewLayout(.sizeThatFits)
    }
}
