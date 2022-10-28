//
//  RecordMediApp.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/7.
//

import SwiftUI

@main
struct RecordMediApp: App {	
    //整个程序独一份实体
    //    @State private var rmedis=Daily÷App.sampleData
    @StateObject private var store = AppStore()
    @State private var defaultSetting=Setting()
    //    @State private var setting = Setting()
    
    var body: some Scene {
        WindowGroup {
            TabView{
                //                MeditationView(rmedis: $rmedis)
                MeditationView(setting:$store.setting,rmedis:$store.rmedis){
                    AppStore.save(rmedis: store.rmedis){ result in
                        if case .failure(let error) = result{
                            fatalError(error.localizedDescription)
                        }
                    }
//                    AppStore.saveSetting(setting: store.setting){ result in
//                        if case .failure(let error) = result{
//                            fatalError(error.localizedDescription)
//                        }
//                    }
                }
//                    .font()
//                .font(.system(size: 30,weight:.bold,design:.rounded))
//                .font(.system(size: 30,weight:.bold,design:.rounded))
                .tabItem {
                    Image(systemName: "eyebrow")
                    Text("Meditation")
                }
                //                MeditationListView(rmedis: $rmedis)
                MeditationListView(setting:$store.setting,rmedis: $store.rmedis)
                    .font(.system(size: 30,weight:.bold,design:.rounded))
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("History")
                    }
                
                SettingView(defaultSetting:$defaultSetting,setting:$store.setting,rmedis: $store.rmedis)
                    .font(.system(size: 30,weight:.bold,design:.rounded))
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Setting")
                    }
            }
            .onAppear(){
                    AppStore.loadSetting(){result in
                        switch result{
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let settingData):
                            store.setting=settingData
                            defaultSetting=settingData
                        }
                    }
                    AppStore.load(){result in
                        switch result{
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let rmedisData):
                            store.rmedis=rmedisData
                        }
                    
                }
            }
            //            NavigationView{
            
            
            //                MeditationView(rmedi: $rmedis[0])
            //                MeditationListView(rmedis:$rmedis)
            //            }
        }
    }
}
