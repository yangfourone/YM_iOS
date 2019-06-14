//
//  PersonalInfoViewController.swift
//  copdWalk
//
//  Created by 41 on 2018/7/23.
//  Copyright © 2018年 41. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let EditPersonalDataUrl = URL(string: "http://copd.local.website/apiv1/user/update")
    let url = URL(string: "http://copd.local.website/apiv1/user/getbyid/" + user_account!)
//    let url = URL(string: "https://140.118.122.241/copd/apiv1/user/getbyid/" + user_account!)
    
    var cellTitle = ["帳號","姓名","年齡","性別","身高","體重","BMI","用藥","病史","其他用藥","其他病史"]
    var user_cell:[String] = Array()
    var userFirstname:String!
    var userLastname:String!
    var userSex:String!
    var userPassword:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let data = try? Data(contentsOf: url!) {
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                for user in jsonObj as! [[String: AnyObject]] {
                    
                    let user_sex = user["sex"] as! String == "1" ? "男" : "女"
                    
                    user_cell.append(user["id"] as! String)
                    user_cell.append("\(user["fname"] as! String) \(user["lname"] as! String)")
                    user_cell.append(user["age"] as! String)
                    user_cell.append(user_sex)
                    user_cell.append(user["height"] as! String)
                    user_cell.append(user["weight"] as! String)
                    user_cell.append(user["bmi"] as! String)
                    user_cell.append(user["drug"] as! String)
                    user_cell.append(user["history"] as! String)
                    user_cell.append(user["drug_other"] as! String)
                    user_cell.append(user["history_other"] as! String)
                    
                    print(user_cell)
                    
                    userSex = (user["sex"] as! String)
                    userPassword = (user["pwd"] as! String)
                    userFirstname = (user["fname"] as! String)
                    userLastname = (user["lname"] as! String)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfo_Cell", for: indexPath)
        
        // cell setting
        cell.accessoryType = .none
        cell.textLabel?.textColor = UIColor.blue
        
        if let myTitle = cell.textLabel {
            myTitle.text = "\(cellTitle[indexPath.row])"
        }
        
        if let myDetail = cell.detailTextLabel {
            myDetail.text = "\(user_cell[indexPath.row])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // click event
        print(cellTitle[indexPath.row])
        print(user_cell[indexPath.row])
        
        editPersonalInformation(index: indexPath.row, item: cellTitle[indexPath.row], data: user_cell[indexPath.row])
    }
    
    func editPersonalInformation(index:Int, item: String, data: String) {
        
        let alertController = UIAlertController(title: "編輯個人資料", message: "請做 \(item) 的資料更新", preferredStyle: .alert)
        
        if item == "姓名" {
            let EditAction = UIAlertAction(title: "確定更新", style: .default) {
                (action) in
                let EditFirstName = alertController.textFields![0].text
                let EditLastName = alertController.textFields![1].text
                
                if (EditFirstName == "") || (EditLastName == "") {
                    // 姓名為空
                    let alertController = UIAlertController(title: "ERROR", message: "姓名不能為空", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "我知道了", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // 修改表格內容
                    self.userFirstname = EditFirstName
                    self.userLastname = EditLastName
                    self.user_cell[index] = "\(EditFirstName!) \(EditLastName!)"
                    self.tableView.reloadData()
                    // 上傳更新
                    self.uploadData()
                }
            }
            
            alertController.addTextField {
                (textField) in
                textField.placeholder = "姓: \(self.userFirstname!)"
            }
            alertController.addTextField {
                (textField) in
                textField.placeholder = "名: \(self.userLastname!)"
            }
            
            alertController.addAction(EditAction)
        }
        
        else if item == "身高" {
            let EditAction = UIAlertAction(title: "確定更新", style: .default) {
                (action) in
                let EditItem = alertController.textFields![0].text
                
                if (EditItem == "") {
                    // 修改項目為空
                    let alertController = UIAlertController(title: "ERROR", message: "更改項目不能為空", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "我知道了", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // 修改表格內容
                    self.user_cell[index] = "\(EditItem!)"
                    self.user_cell[6] = String(format: "%.2f", Float(self.user_cell[5])!/((Float(self.user_cell[index])!/100.0)*(Float(self.user_cell[index])!/100.0)))
                    self.tableView.reloadData()
                    // 上傳更新
                    self.uploadData()
                }
            }
            
            alertController.addTextField {
                (textField) in
                textField.placeholder = "\(data)"
            }
            
            alertController.addAction(EditAction)
        }
        
        else if item == "體重" {
            let EditAction = UIAlertAction(title: "確定更新", style: .default) {
                (action) in
                let EditItem = alertController.textFields![0].text
                
                if (EditItem == "") {
                    // 修改項目為空
                    let alertController = UIAlertController(title: "ERROR", message: "更改項目不能為空", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "我知道了", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // 修改表格內容
                    self.user_cell[index] = "\(EditItem!)"
                    self.user_cell[6] = String(format: "%.2f", Float(self.user_cell[index])!/((Float(self.user_cell[4])!/100.0)*(Float(self.user_cell[4])!/100.0)))
                    self.tableView.reloadData()
                    // 上傳更新
                    self.uploadData()
                }
            }
            
            alertController.addTextField {
                (textField) in
                textField.placeholder = "\(data)"
            }
            
            alertController.addAction(EditAction)
        }
        
        else if item == "性別" {
            let EditAction = UIAlertAction(title: "確定更新", style: .default) {
                (action) in
                let EditItem = alertController.textFields![0].text
                
                if (EditItem == "") {
                    // 修改項目為空
                    let alertController = UIAlertController(title: "ERROR", message: "更改項目不能為空", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "我知道了", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else if EditItem == "男" {
                    // 修改表格內容
                    self.user_cell[index] = "\(EditItem!)"
                    self.tableView.reloadData()
                    self.userSex = "1"
                    self.uploadData()
                } else if EditItem == "女" {
                    // 修改表格內容
                    self.user_cell[index] = "\(EditItem!)"
                    self.tableView.reloadData()
                    self.userSex = "0"
                    self.uploadData()
                } else {
                    // 修改項目為空
                    let alertController = UIAlertController(title: "ERROR", message: "請輸入男或女", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "我知道了", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            alertController.addTextField {
                (textField) in
                textField.placeholder = "\(data)"
            }
            
            alertController.addAction(EditAction)
        }
        
        else if item == "帳號" || item == "BMI" {
            let alertController = UIAlertController(title: "ERROR", message: "此項目不可作更動", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "我知道了", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else if item == "年齡" {
            let EditAction = UIAlertAction(title: "確定更新", style: .default) {
                (action) in
                let EditItem = alertController.textFields![0].text
                
                if (EditItem == "") {
                    // 修改項目為空
                    let alertController = UIAlertController(title: "ERROR", message: "更改項目不能為空", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "我知道了", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // 修改表格內容
                    self.user_cell[index] = "\(EditItem!)"
                    self.tableView.reloadData()
                    // 上傳更新
                    self.uploadData()
                }
            }
            
            alertController.addTextField {
                (textField) in
                textField.placeholder = "\(data)"
            }
            
            alertController.addAction(EditAction)
        }
        
        else {
            let EditAction = UIAlertAction(title: "確定更新", style: .default) {
                (action) in
                let EditItem = alertController.textFields![0].text
                // 修改表格內容
                self.user_cell[index] = "\(EditItem!)"
                self.tableView.reloadData()
                // 上傳更新
                self.uploadData()
            }
            
            alertController.addTextField {
                (textField) in
                textField.placeholder = "\(data)"
            }
            
            alertController.addAction(EditAction)
        }
        
        let Cancel = UIAlertAction(title: "取消更新", style: .cancel)
        alertController.addAction(Cancel)

        present(alertController, animated: true, completion: nil)
    }
    
    func uploadData() {
        print(user_cell)
        // evaluate data upload to server
        
        var EditPersonalDataRequest = URLRequest(url: EditPersonalDataUrl!)
        EditPersonalDataRequest.httpBody = "id=\(user_cell[0])&pwd=\(userPassword!)&fname=\(userFirstname!)&lname=\(userLastname!)&age=\(user_cell[2])&sex=\(userSex!)&bmi=\(user_cell[6])&height=\(user_cell[4])&weight=\(user_cell[5])&history=\(user_cell[8])&drug=\(user_cell[7])&history_other=\(user_cell[10])&drug_other=\(user_cell[9])".data(using: .utf8)
        EditPersonalDataRequest.httpMethod = "POST"

        let EditPersonalDataTask = URLSession.shared.dataTask(with: EditPersonalDataRequest) { (data, response, error) in
            guard error == nil && data != nil else {
                print("error=\(String(describing: error))")
                return
            }

            let responseString = String(data: data!, encoding: .utf8)
            print("responseString = \(String(describing: responseString!))")
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                // success alert
                let alertController = UIAlertController(title: "Success", message: "更新成功!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
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
        EditPersonalDataTask.resume()
    }
}
