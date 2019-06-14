//
//  RegisterViewController.swift
//  copdWalk
//
//  Created by 41 on 2018/7/23.
//  Copyright © 2018年 41. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, SSRadioButtonControllerDelegate  {
    
    let url = URL(string: "http://copd.local.website/apiv1/user/add")
    let EvaluateUrl = URL(string: "http://copd.local.website/apiv1/evaluate/add")
    
    // button
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var submit: UIButton!
    
    // UserData
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password_confirm: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    
    // mMRC
    @IBOutlet weak var mMRC_0: UIButton!
    @IBOutlet weak var mMRC_1: UIButton!
    @IBOutlet weak var mMRC_2: UIButton!
    @IBOutlet weak var mMRC_3: UIButton!
    @IBOutlet weak var mMRC_4: UIButton!
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
    
    // drug && history
    @IBOutlet var drug: [Checkbox]!
    @IBOutlet var history: [Checkbox]!
    var user_drug:[String]! = ["None"]
    var user_history:[String]! = ["None"]
    @IBOutlet weak var drug_other: UITextField!
    @IBOutlet weak var history_other: UITextField!
    
    // form button delegate
    var mMRC: SSRadioButtonsController?
    var cat1: SSRadioButtonsController?
    var cat2: SSRadioButtonsController?
    var cat3: SSRadioButtonsController?
    var cat4: SSRadioButtonsController?
    var cat5: SSRadioButtonsController?
    var cat6: SSRadioButtonsController?
    var cat7: SSRadioButtonsController?
    var cat8: SSRadioButtonsController?
    var gender: SSRadioButtonsController?
    
    // form points
    var mMRC_point: UIButton?
    var cat1_point: UIButton?
    var cat2_point: UIButton?
    var cat3_point: UIButton?
    var cat4_point: UIButton?
    var cat5_point: UIButton?
    var cat6_point: UIButton?
    var cat7_point: UIButton?
    var cat8_point: UIButton?
    var choosing_gender:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /** close keyboard when click anywhere **/
        self.hideKeyboardWhenTappedAround()
        
        /** button style setting **/
        back.layer.cornerRadius = 10
        back.layer.borderColor = UIColor.black.cgColor
        back.layer.borderWidth = 2
        
        submit.layer.cornerRadius = 10
        submit.layer.borderColor = UIColor.orange.cgColor
        submit.layer.borderWidth = 2
        
        /** drug style setting **/
        for drug_button in drug {
            drug_button.borderStyle = .circle
            drug_button.checkedBorderColor = .blue
            drug_button.uncheckedBorderColor = .black
            drug_button.checkmarkColor = .blue
            drug_button.checkmarkStyle = .tick
        }
        
        /** history style setting **/
        for history_button in history {
            history_button.borderStyle = .circle
            history_button.checkedBorderColor = .blue
            history_button.uncheckedBorderColor = .black
            history_button.checkmarkColor = .blue
            history_button.checkmarkStyle = .tick
        }
        
        /** mMRC and CAT **/
        mMRC = SSRadioButtonsController(buttons: mMRC_0, mMRC_1, mMRC_2, mMRC_3, mMRC_4)
        mMRC!.delegate = self
        
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
        
        gender = SSRadioButtonsController(buttons: male, female)
        gender!.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectButton(selectedButton: UIButton?) {
        mMRC_point = mMRC!.selectedButton()
        cat1_point = cat1!.selectedButton()
        cat2_point = cat2!.selectedButton()
        cat3_point = cat3!.selectedButton()
        cat4_point = cat4!.selectedButton()
        cat5_point = cat5!.selectedButton()
        cat6_point = cat6!.selectedButton()
        cat7_point = cat7!.selectedButton()
        cat8_point = cat8!.selectedButton()
        choosing_gender = gender!.selectedButton()
    }
    
    @IBAction func submit(_ sender: Any) {
        
        // initialize the drug and history array
        user_drug = ["None"]
        user_history = ["None"]
        // append the choosing drug and history into array
        for drug_select in drug {
            if drug_select.isChecked {
                user_drug.append(drug_select.restorationIdentifier!)
            }
        }
        for history_select in history {
            if history_select.isChecked {
                user_history.append(history_select.restorationIdentifier!)
            }
        }
        
        if password.text != password_confirm.text {
            
            print("密碼與確認密碼不符")
            
            //TODO: 新增一個提醒，提醒使用者密碼與確認密碼不符
            let alertController = UIAlertController(title: "ERROR", message: "密碼與確認密碼不符", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "我知道了", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        } else if ((mMRC_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((cat1_point?.currentTitle) != nil) && ((choosing_gender?.currentTitle) != nil) && ((account.text) != nil) && ((password.text) != nil) && ((password_confirm.text) != nil) && ((age.text) != nil) && ((height.text) != nil) && ((weight.text) != nil) {
            
            // 填寫完成才把 None 拿掉
            user_drug.remove(at: 0)
            user_history.remove(at: 0)
            
            // 抓取現在時間
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let time = formatter.string(from: now)
            
            // bmi 計算
            let user_bmi = Float(weight.text!)!/((Float(height.text!)!/100)*(Float(height.text!)!/100))
            var user_gender = 0
            
            // gender transfer
            if choosing_gender?.currentTitle == "男" {
                user_gender = 0
            } else {
                user_gender = 1
            }
            
            print("User account: \(account.text!)")
            print("User password: \(password.text!)")
            print("Comfirm password: \(password_confirm.text!)")
            print("User name： \(last_name.text!) \(first_name.text!)")
            print("User gender： \(user_gender)")
            print("User age: \(age.text!)")
            print("User height: \(height.text!)")
            print("User weight: \(weight.text!)")
            print("user select the drug list: \(user_drug!)")
            print("user select the history list: \(user_history!)")
            print("User other drug: \(drug_other.text!)")
            print("User other history: \(history_other.text!)")
            print("User BMI: \(user_bmi)")
//            print("mMRC： \((mMRC_point?.currentTitle)!) points")
//            print("cat1： \((cat1_point?.currentTitle)!) points")
//            print("cat2： \((cat2_point?.currentTitle)!) points")
//            print("cat3： \((cat3_point?.currentTitle)!) points")
//            print("cat4： \((cat4_point?.currentTitle)!) points")
//            print("cat5： \((cat5_point?.currentTitle)!) points")
//            print("cat6： \((cat6_point?.currentTitle)!) points")
//            print("cat7： \((cat7_point?.currentTitle)!) points")
//            print("cat8： \((cat8_point?.currentTitle)!) points")
            print("Current Time: \(time)")
            
            // user data upload to server
            var request = URLRequest(url: url!)
            request.httpBody = "id=\(account.text!)&pwd=\(password.text!)&fname=\(first_name.text!)&lname=\(last_name.text!)&age=\(age.text!)&sex=\(user_gender)&bmi=\(user_bmi)&height=\(height.text!)&weight=\(weight.text!)&history=\(user_history!)&drug=\(user_drug!)&history_other=\(history_other.text!)&drug_other=\(drug_other.text!)".data(using: .utf8)
            request.httpMethod = "POST"

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil && data != nil else {
                    print("error=\(String(describing: error))")
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }

                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
            
            // evaluate data upload to server
            var EvaluateRequest = URLRequest(url: EvaluateUrl!)
            EvaluateRequest.httpBody = "uid=\(account.text!)&mmrc=\((mMRC_point?.currentTitle)!)&cat1=\((cat1_point?.currentTitle)!)&cat2=\((cat2_point?.currentTitle)!)&cat3=\((cat3_point?.currentTitle)!)&cat4=\((cat4_point?.currentTitle)!)&cat5=\((cat5_point?.currentTitle)!)&cat6=\((cat6_point?.currentTitle)!)&cat7=\((cat7_point?.currentTitle)!)&cat8=\((cat8_point?.currentTitle)!)&datetime=\(time)".data(using: .utf8)
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
                print("responseString = \(String(describing: responseString))")
            }
            EvaluateTask.resume()
            
            // success alert
            let alertController = UIAlertController(title: "Success", message: "註冊成功, 請登入系統", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
                self.dismiss (animated: true, completion: nil)
                
                //TODO: back to main controller
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            print("ERROR: Empty Answer!")
            
            // Empty answer alert
            let alertController = UIAlertController(title: "ERROR", message: "請確認資料與表單是否填寫完成", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "我知道了", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
