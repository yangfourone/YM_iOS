//
//  MedicineSettingViewController.swift
//  copdWalk
//
//  Created by yangfourone on 2019/4/12.
//  Copyright © 2019 41. All rights reserved.
//

import UIKit
import UserNotifications

class MedicineSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settingMedicineName: UILabel!
    @IBOutlet weak var settingTimePickerView: UIPickerView!
    @IBOutlet weak var settingTimeLabel: UILabel!
    @IBOutlet weak var settingOkButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var settingCloseButton: UIButton!
    
    let url = URL(string: "http://copd.local.website/apiv1/user/getbyid/" + user_account!)
    
    let medicine = ["Alvesco","AnoroEllipta","Atrovent","Berodual","Berotec","Duasma","FlixotideAccuhaler","FlixotideEvohaler","IncruseEllipta","OnbrezBreezhaler","SpioltoRespimat","Spiriva","StriverdiRespimat","UltibroBreezhaler","Ventolin"]
    let medicineEnglish = ["Alvesco","AnoroEllipta","Atrovent","Berodual","Berotec","Duasma","Flixotide Accuhaler","Flixotide Evohaler","Incruse Ellipta","Onbrez Breezhaler","Spiolto Respimat","Spiriva","Striverdi Respimat","Ultibro Breezhaler","Ventolin"]
    let medicineChinese = ["治喘樂","安肺樂易利達","定喘樂","備喘全","備勞喘","適喘樂","輔舒酮準納","輔舒酮優氟","英克賜易利達","樂昂舒","適倍樂舒沛","適喘樂","適倍樂舒沛","適維樂舒沛噴","昂帝博","范得林"]
    
    let hour = ["0時","1時","2時","3時","4時","5時","6時","7時","8時","9時","10時","11時","12時","13時","14時","15時","16時","17時","18時","19時","20時","21時","22時","23時"]
    let minute = ["0分","5分","10分","15分","20分","25分","30分","35分","40分","45分","50分","55分"]
    
    var alarmHour:String = "0"
    var alarmMinute:String = "0"
    
    var userDrug:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        /** button styling **/
        settingButton.layer.cornerRadius = 10
        settingButton.layer.borderColor = UIColor.orange.cgColor
        settingButton.layer.borderWidth = 2
        
        settingCloseButton.layer.cornerRadius = 10
        settingCloseButton.layer.borderColor = UIColor.orange.cgColor
        settingCloseButton.layer.borderWidth = 2
        
        settingOkButton.layer.cornerRadius = 10
        settingOkButton.layer.borderColor = UIColor.orange.cgColor
        settingOkButton.layer.borderWidth = 2
        
        /** get data from db **/
        if let data = try? Data(contentsOf: url!) {
            let new_data = "[\(String(decoding: data, as: UTF8.self))]"
            let data_obj = new_data.data(using: .utf8)
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data_obj!, options: .allowFragments) {
                for user in jsonObj as! [[String: AnyObject]] {
                    let userDrugObject = user["drug"] as! String
                    var userDrugArray = userDrugObject.components(separatedBy: "\"")
                    userDrugArray.remove(at: 0)
                    userDrugArray.remove(at: userDrugArray.count - 1)
                    for index in 0...userDrugArray.count/2 {
                        userDrug.append(userDrugArray[index*2])
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let Header = "藥品清單"
        return Header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDrug.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineSettingTableViewCell", for: indexPath) as! MedicineSettingTableViewCell
        
        cell.MedicinePhoto.image = UIImage(named: "\(userDrug[indexPath.row]).png")
        cell.MedicineEnglishName.text = medicineEnglish[indexPath.row]
        cell.MedicineChineseName.text = medicineChinese[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // click event
        settingImage.image = UIImage(named: "\(userDrug[indexPath.row]).png")
        settingMedicineName.text = "\(medicineChinese[indexPath.row]) \(medicineEnglish[indexPath.row])"
        settingView.isHidden = false
        
//        let UsageViewController = self.storyboard?.instantiateViewController(withIdentifier: "\(medicine[indexPath.row])Setting")
//        self.navigationController?.pushViewController(UsageViewController!, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hour.count
        } else {
            return minute.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hour[row]
        } else {
            return minute[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            alarmHour = hour[row]
        } else {
            alarmMinute = minute[row]
        }
    }
    @IBAction func settingCloseButton(_ sender: Any) {
        settingView.isHidden = true
        settingOkButton.isHidden = true
        settingTimePickerView.isHidden = true
    }
    @IBAction func settingButton(_ sender: Any) {
        settingOkButton.isHidden = false
        settingTimePickerView.isHidden = false
    }
    @IBAction func settingOkButton(_ sender: Any) {
        settingView.isHidden = true
        settingOkButton.isHidden = true
        settingTimePickerView.isHidden = true
        settingTimeLabel.text = "設定時間： \(alarmHour) \(alarmMinute)"
        foregroundNotification(alarmHour: alarmHour, alarmMinute: alarmMinute)
    }
    
    func foregroundNotification(alarmHour:String, alarmMinute:String) {
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "設定成功！"
        content.subtitle = "設定的時間為\(alarmHour)\(alarmMinute)"
        content.body = "請您要記得按時吃藥喔～～"
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
}
