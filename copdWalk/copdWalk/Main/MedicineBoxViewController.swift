//
//  MedicineBoxViewController.swift
//  copdWalk
//
//  Created by yangfourone on 2018/11/27.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit

class MedicineBoxViewController: UIViewController {

    @IBOutlet weak var usage: UIButton!
    @IBOutlet weak var setting: UIButton!
    @IBOutlet weak var record: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /** button styling **/
        usage.layer.cornerRadius = 10
        usage.layer.borderColor = UIColor.orange.cgColor
        usage.layer.borderWidth = 2
        
        setting.layer.cornerRadius = 10
        setting.layer.borderColor = UIColor.orange.cgColor
        setting.layer.borderWidth = 2
        
        record.layer.cornerRadius = 10
        record.layer.borderColor = UIColor.orange.cgColor
        record.layer.borderWidth = 2
    }
    
    @IBAction func usage(_ sender: Any) {
        // go to usage view controller
        
        let MedicineUsageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MedicineUsage") as! MedicineUsageViewController
        self.navigationController?.pushViewController(MedicineUsageViewController, animated: true)
    }
    
    @IBAction func setting(_ sender: Any) {
        // go to setting view controller
        
        let MedicineSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "MedicineSetting") as! MedicineSettingViewController
        self.navigationController?.pushViewController(MedicineSettingViewController, animated: true)
    }
    
    @IBAction func record(_ sender: Any) {
        // go to record view controller
        
        let MedicineRecordViewController = self.storyboard?.instantiateViewController(withIdentifier: "MedicineRecord") as! MedicineRecordViewController
        self.navigationController?.pushViewController(MedicineRecordViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
