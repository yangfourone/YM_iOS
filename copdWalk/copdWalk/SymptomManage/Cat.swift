//
//  Cat.swift
//  copdWalk
//
//  Created by yangfourone on 2018/10/28.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit

class Cat: UIViewController, SSRadioButtonControllerDelegate {
    
    let EvaluateUrl = URL(string: "http://copd.local.website/apiv1/evaluate/add")
    
    // cat1
    @IBOutlet weak var cat1_0: UIButton!
    @IBOutlet weak var cat1_1: UIButton!
    @IBOutlet weak var cat1_2: UIButton!
    @IBOutlet weak var cat1_3: UIButton!
    @IBOutlet weak var cat1_4: UIButton!
    @IBOutlet weak var cat1_5: UIButton!
    // cat2
    @IBOutlet weak var cat2_0: UIButton!
    @IBOutlet weak var cat2_1: UIButton!
    @IBOutlet weak var cat2_2: UIButton!
    @IBOutlet weak var cat2_3: UIButton!
    @IBOutlet weak var cat2_4: UIButton!
    @IBOutlet weak var cat2_5: UIButton!
    // cat3
    @IBOutlet weak var cat3_0: UIButton!
    @IBOutlet weak var cat3_1: UIButton!
    @IBOutlet weak var cat3_2: UIButton!
    @IBOutlet weak var cat3_3: UIButton!
    @IBOutlet weak var cat3_4: UIButton!
    @IBOutlet weak var cat3_5: UIButton!
    // cat4
    @IBOutlet weak var cat4_0: UIButton!
    @IBOutlet weak var cat4_1: UIButton!
    @IBOutlet weak var cat4_2: UIButton!
    @IBOutlet weak var cat4_3: UIButton!
    @IBOutlet weak var cat4_4: UIButton!
    @IBOutlet weak var cat4_5: UIButton!
    // cat5
    @IBOutlet weak var cat5_0: UIButton!
    @IBOutlet weak var cat5_1: UIButton!
    @IBOutlet weak var cat5_2: UIButton!
    @IBOutlet weak var cat5_3: UIButton!
    @IBOutlet weak var cat5_4: UIButton!
    @IBOutlet weak var cat5_5: UIButton!
    // cat6
    @IBOutlet weak var cat6_0: UIButton!
    @IBOutlet weak var cat6_1: UIButton!
    @IBOutlet weak var cat6_2: UIButton!
    @IBOutlet weak var cat6_3: UIButton!
    @IBOutlet weak var cat6_4: UIButton!
    @IBOutlet weak var cat6_5: UIButton!
    // cat7
    @IBOutlet weak var cat7_0: UIButton!
    @IBOutlet weak var cat7_1: UIButton!
    @IBOutlet weak var cat7_2: UIButton!
    @IBOutlet weak var cat7_3: UIButton!
    @IBOutlet weak var cat7_4: UIButton!
    @IBOutlet weak var cat7_5: UIButton!
    // cat8
    @IBOutlet weak var cat8_0: UIButton!
    @IBOutlet weak var cat8_1: UIButton!
    @IBOutlet weak var cat8_2: UIButton!
    @IBOutlet weak var cat8_3: UIButton!
    @IBOutlet weak var cat8_4: UIButton!
    @IBOutlet weak var cat8_5: UIButton!
    // mmrc
    @IBOutlet weak var mMRC_0: UIButton!
    @IBOutlet weak var mMRC_1: UIButton!
    @IBOutlet weak var mMRC_2: UIButton!
    @IBOutlet weak var mMRC_3: UIButton!
    @IBOutlet weak var mMRC_4: UIButton!
    
    var cat1: SSRadioButtonsController?
    var cat2: SSRadioButtonsController?
    var cat3: SSRadioButtonsController?
    var cat4: SSRadioButtonsController?
    var cat5: SSRadioButtonsController?
    var cat6: SSRadioButtonsController?
    var cat7: SSRadioButtonsController?
    var cat8: SSRadioButtonsController?
    var mMRC: SSRadioButtonsController?
    
