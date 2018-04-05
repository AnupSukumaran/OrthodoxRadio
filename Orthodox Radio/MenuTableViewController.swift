//
//  MenuTableViewController.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 06/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit

//protocol ToRemoveObserversDelegate: class {
//    func callingAction()
//}

class MenuTableViewController: UITableViewController {
    
   // weak var delegate: ToRemoveObserversDelegate?
    
    @IBOutlet var menuTabel: UITableView!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationSwitch.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)

       print("WOrkis")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
                            let shareInSocialMedia = UIActivityViewController(activityItems: ["""
                Let me recommend you this application
                https://itunes.apple.com/in/app/orthodox-radio/id1359796847?mt=8
                """], applicationActivities: nil)
            
            
            self.present(shareInSocialMedia, animated: true, completion: nil)
        }
        
        if indexPath.row == 1 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            NotificationCenter.default.post(name:  NSNotification.Name("Play"), object: nil)
            
        }
        
        if indexPath.row == 2 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController")
            
            let navController = UINavigationController(rootViewController: vc)
            present(navController, animated: true, completion: nil)
        }
        
        if indexPath.row == 3 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProgrammeViewController")
            
            let navController = UINavigationController(rootViewController: vc)
            present(navController, animated: true, completion: nil)
            
        }
        
        if indexPath.row == 4 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
         //   delegate?.callingAction()
            
//            NotificationCenter.default.post(name:  NSNotification.Name("removeObservers"), object: nil)
            
            if let url = URL(string: "https://itunes.apple.com/in/app/orthodox-radio/id1359796847?mt=8"),
                UIApplication.shared.canOpenURL(url){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        if indexPath.row == 5 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
       
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutUsViewController")
            
            let navController = UINavigationController(rootViewController: vc)
            present(navController, animated: true, completion: nil)
            
        }
        
        if indexPath.row == 6 {
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
        }
    }




}
