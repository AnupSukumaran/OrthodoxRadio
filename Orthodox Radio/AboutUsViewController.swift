//
//  AboutUsViewController.swift
//  Orthodox Radio
//
//  Created by Sukumar Anup Sukumaran on 08/03/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }

    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func BackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
