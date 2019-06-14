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
    @IBOutlet weak var totalWeeklySteps: UILabel!
    @IBOutlet weak var totalWeeklyHITime: UILabel!
    @IBOutlet weak var currentSteps: UILabel!
    
    var weeklyStepArray:[Double] = []
    var weeklySteps:Double = 0.0
    
    let healthStore = HKHealthStore()
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HKHealthStore.isHealthDataAvailable() {
            // 設定哪些資料可以寫入
            let shareTypes = self.dataTypesToShare()
            // 設定哪些資料可以讀出
            let readTypes = self.dataTypesToRead()

            // 跳出授權畫面
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes, completion: { (success, error) in
                if success {

                    self.getStepsHistory()

                } else {
                    print("授權失敗, error: \(String(describing: error))")
                }
            })
        }
        // Do any additional setup after loading the view.
        
        sleep(1)
        setProgressbar(currentStep: Double(currentSteps.text!)!, targetStep: 5500.0)
    }
    
    func dataTypesToShare() -> Set<HKSampleType>? {
        return nil
    }

    func dataTypesToRead() -> Set<HKObjectType>? {
        var set = Set<HKObjectType>()
        set.insert(HKQuantityType.quantityType(forIdentifier: .stepCount)!)
        
        return set
    }
    
    func getStepsHistory() {
        
        let now = Date()
        // weekday format
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        // time format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = formatter.string(from: now)
        
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: now)!
        
        
        
        var interval = DateComponents()
        interval.day = 1

        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 8
        let anchorDate = Calendar.current.date(from: anchorComponents)!

        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)

        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("Error returned form resultHandler = \(String(describing: error?.localizedDescription))")
                return
            }

            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    let weekday = weekdayFormatter.string(from: statistics.startDate)
//                    print("\(weekday), steps: \(Int(steps)), date: \(statistics.startDate)")
                    self.weeklySteps += steps
                    self.weeklyStepArray.append(steps)
                    self.currentSteps.text = String(Int(steps))
                }
            }
        }

        healthStore.execute(query)
    }
    
    func setProgressbar(currentStep:Double , targetStep:Double) {
        progressbarStyling()
        let percent = String(format: "%.2f", currentStep/targetStep)
        progressBar.setProgress(to: Double(percent)!, withAnimation: true)
        totalWeeklySteps.text = "步數：\(Int(weeklySteps)) 步"
        print("步數：\(Int(weeklySteps)) 步")
    }
    
    func progressbarStyling() {
        progressBar.lineWidth = 20
        progressBar.labelSize = 0
        progressBar.safePercent = 85
    }
}
