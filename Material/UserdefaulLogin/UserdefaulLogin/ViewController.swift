//
//  ViewController.swift
//  UserdefaulLogin
//
//  Created by yangfourone on 2018/11/6.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error_msg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        error_msg.isHidden = true
        if UserDefaults.standard.bool(forKey: "isLogin") {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(homeVC, animated: false)
        }
    }

    @IBAction func login(_ sender: Any) {
        if account.text == "" && password.text == "" {
            error_msg.isHidden = true
            UserDefaults.standard.set(true, forKey: "isLogin")
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(homeVC, animated: true)
        } else {
            error_msg.isHidden = false
            error_msg.text = "ERROR!"
        }
    }
}

