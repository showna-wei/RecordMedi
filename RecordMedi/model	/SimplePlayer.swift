//
//  SimplePlayer.swift
//  RecordMedi
//
//  Created by showna hsue on 2022/10/18.
//

import Foundation
import AVFoundation

class SimplePlayer:ObservableObject{
    //published的变量是另一边界面需要反应修改的变量
    private var player:AVPlayer?
    
    func startPlay(mURL:URL){
        player?.pause()
        player=nil
        let playerItem=AVPlayerItem(url: mURL)
        player=AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
    func stopPlay(){
        guard player != nil else {
            return
        }
        player!.pause()
        player=nil
    }
}
