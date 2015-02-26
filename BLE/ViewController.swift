//
//  ViewController.swift
//  BLE
//
//  Created by 丁松 on 15/2/16.
//  Copyright (c) 2015年 丁松. All rights reserved.
//

import UIKit
import CoreBluetooth



class ViewController: UIViewController, BLECentralDelegate,BLEConnectionDelegate {
    let servicePlayerUUID = CBUUID(string: "DFCDA2B5-3912-4D8D-AAB6-DD0CC116588F")
    let characteristciPlayerNameUUID = CBUUID(string: "B7583075-59C6-4227-8079-8C0DF4280F9F")
    let characteristciPlayerBioUUID = CBUUID(string: "E233D2DF-3681-4E45-8B7C-DBB6FDB7D259")

    
    
    
    var btcm: BLECentralManager!
    
    @IBOutlet weak var connectionTable: UITableView!
    
    
    var peripheralList = [CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        btcm = BLECentralManager(delegate: self)
        btcm.serviceUUIDs = [servicePlayerUUID]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func scanSwitch(sender: AnyObject) {
        if (sender as NSObject == true){
            btcm.startScan()
        }
        else {
            btcm.stopScan()
        }
    }
    @IBAction func connecButton(sender: AnyObject) {
        if btcm.connections.count > 0 {
            btcm.disconnect()
        } else {
            btcm.connect()
        }
    }
    
    
    
    
    
    
    
    func didDiscoverConnection(connecyion: BLEConnection) {
        connectionTable.reloadData()
    }
    func didConnectConnection(connection: BLEConnection) {
        connection.delegate = self
        connection.serviceUUIDs = btcm.serviceUUIDs
        connection.characteristicUUIDs = [characteristciPlayerNameUUID, characteristciPlayerBioUUID]
        connection.discoverServices()
    }
    
    
    
    
    
    //userTable
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return btcm.connections.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "peripheralCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifer)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        cell!.textLabel?.text = btcm.connections[indexPath.row].name
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var peripheral = btcm.connections[indexPath.row].peripheral
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }


    
    

}

