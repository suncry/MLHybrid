//
//  ViewController.swift
//  MLHybrid
//
//  Created by yang cai on 08/08/2017.
//  Copyright (c) 2017 yang cai. All rights reserved.
//

import UIKit
import MLHybrid
import AVFoundation

class ViewController: UIViewController {

    var  avplay:AVPlayer!
    var  playerItem :AVPlayerItem!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let url  = URL(string:"http://7xpdel.com1.z0.glb.clouddn.com/luwEJUGXZSN76HyXUF4KBwIiGmNt")
//        playerItem = AVPlayerItem(url:url!)
//        avplay = AVPlayer(playerItem:playerItem)
       
    }

    @IBAction func click(_ sender: Any) {
        MLAVPlay.share.play()
//        let dddd = MLHybrid.load(urlString: "http://web.qa.medlinker.com/h5/hospital/z_index.html?serviceType=1&type=d")
//        let dddd = MLHybrid.load(urlString: "http://7xpdel.com1.z0.glb.clouddn.com/luwEJUGXZSN76HyXUF4KBwIiGmNt")
//
//        let navi = UINavigationController(rootViewController: dddd!)
//        navi.navigationBar.isTranslucent = false
//        self.present(navi, animated: true, completion: nil)
        
    }
    
     override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIApplication.shared.beginIgnoringInteractionEvents()
//        self.becomeFirstResponder()
    
//        let item = AudioItem(mediumQualitySoundURL: url!)
//        player.play(item: item!)
    }

    
//    override func remoteControlReceived(with event: UIEvent?) {
//        if let event = event{
//            player.remoteControlReceived(with: event)
//
//        }
//    }
}

