//
//  BLEConnection.swift
//  BLE
//
//  Created by 丁松 on 15/2/26.
//  Copyright (c) 2015年 丁松. All rights reserved.
//

import Foundation
import CoreBluetooth
protocol BLEConnectionDelegate {
}

//use connection discover and add service -> use service discover and subscribe characteristics -> use characteristics send and get data
class BLEConnection: NSObject, CBPeripheralDelegate {
    var delegate: BLEConnectionDelegate!
    var peripheral: CBPeripheral!
    var name: String!
    var services = [CBService]()
    var serviceUUIDs = [CBUUID]()
    var characteristicUUIDs = [CBUUID]()
    
    init(peripheral: CBPeripheral, name: String? = nil, delegate: BLEConnectionDelegate? = nil) {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        if name != nil {
            self.name = name!
        }
        if delegate != nil {
            self.delegate = delegate!
        }
    }
    
    
    func discoverServices() {
        println("discoverServices")
        peripheral.discoverServices(serviceUUIDs)
    }
    
    func discoverCharacteristics(service: CBService) {
        println("discoverCharacteristics")
        peripheral.discoverCharacteristics(characteristicUUIDs, forService: service)
    }

    
    
    
    
    
    
    //----------every connection has functions below--------
    //scan Peripheral supported servies
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if error != nil {
            println("Error discovering services: " + error.localizedDescription)
            return
        }
        
        println("discover \(peripheral.services.count) servies")
        for service in peripheral.services {
            println("add service \(service.UUID)")
            services.append(service as CBService)
        }
        //delegate.didDiscoverServices()
    }
    //scan the service contain characteristics
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if error != nil {
            println("Error discovering characteristics: " + error.localizedDescription)
            return
        }
        
        println("discover \(service.characteristics.count) characteristics for \(service)")
        for characteristic in service.characteristics {
            peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
            println("characteristic: \(characteristic)")
            //delegate.didSubscribe()
        }
    }
    //send
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("didUpdateNotificationStateForCharacteristic error: \(characteristic.UUID) -  \(error.localizedDescription)")
            return
        }
    }
    //get
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if error != nil {
            println("didUpdateValueForCharacteristic error: \(characteristic.UUID) -  \(error.localizedDescription)")
            return
        }
        //delegate.didUpdateValue(characteristic)
    }
    
}