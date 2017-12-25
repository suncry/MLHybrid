//
//  MLAVPlay.swift
//  MLHybrid
//
//  Created by liushuoyu on 2017/12/21.
//

import Foundation
import AVFoundation
import MediaPlayer
open class  MLAVPlay : NSObject {
    open  static let share: MLAVPlay = MLAVPlay()
    open var avplay : AVPlayer?
    var playerItem: AVPlayerItem?

    open  func play(url: String = "http://7xpdel.com1.z0.glb.clouddn.com/luwEJUGXZSN76HyXUF4KBwIiGmNt") {
        
        let url  = URL(string:url)
        setingBackgroundPlay()
        if let item  = playerItem {
            item.removeObserver(self, forKeyPath: "status", context: nil)
        }
        
        playerItem = AVPlayerItem(url:url!)
        avplay = AVPlayer(playerItem:playerItem!)
        avplay?.play()
        avplay?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: nil, using: { [weak self] (time) in
//            guard let weakSelf = self, let item = weakSelf.playerItem else  { return }
            let current = CMTimeGetSeconds(time)
            let timeText = NSString(format: "%02ld:%02ld", Int(current)/60,Int(current)%60) as String
            print(timeText)
            print(current )

        })
        playerItem!.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            // 歌曲名称
            MPMediaItemPropertyTitle:"第一夫人",
            // 演唱者
            MPMediaItemPropertyArtist:"张杰",
            // 锁屏图片
            MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: UIImage(named: "hybridBack")!),
            //
            MPNowPlayingInfoPropertyPlaybackRate:1.0,

        ]
        
        
    }
    
    open func pause() {
        avplay?.pause()
    }

    func  setingBackgroundPlay() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try? session.setActive(true)
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard  keyPath  != nil else  { return }
        if let item = playerItem, item.status == .failed { return }
        print(playerItem!.duration.value / Int64(playerItem!.duration.timescale) )
    }
    
    
 

}

extension AVPlayer {
    
   
}
