//
//  MPlayer.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/14.
//

import Foundation
import AVFoundation

class MPlayer:ObservableObject{
    //published的变量是另一边界面需要反应修改的变量
    @Published var isMuted:Bool
    @Published var isAutoCompleted:Bool=false
    private var playMode:MeditationType
    private var musicFilePath:String?
    //暂时没用
    private var remainingSeconds:Int=0
    
    private var player:AVQueuePlayer?
    //    private var playerQueue:AVQueuePlayer?
    private var playerLooper:AVPlayerLooper?
    private var musicURL:URL?
    private var playerItem:AVPlayerItem?
    private var musicLength:Double=0
    
    init(playMode:MeditationType=MeditationType.firstLast,musicFilePath:String="",remainingSeconds:Int=0,isMuted:Bool=false) {
        
        self.isMuted=isMuted
        self.isAutoCompleted=false
        self.playMode=playMode
        self.musicFilePath=Bundle.main.path(forResource: musicFilePath, ofType: "")
        if self.musicFilePath == nil{
            self.musicURL=nil
            self.playerItem=nil
            self.remainingSeconds=0
            self.musicLength=0
            return
        }
        self.musicURL=URL(fileURLWithPath: self.musicFilePath!)
        self.playerItem=AVPlayerItem(url: self.musicURL!)
        self.remainingSeconds=remainingSeconds
        self.musicLength=CMTimeGetSeconds(playerItem!.asset.duration)
        //        resetPlayer(playMode:playMode,musicFilePath: musicFilePath, remainingSeconds: remainingSeconds, isMuted: isMuted)
    }
    
    func getMusicLength()->Double{
        return self.musicLength
    }
    
    func resetPlayer(playMode:MeditationType=MeditationType.firstLast,musicFilePath:String="",remainingSeconds:Int=0,isMuted:Bool?=nil){
        
        if isMuted != nil{
            self.isMuted = isMuted!
        }
        self.isAutoCompleted=false
        self.playMode=playMode
        self.musicFilePath=Bundle.main.path(forResource: musicFilePath, ofType: "")
        if self.musicFilePath == nil{
            self.musicURL=nil
            self.playerItem=nil
            self.player=nil
            return
        }
        self.musicURL=URL(fileURLWithPath: self.musicFilePath!)
        self.playerItem=AVPlayerItem(url: self.musicURL!)
        self.remainingSeconds=remainingSeconds
        self.musicLength=CMTimeGetSeconds(playerItem!.asset.duration)
        if player != nil{
            player?.pause()
            player=nil
        }
        
    }
    
    func toggleMuted(){
        player?.isMuted.toggle()
        isMuted=getMuteStatus()
    }
    func getMuteStatus()->Bool{
        //        if player==nil{
        //            return false
        //        }
        //        return player!.isMuted
        return player==nil ? false: player!.isMuted
    }
    func startPlay(){
        self.isAutoCompleted=false
        guard playerItem != nil else{
            return
        }
        switch playMode {
        case MeditationType.loop:
            player=AVQueuePlayer()
            playerLooper=AVPlayerLooper(player: player!, templateItem: playerItem!)
            player!.rate=1.0
            player?.isMuted=self.isMuted
            player!.play()
        case MeditationType.first,MeditationType.firstLast:
            player=AVQueuePlayer(playerItem: playerItem!)
            player!.rate=1.0
            player?.isMuted=self.isMuted
            player!.play()
            //            player.pause()
            break
        //        case "firstlast":
        //            break
        //        default:
        //            break
        }
    }
    
    func stopPlay(){
        guard player != nil else {
            return
        }
        player!.pause()
    }
    
    func continuePlay(){
        guard player != nil else {
            return
        }
        player!.play()
    }
    
    
    func lastPlay(){
        guard player != nil else {
            return
        }
        player!.pause()
        
        guard playerItem != nil else{
            return
        }
        
        player=AVQueuePlayer(playerItem: playerItem!)
        player!.rate=1.0
        player?.isMuted=self.isMuted
        player?.play()
    }
    
    func endPlay(){
        guard player != nil else {
            return
        }
        player!.pause()
        switch playMode {
        case MeditationType.firstLast:
            //如果音乐时长小于整体时长，结束时再播放一次音乐
            if(isAutoCompleted){
                //            if(remainingSeconds>Int(musicLength)){
                
                guard musicURL != nil else{
                    return
                }
                self.playerItem=AVPlayerItem(url: self.musicURL!)
                player=AVQueuePlayer(playerItem: playerItem)
                //                player!.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
                player?.isMuted=self.isMuted
                player!.play()
            }
        default:
            player=nil
        }
    }
}
