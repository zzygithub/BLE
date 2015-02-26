//
//  ViewController.swift
//  BLE
//
//  Created by 丁松 on 15/2/16.
//  Copyright (c) 2015年 丁松. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    var bleCentral: BLECentral!
    var peripheralList = [CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        bleCentral = BLECentral.sharedInstance
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanSwitch(sender: AnyObject) {
        if (sender as NSObject == true){
            bleCentral.startScan()
        }
        else {
            bleCentral.stopScan()
        }
    }
    
    
    //userTable
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "peripheralCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifer)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        cell!.textLabel?.text = peripheralList[indexPath.row].name
        return cell!
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //connect pre
    }

    
    

}

