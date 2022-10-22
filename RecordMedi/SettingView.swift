//
//  SettingView.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/18.
//
import UniformTypeIdentifiers
import SwiftUI

extension UTType{
    public static let csv=UTType(importedAs:"com.showna.csv")
}

struct SettingView: View {
    //setting.data文件读出的setting，在保存的时候写入
    @Binding var defaultSetting:Setting
    //传递的使用setting，只有在保存的时候更改
    @Binding var setting:Setting
    //编辑的时候变化的setting
    @State var tempSetting:Setting?
    
    @Binding var rmedis:[DailyApp]
    @State private var presentImportMessage=false
    @State private var presentExportMessage=false
    
    @State private var isShowingMusicPicker=false
    @State private var musicPath="yujian.mp3"
    @State private var musicPathFull="yujian.mp3"
    
    @State private var isPresentedFileImporter=false
    
    
    var body: some View {
        NavigationView{
        Form{
                Section(header:Text("Default Event Setting")){
                    HStack{
                        Text("Event Name:")
                            .font(.headline)
                        Spacer(minLength: 10)
                        
                        TextField("Enter the event name", text: $setting.title).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }.padding(.vertical)
                    HStack{
                        Text("Attendee's Name:")
                            .font(.headline)
                        Spacer(minLength: 10)
                        TextField("Enter the default attendee's name", text: $setting.attendees).textFieldStyle(RoundedBorderTextFieldStyle()).font(.headline).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }.padding(.vertical)
                    
                    TimeLengthViewer(lengthInMinutes:$setting.lengthInMinutes).padding(.vertical)
                    
                        MeditationTypePicker(selection: $setting.mType)
                            .padding(.vertical)
                        MusicPicker(selection: $setting.backgroundMusic, setting: $setting).padding(.vertical)
                        ThemePicker(selection: $setting.theme).padding(.vertical)
                    
                }
            Section(header:Text("Database Related")){
                    VStack{
                       Button( action: {
       
                                   AppStore.saveCsv(rmedis: rmedis){ result in
                                       if case .failure(let error) = result{
                                           fatalError(error.localizedDescription)
                                       }
                                       else{
                                        presentImportMessage.toggle()
                                       }
                                   }}){
                           VStack{
                                 Label("export to csv", systemImage: "square.and.arrow.up.on.square.fill").font(.headline)
//                               HStack{
//                                   Spacer()
//                                   Text("export to csv").font(.title).bold()
//                                   Spacer()
//                               }
//                               Image(systemName: "square.and.arrow.down").scaleEffect(x: 2, y: 2, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
                           }
                       }.buttonStyle(BorderlessButtonStyle())
//                       .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.blue))
                       .alert(isPresented: $presentImportMessage, content: {
                           Alert(title:Text("Export successfully.\r\n You can check the csv file in app folder on your ipad."))
                       })
                       .padding()
                       
                    }
                    VStack{
                        
                       Button( action: {
                        isPresentedFileImporter.toggle()
                        print("prsenenting file importer")
                       }){
                        Label("import from csv", systemImage: "tray.and.arrow.down.fill").font(.headline)
//                           VStack{
//                               HStack{
//                                   Spacer()
//                                   Text("import from csv").font(.title).bold()
//                                   Spacer()
//                               }
//                               Image(systemName: "square.and.arrow.down").scaleEffect(x: 2, y:2, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
//                           }
                       }.buttonStyle(BorderlessButtonStyle())
//                       .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.blue))
                       .alert(isPresented: $presentExportMessage, content: {
                           Alert(title:Text("Import from csv file successfully. \r\n Total database of the app has updated."))
                       })
                       
                       .padding()
                    }
                       Spacer()
               }
            
        }
        .fileImporter(isPresented: $isPresentedFileImporter, allowedContentTypes: [UTType.csv], onCompletion: { result in
         switch result{
         case .failure(let error):
             print(error)
         case .success(let url):
             //check wheather the same mucis name=
                              AppStore.loadCsv(fileURL: url){result in
                                  switch result{
                                  case .failure(let error):
                                      fatalError(error.localizedDescription)
                                  case .success(let rmedisData):
                                      rmedis=rmedisData
                                    presentExportMessage.toggle()
                                  }}
         }
     })
//            .padding([.top,.horizontal])
        .frame(alignment: .topLeading)
        .navigationBarHidden(false)
        .navigationBarTitle("About",displayMode:.large)
        }.navigationViewStyle(StackNavigationViewStyle())
        .onDisappear(){
            AppStore.saveSetting(setting: setting){ result in
                    if case .failure(let error) = result{
                        fatalError(error.localizedDescription)
                    }
                }
        }
        
        
//
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(defaultSetting:.constant(Setting()),setting:.constant(Setting()),rmedis:.constant(DailyApp.sampleData))
    }
}
