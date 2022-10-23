//
//  MusicListView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/19.
//

import SwiftUI

struct MusicListView: View {
    @Environment(\.presentationMode) var mode
    @Binding var selection:Music
    @Binding var setting:Setting
    @State var isPresentedFileImporter:Bool=false
    @State private var isPresentedAlertOfFile:Bool=false
    @State var importFileURL:URL?
    @State var alertmessage:AlertMessage=AlertMessage.failureCopy
    @State var alertmessageStr:String?
    
    enum AlertMessage:Int{
        case failureCopy
        case exitFileName
        case exitInList
    }
    
    @State var splayer:SimplePlayer=SimplePlayer()
    var body: some View {
        Form{
            Section(header:Text("Inline Choices")){
                ForEach(Setting.DefaultMusic){music in
                    HStack{
                        if(selection.mname == music.mname){
                            Image(systemName: "checkmark")
                        }
                        Button(action: {
                            selection=music
                            if setting.autoPlayMusic{
                                if let murl=selection.getMusicURL(){
                                splayer.startPlay(mURL: murl)
                                dump(murl)
                                }
                            }else{
                                splayer.stopPlay()
                            }
                        }){
                            Label("\(music.mname)", systemImage: "music.note")
                                .tag(music.mname)
                        }
                    }
            }
            }
            Section(header:Text("Imported Choices")){
            List(){
                HStack{
                if selection.mname==""{
                        Image(systemName: "checkmark")
                }
                    Text("None").tag(Music(mname:""))
                }
                ForEach(setting.musicList){music in
                    HStack{
                        if(selection.mname == music.mname){
                            Image(systemName: "checkmark")
                        }
                        Button(action: {
                            selection=music
                            if setting.autoPlayMusic{
                                if let murl=selection.getMusicURL(){
                                splayer.startPlay(mURL: murl)
                                }
                            }else{
                                splayer.stopPlay()
                            }
                        }){
                            Label("\(music.mname)", systemImage: "music.note")
                                .tag(music.mname)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    setting.musicList.remove(atOffsets: indexSet)
                })
            }
                
            }
            VStack(){
                HStack(alignment:.center){
                    Spacer()
                    Button(action: {
                        isPresentedFileImporter.toggle()
                        print("prsenenting file importer")
                    }, label: {
                        VStack{
                        Text("Import new music")
                        Image(systemName: "square.and.arrow.down"    )
                        }.padding()
                    }).foregroundColor(Color.red)
                    Spacer()
                }
            }
        }
        .alert(isPresented: $isPresentedAlertOfFile){
            let tempss=alertmessageStr ?? ""
            if importFileURL != nil{
                switch  alertmessage {
                case .exitFileName:
                    let tempmes="The same name of \(importFileURL!.lastPathComponent) music file is already in the App Folder." + tempss
                    return Alert(title: Text(tempmes))
                case .exitInList:
                    let tempmes="\(importFileURL!.lastPathComponent) music file is already in the Music List." + tempss
                    return Alert(title: Text(tempmes))
                default:
                    let tempmes="'\(importFileURL!.lastPathComponent)' music file is error in importing progress." + tempss
                    return Alert(title: Text(tempmes))
                }
            }
            else{
                return Alert(title: Text("No file to import."))
            }
        }
        .fileImporter(isPresented: $isPresentedFileImporter, allowedContentTypes: [.audio], onCompletion: { result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let url):
                //check wheather the same mucis name
                importFileURL=url
                if setting.musicList.contains(where: {$0.mname==url.lastPathComponent}){
                    isPresentedAlertOfFile=true
                    alertmessage=AlertMessage.exitInList
                    return
                }
                
                //copy to current app folder
                do{
                    let copyURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        //new data file
                        .appendingPathComponent(url.lastPathComponent)
                    //check url in to the documentDirecotry，true to add directly
                    let urldPath=url.deletingLastPathComponent()
                    let dPath = copyURL.deletingLastPathComponent()
                    //the same folder,not the same name
                    if dPath.absoluteString==urldPath.absoluteString{
                        setting.musicList.append(Music(mname: url.lastPathComponent))
                        return
                    }
                    //处理/private/var/mobile... 和/var/mobile...的情况
                    if urldPath.relativePath.contains(dPath.relativePath){
                        setting.musicList.append(Music(mname: url.lastPathComponent))
                        return
                    }
                    
//                    alertmessageStr="\r\n\(url.relativePath) \r\n\(copyURL.relativePath)\r\n \(urldPath.relativePath.contains(dPath.relativePath))"
                    //check the file exist
                    if FileManager.default.fileExists(atPath: copyURL.relativePath){
                        isPresentedAlertOfFile=true
                        alertmessage=AlertMessage.exitFileName
                        return
                    }
                    
                    guard url.startAccessingSecurityScopedResource() else{
                        isPresentedAlertOfFile=true
                        alertmessage=AlertMessage.failureCopy
                        print("cant aceess the file:\(url.relativePath)")
                        return
                    }
                    
                    try FileManager.default.copyItem(at: url, to: copyURL)
                    url.stopAccessingSecurityScopedResource()
                    setting.musicList.append(Music(mname: url.lastPathComponent))
                    
                }catch{
                    isPresentedAlertOfFile=true
                    alertmessage=AlertMessage.failureCopy
                    //                    Alert(title: Text("'\(url.lastPathComponent)' music file is error in importing progress."))
                    print("copy error:",url.absoluteString)
                }
            }
        })
        .navigationTitle("Music List")
        .toolbar(content: {
            ToolbarItem(placement: .confirmationAction, content: {
                Toggle("auto play", isOn: $setting.autoPlayMusic)
                Divider()
                EditButton()
            })
        })
        .font(.headline)
        .onDisappear(){
            splayer.stopPlay()
        }
    }
}

struct MusicListView_Previews: PreviewProvider {
    static var previews: some View {
        MusicListView(selection: .constant(Setting.DefaultMusic[0]),setting:.constant(Setting()))
    }
}
