//
//  BLEPeripheral.swift
//  BLE
//
//  Created by 丁松 on 15/2/16.
//  Copyright (c) 2015年 丁松. All rights reserved.
//


import Foundation
import CoreBluetooth

class BLECentral: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral!
    var data: NSMutableData!
    //var delegate: BLECentralDelegate?
    
    override init() {
        super.init()
        
        //1 将CBCenteralManager实例化
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        centralManager.scanForPeripheralsWithServices([CBUUID(string: TRANSFER_SERVICE_UUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    func stopScan() {
        centralManager.stopScan()
    }
    
    //2 当实例化成功后，对调用如下函数
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        //optional code
        println("CentralManager is initialized")
        
        switch central.state{
        case CBCentralManagerState.Unauthorized:
            println("The app is not authorized to use Bluetooth low energy.")
        case CBCentralManagerState.PoweredOff:
            println("Bluetooth is currently powered off.")
        case CBCentralManagerState.PoweredOn:
            println("Bluetooth is currently powered on and available to use.")
        default:break
        }
    }
    //3 扫描prtipheral
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        //delegate?.didDiscoverPeripheral(peripheral)
        
        //        if discoveredPeripheral != peripheral {
        //            discoveredPeripheral = peripheral
        //
        //            println("Connecting to peripheral: \(peripheral)")
        //            centralManager.connectPeripheral(peripheral, options: nil)
        //        }
        
        println("CenCentalManagerDelegate didDiscoverPeripheral")
        println("Discovered \(peripheral.name)")
        println("Rssi: \(RSSI)")
        println("Stop scan the Ble Devices")
        //myCentralManager!.stopScan()
        //cbPeripheral = peripheral
    }
    //4 连接设备
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        println("Connected to peripheral: \(peripheral)")
        
        peripheral.delegate = self
        
        peripheral.discoverServices([CBUUID(string: TRANSFER_SERVICE_UUID)])
    }
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect to peripheral: \(peripheral), " + error.localizedDescription)
    }
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("CenCentalManagerDelegate didDisconnectPeripheral")
        discoveredPeripheral = nil
    }
    //5 扫描这个外设（Peripheral）所支持服务
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error != nil {
            println("Error discovering services: " + error.localizedDescription)
            return
        }
        
        println("CBPeripheralDelegate didDiscoverServices")
        for service in peripheral.services {
            peripheral.discoverCharacteristics([CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)], forService: service as CBService)
            println("\(service.UUID)")
        }
    }
    //6 遍历这个Service所包含的Characteristics
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error != nil {
            println("Error discovering characteristics: " + error.localizedDescription)
            return
        }
        
        println("didDiscoverCharacteristicsForService: \(service)")
        
        for characteristic in service.characteristics {
            if ((characteristic as CBCharacteristic).UUID.isEqual(CBUUID(string: TRANSFER_CHARACTERISTIC_UUID))) {
                println("Discovered characteristic: \(characteristic)")
                peripheral .setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
            }
        }
    }
    //7 read
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("Error discovering characteristics: " + error.localizedDescription)
            return
        }
        
        println("Update value is \(characteristic.value)")
        
        
        
        
        var stringFromData = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)
        if (stringFromData! == "EOM") {
            println("Data Received: \(NSString(data: data, encoding: NSUTF8StringEncoding))")
            data.length = 0
        }
        else {
            data.appendData(characteristic.value)
            println("appendData: \(NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)!)")
            println("Received: " + stringFromData!)
        }
    }
    //8 write
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("Error changing notification state: " + error.localizedDescription)
            return
        }
        
        if !characteristic.UUID.isEqual(CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)) {
            return
        }
        
        if characteristic.isNotifying {
            println("Notification began on: \(characteristic)")
        }
        else {
            println("Notification stopped on: \(characteristic). Disconnecting")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}