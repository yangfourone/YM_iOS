//
//  HistoryViewController.swift
//  copdWalk
//
//  Created by 41 on 2018/7/23.
//  Copyright © 2018年 41. All rights reserved.
//

import UIKit
import Charts
import HealthKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activity_datetime:[String] = Array()
    var exercise_time:[String] = Array()
    var h_i_time:[String] = Array()
    var step:[String] = Array()
    var distance:[String] = Array()
    
    let url = URL(string: "http://140.118.122.241/copd/apiv1/activity/getbyuser/" + user_account!)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barChartView: BarChartView!
    
    let healthStore = HKHealthStore()
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    var weeklyStepArray:[Double] = Array()
    var weeklyStepDayArray:[String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /** weekly steps chart **/
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
        
        sleep(1)
        setChart(dataPoints: weeklyStepDayArray, values: weeklyStepArray)
        
        
        /** history table view **/
        if let data = try? Data(contentsOf: url!) {
            let new_data = String(decoding: data, as: UTF8.self)
            let data_obj = new_data.data(using: .utf8)

            if let jsonObj = try? JSONSerialization.jsonObject(with: data_obj!, options: .allowFragments) {
                for history in jsonObj as! [[String: AnyObject]] {
                    
                    let exerciseFrom = history["start_time"] as! String
                    let exerciseTo = history["end_time"] as! String
//                    let fromFormatter = DateFormatter()
//                    let toFormatter = DateFormatter()
//                    fromFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    toFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    let fromDatetime = fromFormatter.date(from: exerciseFrom)
//                    let toDatetime = toFormatter.date(from: exerciseTo)
                    
                    
                    exercise_time.append(calculateTimeDifference(from: exerciseFrom, to: exerciseTo))
                    activity_datetime.append(history["start_time"] as! String)
                    h_i_time.append(history["h_i_time"] as! String)
                    step.append(history["step"] as! String)
                    distance.append(history["distance"] as! String)
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
        return activity_datetime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Activity_Cell", for: indexPath) as! TableviewCellViewController
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryType = .none
    
        if let myDatetime = cell.activity_datetime {
            myDatetime.text = "\(activity_datetime[indexPath.row])"
        }
        if let myExerciseTime = cell.exercise_time {
            myExerciseTime.text = "\(exercise_time[indexPath.row])"
        }
        if let myHITime = cell.h_i_time {
            myHITime.text = "\(h_i_time[indexPath.row])"
        }
        if let myStep = cell.step {
            myStep.text = "\(step[indexPath.row])"
        }
        if let myDistance = cell.distance {
            myDistance.text = "\(distance[indexPath.row])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = Array()
        var counter = 0.0
        
        // create dataEntry
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: counter, y: values[i])
            dataEntries.append(dataEntry)
            counter += 1.0
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Step")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        
        // x-axis label
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.xAxis.granularity = 1
        
        // set data to chart
        barChartView.data = chartData
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
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let time = formatter.string(from: now)
        
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
                    let step_int = String(format: "%.0f", steps)
                    
                    let monthFormatter = DateFormatter()
                    let dayFormatter = DateFormatter()
                    monthFormatter.dateFormat = "M"
                    dayFormatter.dateFormat = "d"
                    let month = monthFormatter.string(from: statistics.startDate)
                    let day = dayFormatter.string(from: statistics.startDate)
                    
                    print("\(month).\(day) \(weekday): \(step_int)")
                    self.weeklyStepArray.append(Double(step_int)!)
                    self.weeklyStepDayArray.append("\(month).\(day)")
                }
            }
        }
        healthStore.execute(query)
    }
    
    func calculateTimeDifference(from dateTime1: String, to dateTime2: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateAsString = dateTime1
        let date1 = dateFormatter.date(from: dateAsString)!
        
        let dateAsString2 = dateTime2
        let date2 = dateFormatter.date(from: dateAsString2)!
        
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        let difference = (Calendar.current as NSCalendar).components(components, from: date1, to: date2, options: [])
        
        var dateTimeDifferenceString = ""
        
        if difference.hour != 0 {
//            dateTimeDifferenceString = "\(difference.hour!)h \(difference.minute!)m \(difference.second!)s"
            dateTimeDifferenceString = "\(difference.hour!+difference.minute!)m \(difference.second!)s"
        } else if  difference.day == 0 {
            dateTimeDifferenceString = "\(difference.minute!)m \(difference.second!)s"
        }
        
        return dateTimeDifferenceString
    }
}
