//
//  DailyStepViewController.swift
//  copdWalk
//
//  Created by yangfourone on 2018/11/27.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit
import HealthKit

class DailyStepViewController: UIViewController {

    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var WeeklyTargetStep: UILabel!
    
    var currentStep:Int!
    var targetStep:Int!
    
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentStep = 3851
        targetStep = 5500
        
        // Do any additional setup after loading the view.
        progressBar.lineWidth = 20
        progressBar.labelSize = 30
        progressBar.safePercent = 85
        progressBar.setProgress(to: Double(currentStep)/Double(targetStep), withAnimation: false, CurrentStep: currentStep)
        
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
