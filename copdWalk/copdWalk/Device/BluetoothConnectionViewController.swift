//
//  BluetoothConnectionViewController.swift
//  copdWalk
//
//  Created by yangfourone on 2019/5/23.
//  Copyright © 2019 41. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothConnectionViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isMyPeripheralConected = false
    var manager:CBCentralManager!
    var Characteristic:CBCharacteristic!
    var BluetoothDevice:[String] = []
    var BluetoothDeviceUUID:[UUID] = []
    var BluetoothPeripheral:[CBPeripheral] = []
    var BluetoothConnectingIndex:Int?
    var SelectPeripheralName:String = "INITIAL BLUETOOTH SELECT PERIPHERAL NAME"
    
    let ZoeS2_Watch_Write_Characteristic_UUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") // write
    let ZoeS2_Watch_Read_Characteristic_UUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E") // read
    let ZoeS2_Watch_Service_UUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    
    let Spo2_Wristband_Characteristic_UUID = CBUUID(string:"0000DFB1-0000-1000-8000-00805F9B34FB")
    let Spo2_Wristband_Service_UUID = CBUUID(string: "0000DFB0-0000-1000-8000-00805F9B34FB")
    
    let Env_Box_Characteristic_UUID = CBUUID(string:"6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    let Env_Box_Service_UUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    
    
    /** TableView Setting **/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BluetoothDevice.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ble_connection_cell", for: indexPath)
        cell.textLabel?.text = BluetoothDevice[indexPath.row]
        cell.detailTextLabel?.text = BluetoothDeviceUUID[indexPath.row].uuidString
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var msg = ""
        
        switch central.state {
            
        case .poweredOff:
            msg = "Bluetooth Off"
        case .poweredOn:
            msg = "Bluetooth On"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "Unsupported"
        default:
            msg = "Default"
            
        }
        
        print("BLE STATE: " + msg)
        
    }

    /** didDiscover **/
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //        print("Name: \((peripheral.name != nil) ? peripheral.name! : "nil" )")
        
        if peripheral.name != nil {
            if !BluetoothDeviceUUID.contains(peripheral.identifier) {
                BluetoothDevice.append(peripheral.name!)
                BluetoothDeviceUUID.append(peripheral.identifier)
                BluetoothPeripheral.append(peripheral)
                tableView.reloadData()
                print(BluetoothDevice)
            }
            
            if BluetoothDevice.contains(SelectPeripheralName) {
                let index = BluetoothDevice.firstIndex(of: "\(SelectPeripheralName)")
                BluetoothConnectingIndex = index!
                print("peripheralName:\(BluetoothDevice[index!])")
                self.BluetoothPeripheral[index!] = BluetoothPeripheral[index!]
                self.BluetoothPeripheral[index!].delegate = self
                
                manager.stopScan()
                manager.connect(BluetoothPeripheral[index!], options: nil)
            }
        }
    }
    
    /** didConnect **/
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isMyPeripheralConected = true // when connected change to true
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("Connected!")
        
        // alert success
        let alertController = UIAlertController(title: "Success", message: "連線成功", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "我知道了", style: .default) {
            (action) in
            // back to device view controller
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    /** didDiscoverServices **/
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("didDiscoverServices")
        
        if let serviceArray = peripheral.services { // get the services of the perifereal
            
            for service in serviceArray {
                
                // print services list
                print("Service: \(service)")
                
                /** Spo2 **/
                if service.uuid == Spo2_Wristband_Service_UUID {
                    
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                }
                    
                    /** ZoeS2 **/
                else if service.uuid == ZoeS2_Watch_Service_UUID {
                    
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                }
                    
                    /** Env Box **/
                else if service.uuid == Env_Box_Service_UUID {
                    
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
            
        }
    }
    
    /** didDiscoverCharacteristicsFor **/
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("didDiscoverCharacteristic")
        
        if let characteristicArray = service.characteristics {
            
            for characteristic in characteristicArray {
                
                // print characteristics list
                print("Characteristic: \(characteristic)")
                
                /** Spo2 **/
                if characteristic.uuid == Spo2_Wristband_Characteristic_UUID {
                    
                    Characteristic = characteristic // saved it to send data in another function.
                    let dataToSend:Data = "a".data(using: String.Encoding.utf8)!
                    peripheral.writeValue(dataToSend, for: Characteristic, type: CBCharacteristicWriteType.withResponse)
                    for _ in 0...100 {
                        peripheral.readValue(for: characteristic) //to read the value of the characteristic
                    }
                }
                    
                    /** ZoeS2 **/
                    
                    // write
                else if characteristic.uuid == ZoeS2_Watch_Write_Characteristic_UUID {
                    
                    print("write")
                    
//                    Characteristic = characteristic
//                    print(characteristic.value![0])
                    
//                    send data to pheripheral
                    let dataToSend:Data = "menu.hr".data(using: String.Encoding.utf8)!
                    peripheral.writeValue(dataToSend, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    
                }
                    
                    // read
                else if characteristic.uuid == ZoeS2_Watch_Read_Characteristic_UUID {
                    
                    print("read")
                    peripheral.readValue(for: characteristic) //to read the value of the characteristic
                    
                }
                    
                    /** Env Box **/
                else if characteristic.uuid == Env_Box_Characteristic_UUID {
                    
                    Characteristic = characteristic
                }
            }
        }
        
    }
    
    /** didUpdateValueFor **/
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        print("\ndidUpdateValueFor")
        
        // Spo2
        if (characteristic.uuid == Spo2_Wristband_Characteristic_UUID) {
            
            let readValue = characteristic.value
            let readValueString = String(data: readValue!, encoding: String.Encoding.utf8)
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee // used to read an Int value
            
            print("read string value: \(readValueString!)")
            print("read int value: \(value)")
        }
            
            // ZoeS2
        else if (characteristic.uuid == ZoeS2_Watch_Write_Characteristic_UUID) {
            
            let readValue = characteristic.value
            
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee // used to read an Int value
            
            print("write string value: \(String(describing: readValue))")
            print("write int value: \(value)")
        }
            
        else if (characteristic.uuid == ZoeS2_Watch_Read_Characteristic_UUID) {
            
            let readValue = characteristic.value
            
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee // used to read an Int value
            
            print("read string value: \(String(describing: readValue))")
            print("read int value: \(value)")
        }
        
        // env Box
    }
    
    /** didFailToConnect **/
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print("Failed to connect to peripheral")
            return
        }
    }
    
    /** didDisconnectPeripheral **/
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isMyPeripheralConected = false // and to falso when disconnected
    }
    
    
    // if you want to send an string you can use this function.
    func writeValue() {
        
        if isMyPeripheralConected { //check if Peripheral is connected to send data
            print(Characteristic)
//            let dataToSend:Data = "menu.bp".data(using: String.Encoding.utf8)!
//            BluetoothPeripheral.writeValue(dataToSend, for: Characteristic, type: CBCharacteristicWriteType.withoutResponse)
//            BluetoothPeripheral.readValue(for: Characteristic)
            
        } else {
            print("Not connected")
        }
    }
    
    // 得知哪一行被點擊
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //設定為 alert action
        let alertController = UIAlertController(title: "連接到\(BluetoothDevice[indexPath.row])?", message: "如果要連接到此裝置請按連接", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "連接", style: .default) {
            (action) in
            self.dismiss (animated: true, completion: nil)
            print("connecting...... \(self.BluetoothDevice[indexPath.row])")
            // save connecttion device name
            self.SelectPeripheralName = self.BluetoothDevice[indexPath.row]
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        //增加按鍵
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        //顯示提醒
        present(alertController, animated: true, completion: nil)
    }
    
}
