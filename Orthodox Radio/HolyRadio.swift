//
//  HolyRadio.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 02/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import AVFoundation

open class HolyRadio: NSObject {
    
    /// AVPlayer
    private var player: AVPlayer?
    
    open static let shared = HolyRadio()
    
    @objc public enum FRadioPlaybackState: Int {
        
        /// Player is playing
        case playing
        
        /// Player is paused
        case paused
        
        /// Player is stopped
        case stopped
        
        /// Return a readable description
        public var description: String {
            switch self {
            case .playing: return "Player is playing"
            case .paused: return "Player is paused"
            case .stopped: return "Player is stopped"
            }
        }
    }

    
//    /// Playing state of type `FRadioPlaybackState`
//    open private(set) var playbackState = FRadioPlaybackState.stopped {
//        didSet {
//            guard oldValue != playbackState else { return }
//            delegate?.radioPlayer(self, playbackStateDidChange: playbackState)
//        }
//    }
    
    open var radioURL: URL? {
      //  print("HIT1")
        didSet {
            radioURLDidChange(with: radioURL)
            print("HIT1")
        }
        
    }
    
    open func togglePlaying() {
         play()
    }
    
    open func play() {
        guard let player = player else { return }
        
//        if player.currentItem == nil, playerItem != nil {
//            player.replaceCurrentItem(with: playerItem)
//        }
        
        player.play()
        //playbackState = .playing
    }
    
    private override init() {
        super.init()
        print("HIT2")
        // Enable bluetooth playback
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback, with: [.defaultToSpeaker, .allowBluetooth])
        
  
    }
    
    private func radioURLDidChange(with url: URL?) {
        
        print("HIT3")

       guard let url = url else { return }

        preparePlayer(with: AVAsset(url: url)) { (success, asset) in
            guard success, let asset = asset else {

                return
            }
             print("HIT4")
            self.setupPlayer(with: asset)
        }
    }
    
    private func setupPlayer(with asset: AVAsset) {
        
         print("HIT5")
        if player == nil {
            player = AVPlayer()
             print("HIT6")
        }
        
    
    }
    
    private func preparePlayer(with asset: AVAsset?, completionHandler: @escaping (_ isPlayable: Bool, _ asset: AVAsset?)->()) {
        guard let asset = asset else {
            completionHandler(false, nil)
            return
        }
        
        let requestedKey = ["playable"]
        
        asset.loadValuesAsynchronously(forKeys: requestedKey) {
            
            DispatchQueue.main.async {
                var error: NSError?
                
                let keyStatus = asset.statusOfValue(forKey: "playable", error: &error)
                if keyStatus == AVKeyValueStatus.failed || !asset.isPlayable {
                    completionHandler(false, nil)
                    return
                }
                
                completionHandler(true, asset)
            }
        }
    }

}
