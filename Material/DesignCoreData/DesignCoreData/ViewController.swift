//
//  ViewController.swift
//  DesignCoreData
//
//  Created by yangfourone on 2018/10/10.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewContext = app.persistentContainer.viewContext
        
        /** if the program execute in simulator, it will appearance the exact saving location **/
        print("The exact saving location in simulator: \(NSPersistentContainer.defaultDirectoryURL())")
        
        insert_oneToMany()
        query_oneToMany()
        queryUserData()
    }
    
    /** Insert Data **/
    
    func insertUserData() {
        var user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.iid = "A01"
        user.cname = "Peter"
        
        user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.iid = "A02"
        user.cname = "Corey"
        
        app.saveContext()
    }
    
    /** Insert One To Many **/
    
    func insert_oneToMany() {
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: viewContext) as! UserData
        user.iid = "A03"
        user.cname = "Wayne"
        
        // first car
        var car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "GG-1087"
        user.addToOwn(car)
        // second car
        car = NSEntityDescription.insertNewObject(forEntityName: "Car", into: viewContext) as! Car
        car.plate = "LA-9487"
        user.addToOwn(car)
        
        // save to database
        app.saveContext()
    }
    
    /** Query One To Many **/
    
    func query_oneToMany() {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        let predicate = NSPredicate(format: "iid = 'A03'")
        fetchRequest.predicate = predicate
        
        do {
            let allUsers = try viewContext.fetch(fetchRequest)
            for user in allUsers {
                if user.own == nil {
                    print("\(user.cname!) 沒有車")
                } else {
                    print("\(user.cname!) 擁有 \((user.own?.count)!) 部車")
                    
                    for car in user.own as! Set<Car> {
                        print("車牌是 \(car.plate!)")
                    }
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    /** Query Data **/
    
    func queryUserData() {
        do {
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData] {
                print("\(user.iid!),\(user.cname!)")
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    /** Delete Data **/

    func deleteUserData_OneByOne() {
        do {
            let allUsers = try viewContext.fetch(UserData.fetchRequest())
            for user in allUsers as! [UserData] {
                viewContext.delete(user)
            }
            app.saveContext()
        } catch {
            print("error: \(error)")
        }
    }
    
    func deleteUserData_Batch() {
        let batch = NSBatchDeleteRequest(fetchRequest: UserData.fetchRequest())
        do {
            try app.persistentContainer.persistentStoreCoordinator.execute(batch, with: viewContext)
        } catch {
            print("error: \(error)")
        }
    }
}

