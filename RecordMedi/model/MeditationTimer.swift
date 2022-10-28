//
//  MeditationTimer.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/12.
//  To Time the whole meditation Record

import Foundation

//for keeping time of a meditation,keep track of the total progress,and functionza
class MeditationTimer:ObservableObject{
    @Published var isCompleted:Bool
    
    @Published var secondsElapsed=0
    @Published var secondsRemaining=0
    private var lastSecondsElapse=0
    
    private(set) var lengthInMinutes:Double
    
    private var timer:Timer?
    //update?
    private var frequency:TimeInterval{1.0/60.0}
    private var lengthInSeconds:Int{
        Int(lengthInMinutes*60.0)
//        return 20
    }
    
    private var startDate:Date?
    
    
    init(lengthInMinutes:Double=0,isCompleted:Bool=false){
        self.lengthInMinutes=lengthInMinutes
        self.secondsElapsed=0
        self.secondsRemaining=Int(self.lengthInMinutes*60)
        self.isCompleted=false
    }
    
    //start the timer,set update interval
    func startMeditation(lengthInMinutes:Double){
        self.lastSecondsElapse=0
        self.lengthInMinutes=lengthInMinutes
        self.isCompleted=false
        secondsRemaining=self.lengthInSeconds
        continueMeditation()
    }
    //update at frequency variable
    func update(secondsElapsed:Int){
        self.secondsElapsed=secondsElapsed
        self.secondsRemaining=max(self.lengthInSeconds-self.secondsElapsed,0)
        
        //will repeat many times,so need to stop
        if self.secondsElapsed==self.lengthInSeconds && timer != nil {
//            if self.secondsElapsed==self.lengthInSeconds && timer != nil && !self.isCompleted{
            print("timer completed set true")
//            self.isCompleted=true
            self.isCompleted=true
        }
    }
    
    //stop the timer
    func pauseMeditation(){
        self.lastSecondsElapse=self.secondsElapsed
        timer?.invalidate()
    }
    
    //re-open a  timer
    func continueMeditation(){
        self.startDate=Date()
        self.secondsElapsed=self.lastSecondsElapse
        self.secondsRemaining=self.lengthInSeconds-secondsElapsed
        self.timer=Timer.scheduledTimer(withTimeInterval: frequency, repeats: true){[weak self]timer in
            if let self=self, let startDate=self.startDate{
                //count the elapsed sencond by current time
                let secondsElapsed = Date().timeIntervalSince1970-startDate.timeIntervalSince1970+Double(self.lastSecondsElapse)
                self.update(secondsElapsed:Int(secondsElapsed))
            }
        }
    }
    
    //end the meditation,timer
    func endMeditation(){
        timer?.invalidate()
        timer=nil
    }
    
    //restart a new timer
    func reset(lengthInMinutes:Double=0){
        self.lengthInMinutes=lengthInMinutes
        self.secondsElapsed=0
        self.secondsRemaining=Int(self.lengthInMinutes*60)
        
        timer?.invalidate()
        timer=nil
        //还是会触发update
//        self.isCompleted=false
    }
}

extension DailyApp{
    var timer:MeditationTimer{
        MeditationTimer(lengthInMinutes: lengthInMinutes)
    }
}

