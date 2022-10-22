//
//  MeditationView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/8.
//

import SwiftUI
import AVFoundation

struct AItem:Identifiable{
    var id:UUID=UUID()
    var message:String=""
}

struct MeditationView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Binding var setting:Setting
    
    @State private var rmedi = DailyApp(data:DailyApp.Data())
    @Binding var rmedis:[DailyApp]
    //class 和struct的区别在于class内部可以方便的改子变量
    //当meditationTimer的秒数发生变化的时候，这个view中用到的相关值都会更新，包括子视图（重新创建a）
    //mplayer和timeer的状态都跟着meditationStatus改变
    //过去和剩下秒数可见
    @StateObject private var meditationTimer = MeditationTimer()
    
    @State private var meditationStatus="Start"
    //isMuted可见
    @StateObject private var player=MPlayer()
    
    @State private var isPresentingNewView=false
    @State private var triggerItem:AItem?
    
    @State private var isPresentingFinishedView=false
    @State private var newMeditationData = DailyApp.Data()
    
    //必须放最后一个，不然传入参数的时候闭包不是最后一个参数，不能简写
    let saveAction:()->Void
    
    
    func resetMeditation(){
//        print("triggle reset-1:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
        rmedi.update(from: newMeditationData)
//        print("triggle reset-2:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
        player.resetPlayer(playMode: rmedi.mType, musicFilePath: rmedi.backgroundMusic, remainingSeconds: Int(60*meditationTimer.lengthInMinutes))
//        print("triggle reset-3",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
        meditationTimer.reset(lengthInMinutes: rmedi.lengthInMinutes)
//        print("triggle reset-4:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
    }
    
    func startMeditation(){
        meditationTimer.reset(lengthInMinutes: rmedi.lengthInMinutes)
        player.resetPlayer(playMode: rmedi.mType, musicFilePath: rmedi.backgroundMusic, remainingSeconds: Int(60*rmedi.lengthInMinutes))
        meditationStatus="Play"
        player.startPlay()
        meditationTimer.startMeditation(lengthInMinutes: rmedi.lengthInMinutes)
    }
    func endMeditation(){
        if meditationStatus != "End"{
            print("End process")
            rmedi.lengthInMinutes=Double(meditationTimer.secondsElapsed)/60.0
            meditationStatus="End"
            meditationTimer.endMeditation()
            player.endPlay()
            rmedis.append(rmedi)
        }
    }
    
    var body: some View {
        ZStack {
            //add background outline
            RoundedRectangle(cornerRadius:30.0)
//                .stroke(lineWidth: 3)
                .fill(rmedi.theme.mainColor)//时间计时到了后，自动保存，不提示，恢复到start的状态
                .onReceive(meditationTimer.$isCompleted, perform: { _ in
                    //只执行一次
//                    print("triggle player-b:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
                    if meditationTimer.isCompleted && !player.isAutoCompleted{
                        //时间已到，已记录，可在历史项目中查看
//                        print("triggle player:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
                        player.isAutoCompleted=true
                        self.endMeditation()
                        isPresentingFinishedView=true
//                        player.isAutoCompleted=false
                        meditationTimer.isCompleted=false
//                        print("triggle player-a:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
                    }
                })
                .onAppear(){
                    newMeditationData.update(setting: setting)
                }
            VStack {
                MeditationHeaderView(secondsElapsed: meditationTimer.secondsElapsed, secondsRemaining: meditationTimer.secondsRemaining)
                    
                    
                    .alert(isPresented: $isPresentingFinishedView){
                        Alert(title: Text("Finished"), message:
                                Text("Congrattulation! \r\n You have finished a meditation.\r\n You can check the record on history list."),dismissButton: .default(Text("OK"),action:{
//                                    print("triggle start-b:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
                                    self.resetMeditation()
                                    self.isPresentingFinishedView=false
                                    self.meditationStatus="Start"
                                    print("triggle start-a:",player.isAutoCompleted==true,meditationTimer.isCompleted==true)
                                }))
                    }
                
                HStack {
                    Button(action:{
                        player.toggleMuted()
                    })
                    {
                        ZStack{                            if !player.isMuted{
                                Image(systemName:
                                        "speaker.wave.2.circle.fill").scaleEffect(3)
                            }
                            else{
                                Image(systemName:
                                        "speaker.slash.circle.fill").scaleEffect(3)
                            }
                        }
                    }.accessibilityLabel("stop the background music")
                }
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    ZStack{
                        Circle().strokeBorder(lineWidth: 24)
                        switch meditationStatus{
                        case "Start","End":
                            Text(meditationStatus).font(.largeTitle).fontWeight(.bold).foregroundColor(rmedi.theme.accentColor).scaleEffect(3)
                        case "Stop","Play":
                            VStack{
                                Text(meditationStatus).font(.largeTitle).fontWeight(.bold).foregroundColor(rmedi.theme.accentColor).scaleEffect(3)
                                    .offset(x: 0, y: -30)
                                Text("long tap to end").font(.subheadline).fontWeight(.bold).foregroundColor(rmedi.theme.accentColor).scaleEffect(3)
                                    .offset(x: 0, y: 60)
                            }
                        default:
                            Text("Not").font(.largeTitle).fontWeight(.bold).foregroundColor(rmedi.theme.accentColor).scaleEffect(3)
                            Text(meditationStatus).font(.subheadline).fontWeight(.bold).foregroundColor(rmedi.theme.accentColor).scaleEffect(3)
                                .offset(x: 0, y: 60)
                        }
                    }
                }).contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .highPriorityGesture(LongPressGesture().onEnded{ _ in
                    
                    print("LongPress")
                    switch meditationStatus{
                    case "End":
                        meditationStatus="Start"
                        player.isAutoCompleted=false
                        player.endPlay()
                    case "Start":
                        startMeditation()
                    case "Stop","Play":
                        self.endMeditation()
                        self.isPresentingFinishedView=true
                    default:break
                    }
                }).highPriorityGesture(TapGesture(count: 1).onEnded({_ in
                    print("Tap 1 times")
                    switch meditationStatus{
                    case "Start":
//                        self.isPresentingNewView=true
                        self.triggerItem=AItem()
                    case "Stop":
                        meditationStatus = "Play"
                        player.continuePlay()
                        meditationTimer.continueMeditation()
                    case "Play":
                        meditationStatus="Stop"
                        player.stopPlay()
                        meditationTimer.pauseMeditation()
                    //                    //no operation
                    default: break
                    }
                }))
                .accessibilityLabel("long tap to start or end,short tap to play or stop") .padding(.horizontal, 100)
                VStack{
                    switch meditationStatus{
                    case "Start":
                        Text("Short tap to setting and start")
                            .font(.title3)
                        Text("Long tap to start in default setting")
                            .font(.title3)
                    case "Stop":
                        Text("Short tap to play")
                            .font(.title3)
                        Text("Long tap to end")
                            .font(.title3)
                    case "Play":
                        Text("Short tap to stop")
                            .font(.title3)
                        Text("Long tap to end")
                            .font(.title3)
                    case "End":
                        Text("Long tap to restart")
                            .font(.title3)
                    default:
                        Text("Long tap to start or end")
                        Text("Short tap to stop or play")
                            .font(.title3)
                    }
                }
                .padding(.bottom, 30.0)
            }.padding()
        }.padding()
        .foregroundColor(rmedi.theme.accentColor)
        .onAppear(){
            //出现的时候初始化为setting配置的new
            //            newMeditationData.update(setting: setting)
            rmedi.update(setting: setting)
//            newMeditationData.update(setting: setting)
            //出现就重制计时器
            //            meditationTimer.reset(lengthInMinutes: rmedi.lengthInMinutes)
            //            meditationTimer.startMeditation()
        }
        .onDisappear(){
            //            meditationTimer.endMeditation()
        }
        //        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $isPresentingNewView, content: {
            .sheet(item: $triggerItem, content: { _ in
            NavigationView{
                DetailEditView(data:$newMeditationData,setting: $setting)
//                    .navigationBarHidden(true)
                    .navigationTitle("Create A Meditation")
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction, content: {
                            Button("Dismiss"){
//                                isPresentingNewView=false
                                triggerItem=nil
                            }
                        })
                        ToolbarItem(placement: .confirmationAction    , content: {
                            Button(action: {
                                let newRecord=DailyApp(data:newMeditationData)
                                rmedis.append(newRecord)
                                triggerItem=nil
//                                isPresentingNewView=false
                            }, label: {
                                Text("Add Record Directly")
                                Image(systemName: "bookmark"	)
                            })
                        })
                        ToolbarItem(placement: .principal      , content: {
                            Button(action: {
                                rmedi.update(from: newMeditationData)
                                startMeditation()
                                triggerItem=nil
//                                isPresentingNewView=false
                            }, label: {
                                Text("Start Timing")
                                Image(systemName: "clock.fill"    )
                            })
                        })
                    })
            }.onAppear(){
                newMeditationData.update(setting: setting)
//                dump(newMeditationData)
            }
        })
        //当当前view在后台的时候，异步开个线程，执行save操作
        .onChange(of: scenePhase, perform: { phase in
            if phase == .inactive{saveAction()}
        })
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView(setting:.constant(Setting()),rmedis:.constant(DailyApp.sampleData),saveAction:{})
    }
}
