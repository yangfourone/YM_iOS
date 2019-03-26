//
//  ViewController.swift
//  BLE
//
//  Created by yangfourone on 2019/3/25.
//  Copyright © 2019 41. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var manager : CBCentralManager!
    var BluetoothPeripheral : CBPeripheral!
    var Characteristic : CBCharacteristic!
    @IBOutlet weak var tableView: UITableView!
    var BluetoothDevice: [String] = []
    var BluetoothDeviceUUID: [UUID] = []
    var SelectPeripheralName: String = "INITIAL BLUETOOTH SELECT PERIPHERAL NAME"
    
    /** TableView Setting **/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BluetoothDevice.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ble_cell", for: indexPath)
        cell.textLabel?.text = BluetoothDevice[indexPath.row]
        cell.detailTextLabel?.text = BluetoothDeviceUUID[indexPath.row].uuidString
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var isMyPeripheralConected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
//        print("Name: \((peripheral.name != nil) ? peripheral.name! : "nil" )")
        
        if peripheral.name != nil {
            if !BluetoothDeviceUUID.contains(peripheral.identifier) {
                BluetoothDevice.append(peripheral.name!)
                BluetoothDeviceUUID.append(peripheral.identifier)
                tableView.reloadData()
                print(BluetoothDevice)
            }
        }
        
        if peripheral.name == SelectPeripheralName {
            
            self.BluetoothPeripheral = peripheral
            self.BluetoothPeripheral.delegate = self
            
            manager.stopScan()
            manager.connect(BluetoothPeripheral, options: nil)
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isMyPeripheralConected = true // when connected change to true
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print("Failed to connect to peripheral")
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isMyPeripheralConected = false // and to falso when disconnected
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let servicePeripheral = peripheral.services as [CBService]! { // get the services of the perifereal
            
            for service in servicePeripheral {
                
                // Then look for the characteristics of the services
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characterArray = service.characteristics as [CBCharacteristic]! {
            
            for cc in characterArray {
                
                if(cc.uuid.uuidString == "FFE1") { //properties: read, write
                    //if you have another BLE module, you should print or look for the characteristic you need.
                    
                    Characteristic = cc // saved it to send data in another function.
                    
                    peripheral.readValue(for: cc) //to read the value of the characteristic
                }
                
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.uuid.uuidString == "FFE1") {
            
            let readValue = characteristic.value
            
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee // used to read an Int value
            
            print (value)
        }
    }
    
    
    //if you want to send an string you can use this function.
    func writeValue() {
        
        if isMyPeripheralConected { //check if Peripheral is connected to send data
            
            let dataToSend: Data = "Hello World!".data(using: String.Encoding.utf8)!
            
            BluetoothPeripheral.writeValue(dataToSend, for: Characteristic, type: CBCharacteristicWriteType.withoutResponse)    // Writing the data to the peripheral
            
        } else {
            print("Not connected")
        }
    }
    
    // 得知哪一行被點擊
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(BluetoothDevice[indexPath.row])
        //設定為 alert action
        let alertController = UIAlertController(title: "連接到\(BluetoothDevice[indexPath.row])?", message: "如果要連接到此裝置請按連接", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "連接", style: .default) {
            (action) in
            self.dismiss (animated: true, completion: nil)
            print("connectted......")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StopConectting(_ sender: Any) {
//        print("stop scanning.")
//        manager.stopScan()
        print("stop connectting.")
        if (BluetoothPeripheral != nil) {
            manager.cancelPeripheralConnection(BluetoothPeripheral)
        }
    }
    
    @IBAction func Rescan(_ sender: Any) {
        BluetoothDevice = []
        BluetoothDeviceUUID = []
        tableView.reloadData()
    }
}

