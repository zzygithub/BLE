//
//  BLEPeripheral.swift
//  BLE
//
//  Created by 丁松 on 15/2/19.
//  Copyright (c) 2015年 丁松. All rights reserved.
//


import Foundation
import CoreBluetooth

class BLEPeripheral: NSObject, CBPeripheralManagerDelegate {
    
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic!
    
    override init() {
        super.init()
        //1
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    func startAdvertisingToPeripheral() {
        if !peripheralManager.isAdvertising {
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: TRANSFER_SERVICE_UUID)]])
        }
    }
    //2 creat & add service
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
        if peripheral.state != CBPeripheralManagerState.PoweredOn {
            return
        }
        transferCharacteristic = CBMutableCharacteristic(type: CBUUID(string: TRANSFER_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Notify, value: nil, permissions: CBAttributePermissions.Readable)
        var transferService = CBMutableService(type: CBUUID(string: TRANSFER_SERVICE_UUID), primary: true)
        transferService.characteristics = [transferCharacteristic]
        peripheralManager.addService(transferService)
    }
    //3
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        println("Central subscribed to characteristic: \(characteristic)")
    }
    //4
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
        println("Central unsubscribed from characteristic")
    }
    //5
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        println("Ready to transfer")
        //polling transfer data
    }
}