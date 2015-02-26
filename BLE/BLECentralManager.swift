//
//  BLEPeripheral.swift
//  BLE
//
//  Created by 丁松 on 15/2/16.
//  Copyright (c) 2015年 丁松. All rights reserved.
//


import Foundation
import CoreBluetooth

protocol BLECentralDelegate {
    func didDiscoverConnection(connection: BLEConnection)
    func didConnectConnection(connection: BLEConnection)
}

//Init Centermanager -> scan peripheral -> connact peripher get connection
class BLECentralManager: NSObject, CBCentralManagerDelegate {
    var manager: CBCentralManager!
    var serviceUUIDs = [CBUUID]()
    
    var discoveredPeripheral: CBPeripheral!
    var connections = [BLEConnection]()
    
    var data: NSMutableData!
    var delegate: BLECentralDelegate!
    
    init(delegate: BLECentralDelegate) {
        super.init()
        
        manager = CBCentralManager(delegate: self, queue: nil)
        println("CentralManager is initialized")
    }
    
    
    func startScan() {
        if manager.state == CBCentralManagerState.PoweredOn {
            manager.scanForPeripheralsWithServices(serviceUUIDs, options: nil)
            println("start scan")
        }
    }
    func stopScan() {
        manager.stopScan()
        println("Stop scan")
    }
    func connect() {
        println("Connecting...")
        for connection in connections {
            let peripheral = connection.peripheral
            manager.connectPeripheral(peripheral, options: nil)
        }
    }
    func disconnect() {
        println("Disconnecting...")
        for connection in connections {
            manager.cancelPeripheralConnection(connection.peripheral)
        }
    }
    
    
    
    //----------------Central Manager delegate-------------------
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch central.state{
        case CBCentralManagerState.PoweredOn:
            println("Bluetooth is currently powered on and available to use.")
        case CBCentralManagerState.PoweredOff:
            println("Bluetooth is currently powered off.")
        case CBCentralManagerState.Unauthorized:
            println("The app is not authorized to use Bluetooth low energy.")
        default:
            println("centralManagerDidUpdateState: \(central.state)")
        }
    }
    //scan pripheral
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Discovered peripheral \(peripheral.name)")
        println("Rssi: \(RSSI)")
        
        if peripheral.name != nil {
            let connection = BLEConnection(peripheral: peripheral, name: peripheral.name)
            println("add peripheral: \(peripheral.name)")
            connections.append(connection)
            delegate.didDiscoverConnection(connection)
        }
    }
    //connect peripheral
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        let connection = connections.filter { $0.peripheral == peripheral }[0]
        println("connect peripheral: \(peripheral.name)")
        delegate.didConnectConnection(connection)
    }
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("Failed to connect to peripheral: \(peripheral), " + error.localizedDescription)
    }
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("CenCentalManagerDelegate didDisconnectPeripheral")
        discoveredPeripheral = nil
    }
}