//
//  ContainerViewController.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 06/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import SidebarOverlay



class ContainerViewController: SOContainerViewController {
    
    var sideMenuViewAssigned:Bool?
    var sideMenuV2:Bool = false
    
    override var isSideViewControllerPresented: Bool {
        
        didSet {
       
            let action = isSideViewControllerPresented ? "opened" : "closed"
            let side = self.menuSide == .left ? "left" : "right"
            NSLog("You've \(action) the \(side) view controller.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.menuSide = .left
        
        
        
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "SidePanelViewController")
        
        
    }
    

    
    
    
}
