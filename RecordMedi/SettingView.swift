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
    @State private var isPresentedEmptyAlert=false
    @State private var isPresentedEmptyAlertConfirm=false
    
    @State private var alertMessage:String?
    
    
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
                                switch result{
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(let outFileName):
                                    presentExportMessage.toggle()
                                    alertMessage="Export successfully to '\(outFileName)'.\r\n You can check the csv file in app folder on your ipad."
                                }}
                        }){
                            VStack{
                                Label("export to csv", systemImage: "square.and.arrow.up.on.square.fill").font(.headline)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        //                       .overlay(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).stroke(Color.blue))
                        .alert(isPresented: $presentExportMessage, content: {
                            
                            return Alert(title:Text(alertMessage ?? "Export successfully.\r\n You can check the csv file in app folder on your ipad."))
                        })
                        .padding()
                        
                    }
                    VStack{
                        
                        Button( action: {
                            isPresentedFileImporter.toggle()
                            print("prsenenting file importer")
                            alertMessage=nil
                        }){
                            Label("import from csv", systemImage: "tray.and.arrow.down.fill").font(.headline)
                        }.buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $presentImportMessage, content: {
                            Alert(title:Text(alertMessage ?? "Import from csv file successfully. \r\n Total database of the app has updated."))
                        })
                        .padding()
                    }
                    VStack{
                        Button( action: {
                            isPresentedEmptyAlert.toggle()
                            print("empty the database")
                            alertMessage=nil
                        }){
                            Label("empty the database", systemImage: "clear").font(.headline)
                        }.buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $isPresentedEmptyAlert, content: {
                            Alert(title:Text("Alert"),message:Text("Do you really want to clean the whole record list?"),primaryButton: Alert.Button.cancel(Text("Cancel")),secondaryButton:Alert.Button.default(Text("Confirm"),action: {
                                rmedis=[]
                                AppStore.save(rmedis: rmedis, completion:{ result in
                                                switch result{
                                                case .failure(let error):
                                                    fatalError(error.localizedDescription)
                                                case .success(let _):
                                                    isPresentedEmptyAlertConfirm.toggle()
                                                    alertMessage=nil
                                                }})
                            }))
                        })
                        .padding()
                        Spacer()
                            .alert(isPresented: $isPresentedEmptyAlertConfirm, content: {
                                    Alert(title:Text(alertMessage ?? "The record list is empty now."))})
                    }
                    
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
                            presentImportMessage.toggle()
                            alertMessage="Import from '\(url.lastPathComponent)' file successfully. \r\n Total database of the app has updated."
                        }}
                }
            })
            //            .padding([.top,.horizontal])
            .frame(alignment: .topLeading)
            .navigationBarHidden(false)
            .navigationBarTitle("About",displayMode:.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
