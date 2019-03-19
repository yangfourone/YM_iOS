//
//  ViewController.swift
//  CatchJSONdataFromURL
//
//  Created by yangfourone on 2018/9/30.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var user_drug:[String]?
    var user_history:[String]?
    var user_drug_other:[String]?
    var user_history_other:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "http://140.118.122.241/copd/apiv1/user/getbyid/qwerty")
        
        if let data = try? Data(contentsOf: url!) {
            let new_data = "[\(String(decoding: data, as: UTF8.self))]"
            let data_obj = new_data.data(using: .utf8)
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data_obj!, options: .allowFragments) {
                for user in jsonObj as! [[String: AnyObject]] {

                    let user_cell = ["\(user["id"] as! String)","\(user["fname"] as! String) \(user["lname"] as! String)","\(user["age"] as! String)","\(user["sex"] as! String)","\(user["height"] as! String)","\(user["weight"] as! String)","\(user["bmi"] as! String)","\(user["drug"] as! String)","\(user["history"] as! String)","\(user["drug_other"] as! String)","\(user["history_other"] as! String)"]

                    print(user_cell)
                }
            }
        }
    }
}

