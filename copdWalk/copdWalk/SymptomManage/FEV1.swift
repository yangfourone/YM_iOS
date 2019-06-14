//
//  FEV1.swift
//  copdWalk
//
//  Created by yangfourone on 2019/5/23.
//  Copyright © 2019 41. All rights reserved.
//

import UIKit

class FEV1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let alertController = UIAlertController(title: "匯入資料", message: "請填寫FEV1數值", preferredStyle: .alert)
        let fev1Action = UIAlertAction(title: "確定上傳", style: .default) {
            (action) in
            let fev1 = alertController.textFields![0].text
            
            if (fev1 == "") {
                // 修改項目為空
                let alertController = UIAlertController(title: "ERROR", message: "FEV1值不能為空", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "我知道了", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                // 上傳更新
                self.uploadFev1Data(fev1: Double(fev1!)!)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addTextField {
            (textField) in
            textField.placeholder = "fev1數值"
        }
        
        alertController.addAction(fev1Action)
        let Cancel = UIAlertAction(title: "取消更新", style: .cancel) {
            (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(Cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func uploadFev1Data(fev1:Double) {
        let url = URL(string: "http://copd.local.website/apiv1/fev1/add")
        var request = URLRequest(url: url!)
        request.httpBody = "id=\(user_account!)&fev1=\(String(fev1))".data(using: .utf8)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil && data != nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            let responseString = String(data: data!, encoding: .utf8)
            print("responseString = \(String(describing: responseString!))")
            print("response: \(response!)")
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
        
        task.resume()
    }
}