    var cat1_point: UIButton?
    var cat2_point: UIButton?
    var cat3_point: UIButton?
    var cat4_point: UIButton?
    var cat5_point: UIButton?
    var cat6_point: UIButton?
    var cat7_point: UIButton?
    var cat8_point: UIButton?
    var mMRC_point: UIButton?
    
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** button style setting **/
        submit.layer.cornerRadius = 10
        submit.layer.borderColor = UIColor.orange.cgColor
        submit.layer.borderWidth = 2
        
        // Do any additional setup after loading the view, typically from a nib.
        
        cat1 = SSRadioButtonsController(buttons: cat1_0, cat1_1, cat1_2, cat1_3, cat1_4, cat1_5)
        cat1!.delegate = self
        
        cat2 = SSRadioButtonsController(buttons: cat2_0, cat2_1, cat2_2, cat2_3, cat2_4, cat2_5)
        cat2!.delegate = self
        
        cat3 = SSRadioButtonsController(buttons: cat3_0, cat3_1, cat3_2, cat3_3, cat3_4, cat3_5)
        cat3!.delegate = self
        
        cat4 = SSRadioButtonsController(buttons: cat4_0, cat4_1, cat4_2, cat4_3, cat4_4, cat4_5)
        cat4!.delegate = self
        
        cat5 = SSRadioButtonsController(buttons: cat5_0, cat5_1, cat5_2, cat5_3, cat5_4, cat5_5)
        cat5!.delegate = self
        
        cat6 = SSRadioButtonsController(buttons: cat6_0, cat6_1, cat6_2, cat6_3, cat6_4, cat6_5)
        cat6!.delegate = self
        
        cat7 = SSRadioButtonsController(buttons: cat7_0, cat7_1, cat7_2, cat7_3, cat7_4, cat7_5)
        cat7!.delegate = self
        
        cat8 = SSRadioButtonsController(buttons: cat8_0, cat8_1, cat8_2, cat8_3, cat8_4, cat8_5)
        cat8!.delegate = self
        
        mMRC = SSRadioButtonsController(buttons: mMRC_0, mMRC_1, mMRC_2, mMRC_3, mMRC_4)
        mMRC!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectButton(selectedButton: UIButton?) {
        cat1_point = cat1!.selectedButton()
        cat2_point = cat2!.selectedButton()
        cat3_point = cat3!.selectedButton()
        cat4_point = cat4!.selectedButton()
        cat5_point = cat5!.selectedButton()
        cat6_point = cat6!.selectedButton()
        cat7_point = cat7!.selectedButton()
        cat8_point = cat8!.selectedButton()
        mMRC_point = mMRC!.selectedButton()
    }
    
    @IBAction func submit(_ sender: Any) {
        if ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((mMRC_point?.currentTitle) != nil){
            
            // 抓取現在時間
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let time = formatter.string(from: now)
            
            // evaluate data upload to server
            var EvaluateRequest = URLRequest(url: EvaluateUrl!)
            EvaluateRequest.httpBody = "uid=\(user_account!)&mmrc=\((mMRC_point?.currentTitle)!)&cat1=\((cat1_point?.currentTitle)!)&cat2=\((cat2_point?.currentTitle)!)&cat3=\((cat3_point?.currentTitle)!)&cat4=\((cat4_point?.currentTitle)!)&cat5=\((cat5_point?.currentTitle)!)&cat6=\((cat6_point?.currentTitle)!)&cat7=\((cat7_point?.currentTitle)!)&cat8=\((cat8_point?.currentTitle)!)&datetime=\(time)".data(using: .utf8)
            EvaluateRequest.httpMethod = "POST"
            
            let EvaluateTask = URLSession.shared.dataTask(with: EvaluateRequest) { (data, response, error) in
                guard error == nil && data != nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(String(describing: responseString!))")
                if responseString == "\n\"ok\"" {
                    // success alert
                    let alertController = UIAlertController(title: "Success", message: "表單填寫成功!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) {
                        (action) in
                        self.dismiss (animated: true, completion: nil)
                        
                        // back to symptom management view controller
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // POST error
                    let alertController = UIAlertController(title: "ERROR", message: "POST Problem", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Check it", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            EvaluateTask.resume()
            
        } else {
            print("ERROR: Empty Answer!")
            
            // Empty answer alert
            let alertController = UIAlertController(title: "ERROR", message: "請確認資料與表單是否填寫完成", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "我知道了", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
