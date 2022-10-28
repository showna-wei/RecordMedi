//
//  AppStore.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/17.
//

import Foundation
import SwiftUI
import CodableCSV

class AppStore:ObservableObject{
    @Published var rmedis:[DailyApp]=[]
    @Published var setting:Setting=Setting()
    
    private static func fileURL() throws->URL{
        //get url of this app documentary
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //new data file
            .appendingPathComponent("meditationRecords.data")
    }
    private static func fileURLSetting() throws->URL{
        //get url of this app documentary
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //new data file
            .appendingPathComponent("meditationRecordsSetting.data")
    }
    private static func fileCsvURLCreate() throws->URL{
        //get url of this app documentary
        let timeString=currentDataFormatter().filenameString(from: Date())
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //new data file
            .appendingPathComponent("meditationRecords\(timeString).csv")
    }
//    private static func fileCsvURL() throws->URL{
//        //get url of this app documentary
//        let timeString=currentDataFormatter().filenameString(from: Date())
//        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            //new data file
//            .appendingPathComponent("meditationRecords.csv")
//    }
    
    static func load(completion:@escaping(Result<[DailyApp],Error>)->Void){
                        //a async thread run in background
                        DispatchQueue.global(qos:.background).async{
                            do{
                                let fileURL = try AppStore.fileURL()
                                //get the data from URL file
                                guard let file = try? FileHandle(forReadingFrom: fileURL)else{
                                    //not exist the datafile, to return the void array
                                    DispatchQueue.main.async {
                                        completion(.success([]))
                                    }
                                    return
                                }
                                //read json formate of just [DailyApp] data
                                let dailydatas=try JSONDecoder().decode([DailyApp].self, from: file.availableData)
                                //pass the decoded data to the completion handle
                                DispatchQueue.main.async {
                                    completion(.success(dailydatas))
                                }
                            }catch{
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                        }
    static func loadSetting(completion:@escaping(Result<Setting,Error>)->Void){
                        //a async thread run in background
                        DispatchQueue.global(qos:.background).async{
                            do{
                                let fileURL = try AppStore.fileURLSetting()
                                //get the data from URL file
                                guard let file = try? FileHandle(forReadingFrom: fileURL)else{
                                    //not exist the datafile, to return the void array
                                    DispatchQueue.main.async {
                                        completion(.success(Setting()))
                                    }
                                    return
                                }
                                //read json formate of just [DailyApp] data
                                let settingdatas=try JSONDecoder().decode(Setting.self, from: file.availableData)
                                //pass the decoded data to the completion handle
                                DispatchQueue.main.async {
                                    completion(.success(settingdatas))
                                }
                            }catch{
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                        }
    
    static func save(rmedis:[DailyApp],completion:@escaping(Result<String,Error>)->Void){
        // 返回导出的文件名
        do{
            let data=try JSONEncoder().encode(rmedis)
            let outfile=try AppStore.fileURL()
            try data.write(to: outfile)
            DispatchQueue.main.async {
                completion(.success(outfile.lastPathComponent))
            }
        }catch{
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    static func saveSetting(setting:Setting,completion:@escaping(Result<String,Error>)->Void){
        do{
            let data=try JSONEncoder().encode(setting)
            let outfile=try AppStore.fileURLSetting()
            try data.write(to: outfile)
            DispatchQueue.main.async {
                completion(.success(outfile.lastPathComponent))
            }
        }catch{
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    static func saveCsv(rmedis:[DailyApp],completion:@escaping(Result<String,Error>)->Void){
        do{
//            let data = try CSVWriter.encode(rows: rmedis)
//            let string=try CSVWriter.encode(rows: rmedis, into: String.self)
            let encoder=CSVEncoder(){
                $0.headers=DailyApp.csvHeaders
            }
            let outfile=try AppStore.fileCsvURLCreate()
            try encoder.encode(rmedis, into: outfile)
//            try CSVWriter.encode(rows: rmedis, into: AppStore.fileCsvURL(),append:false)
            DispatchQueue.main.async {
                completion(.success(outfile.lastPathComponent))
            }
            
        }catch{
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            
        }
    }
    static func loadCsv(fileURL:URL,completion:@escaping(Result<[DailyApp],Error>)->Void){
        //a async thread run in background
        DispatchQueue.global(qos:.background).async{
            do{
//                let fileURL = try AppStore.fileCsvURL()
                //get the data from URL file
                //read json formate of just [DailyApp] data
//                let dailydatas=try JSONDecoder().decode([DailyApp].self, from: file.availableData)
                let decoder = CSVDecoder(){
                    $0.headerStrategy=Strategy.Header.firstLine
                }
                
                let dailydatas = try decoder.decode([DailyApp].self, from: fileURL)
                //pass the decoded data to the completion handle
                DispatchQueue.main.async {
                    completion(.success(dailydatas))
                }
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        }
}
