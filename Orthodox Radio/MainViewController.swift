//
//  MainViewController.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 01/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MTCircularSlider
import NVActivityIndicatorView



class MainViewController: UIViewController, NVActivityIndicatorViewable {
   
    
    
    
    
   open static let shared = MainViewController()
    
    @IBOutlet weak var backgroundView: UIImageView!
    
     let radioPlayer = HolyRadio.shared
    
     @IBOutlet weak var volumeParentView: MTCircularSlider!
    
    @IBOutlet weak var NowPlayingAnimation: UIImageView!
    
    @IBOutlet weak var LoadingPlate: UIView!
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
  
   
     var mpVolumeSlider: UISlider?
    
    var activeIndic: NVActivityIndicatorView?
    
    @IBOutlet weak var playButton: UIButton!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        self.volumeParentView.isUserInteractionEnabled = true
        self.mpVolumeSlider?.isUserInteractionEnabled = true
        setupVolumeSlider()
        
        addObserverToPlayFromSideMenu()
        createNowPlayingAnimation()
       // callingAudioURL()
        setupNotifications()
        setupRemoteCommandCenter()
        
        addNotificationToPlay()
        addNotificationToPause()
        
        let frame = CGRect(x: 0, y: 0, width: LoadingPlate.frame.width, height: LoadingPlate.frame.height)
        
        activeIndic = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.ballScaleRippleMultiple, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 0.0)
        
        self.LoadingPlate.addSubview(activeIndic!)
 }
    
    func createNowPlayingAnimation() {
        NowPlayingAnimation.animationImages = AnimationFrames.createFrames()
        NowPlayingAnimation.animationDuration = 0.7
    }
    
   

    func addObserverToPlayFromSideMenu() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Play"), object: nil, queue: nil) { (notification) in
            print("PlayDone")
            self.definePlayer()
            self.player?.play()
            self.playButton.isSelected = true
            //self.NowPlayingAnimation.startAnimating()
        }
    }
    
    func addNotificationToPlay() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("playNEW"), object: nil, queue: nil) { (notification) in
            
            self.player?.play()
            self.playButton.isSelected = true
            self.NowPlayingAnimation.startAnimating()
            print("playIT")
        }
        
    }
    
    func addNotificationToPause() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("pauseNEW"), object: nil, queue: nil) { (notification) in
            
            self.player?.pause()
            self.playButton.isSelected = false
            self.NowPlayingAnimation.stopAnimating()
            print("pauseIT")
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("DELLOCOut")
        deallocatedObservers()

    }
    
   
    
    func deallocatedObservers() {
        print("DELLOCdd")
        if let item = playerItem {
            print("DELLOC")
            item.removeObserver(self, forKeyPath: "status")
            item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            item.removeObserver(self, forKeyPath: "timedMetadata")
        }
        
        
    }
    
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       

         listenVolumeButton()
       

    }
    

    
    func callingAudioURL(){
       
        
        print("CALLED")
        
        let url = URL(string:"http://tachyon.shoutca.st:8975/stream2_autodj")
        

       
        playerItem = AVPlayerItem(url: url!)
    
        player = AVPlayer(playerItem: playerItem)
       
        print("PlayItem = \(String(describing: player?.currentItem))")
        
        if let item = playerItem {
            
            item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
            item.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
            
        
        }

        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        
        
     
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
       
        
        if keyPath == "outputVolume" {
            
            DispatchQueue.global(qos:DispatchQoS.userInitiated.qosClass).async {
                DispatchQueue.main.async {
                    
                     self.volumeParentView.value = (self.mpVolumeSlider?.value)!
                }
            }
        
        }
        
        if let item = object as? AVPlayerItem, let keyPath = keyPath, item == self.playerItem {
            
            switch keyPath {
                
            case "status":
                
                print("Status")

                
            case "playbackBufferEmpty":
                

                
               print("playbackBufferEmpty")
                
            case "playbackLikelyToKeepUp":
                 self.playButton.isHidden = false
                 self.activeIndic?.stopAnimating()
                 if playButton.isSelected {
                  NowPlayingAnimation.startAnimating()
                 }
                 
                 print("playbackLikelyToKeepUp")
                
            case "timedMetadata":
                
                 print("timedMetadata")
                
                
            default:
                break
            }
        }
    }
    
    
    



    @IBAction func SliderAct(_ sender: MTCircularSlider) {
        
 

        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {

             self.mpVolumeSlider?.setValue(self.volumeParentView.value , animated: true)

        }, completion: nil)
     
        
    }
    
    

    
    
    func setupVolumeSlider() {
        
        
        print("Check1")

        // Note: This slider implementation uses a MPVolumeView
        // The volume slider only works in devices, not the simulator.
        for subview in MPVolumeView().subviews {
       
            guard let volumeSlider = subview as? UISlider else { continue }
            mpVolumeSlider = volumeSlider
            
            print("Check2 = \(volumeSlider.value)")
            
        }
        
        
       guard let mpVolumeSlider = mpVolumeSlider else { return }
        
       self.view.addSubview(mpVolumeSlider)
      
        //volumeParentView.addSubview(mpVolumeSlider )
       
        mpVolumeSlider.frame = CGRect(x: -1000, y: -1000, width: 0, height: 0)

        print("Check3 = \(mpVolumeSlider.value)")
        
    }
    
    
    
    func listenVolumeButton(){
        
        DispatchQueue.main.async {
            self.volumeParentView.value = (self.mpVolumeSlider?.value)!
        }
       
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(true)
        } catch let error {
            print("Error = \(error.localizedDescription)")
        }
  
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
   
    }
    

    
    
    @IBAction func MenuAction(_ sender: Any) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            
            print("User is connected to the internet via wifi.")
            
        }else if currentReachabilityStatus == .reachableViaWWAN{
            
            print("User is connected to the internet via WWAN.")
            
        } else {
            print("No internet via WWAN.")
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func definePlayer() {
        if playerItem == nil {
            print("PlayerItem is Nil")
            self.callingAudioURL()
            self.playButton.isHidden = true
            self.activeIndic?.startAnimating()
        } else {
            print("PlayerItem is Not Nil")
            NowPlayingAnimation.startAnimating()
        }
    }
 
    
    
    @IBAction func playActButton(_ sender: UIButton) {
        

        
    if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
            
        
            sender.isSelected = !sender.isSelected
       
            if sender.isSelected {
                
                definePlayer()
                player?.play()
         
            }else{
                player?.pause()
                NowPlayingAnimation.stopAnimating()
             
            }
        } else {
            
            playerItem = nil
            
            let alert = UIAlertController(title: "Network Offline", message: "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
  
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //New
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleInterruption), name: .AVAudioSessionInterruption, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(handleRouteChange), name: .AVAudioSessionRouteChange, object: nil)
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        
        switch type {
        case .began:
            DispatchQueue.main.async {
                print("Found1😃😄😁")
                self.player?.pause()
                self.playButton.isSelected = false
                self.NowPlayingAnimation.stopAnimating()
               // self.pause()
                
            }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { break }
            let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
            DispatchQueue.main.async {
                print("Hello1234😁")
       options.contains(.shouldResume) ? print("self.play()") : print("self.pause()") }
        }
    }
    
    // For Info Center
    
    func setupRemoteCommandCenter() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
    }
    
}
