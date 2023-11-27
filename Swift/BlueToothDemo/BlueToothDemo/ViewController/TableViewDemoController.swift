//
//  TableViewDemoController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import CoreBluetooth
import UIKit
import WWPrint

final class TableViewDemoController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    private var peripherals: [CBPeripheral] = [] {
        didSet { myTableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        WWBluetoothManager.shared.startScan(delegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let device = WWBluetoothManager.shared.findPeripheral(UUIDString: "ABCDEFGH-1234-ASDF-1234-ABC123DEF456GHI")
            wwPrint(device)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TableViewDemoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let peripheral = Array(peripherals)[safe: indexPath.row] else { fatalError() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
        cell.textLabel?.text = "\(peripheral.name ?? "NONE")"
        cell.detailTextLabel?.text = "\(peripheral.identifier)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let peripheral = Array(peripherals)[safe: indexPath.row] else { fatalError() }
        
        WWBluetoothManager.shared.connect(peripheral: peripheral)
        
        wwPrint(indexPath.row)
    }
}

// MARK: - WWBluetoothManagerDelegate
extension TableViewDemoController: WWBluetoothManagerDelegate {
    
    func updateState(_ state: CBManagerState) {
        
        switch state {
        case .poweredOn: wwPrint("藍牙已開啟，開始掃描設備")
        case .poweredOff: wwPrint("藍牙已關閉")
        case .resetting, .unauthorized, .unknown, .unsupported: wwPrint("其它")
        @unknown default: break
        }
    }
    
    func discoveredPeripherals(_ peripherals: Set<CBPeripheral>) {
        
        let peripherals = peripherals.compactMap { peripheral -> CBPeripheral? in
            guard peripheral.name != nil else { return nil }
            return peripheral
        }
        
        self.peripherals = peripherals
    }
    
    func discoverPeripheral(information: WWBluetoothManager.PeripheralInformation) {
        wwPrint("information => \(information)")
    }
    
    func didConnectPeripheral(result: Result<UUID, WWBluetoothManager.PeripheralError>) {
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let info): wwPrint(info)
        }
    }
    
    func didDiscoverDescriptors(result: Result<WWBluetoothManager.DiscoverDescriptors, WWBluetoothManager.PeripheralError>) {
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let info): wwPrint(info)
        }
    }
    
    func didDiscoverServices(result: Result<WWBluetoothManager.DiscoverServicesInformation, WWBluetoothManager.PeripheralError>) {
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let info): 
            
            wwPrint(info.services)
            
            if let services = info.services {
                for service in services {
                    print("發現服務: \(service.uuid)")

                    // 在這裡你可以檢索特徵
                    // peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func didDiscoverCharacteristics(result: Result<WWBluetoothManager.DiscoverCharacteristics, WWBluetoothManager.PeripheralError>) {
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let info): wwPrint(info.characteristics)
        }
    }
    
    func didUpdateNotificationState(result: Result<WWBluetoothManager.UpdateNotificationStateInformation, WWBluetoothManager.PeripheralError>) {
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let info): wwPrint(info.data)
        }
    }
    
    func didUpdateValue(result: Result<WWBluetoothManager.UpdateValueInformation, WWBluetoothManager.PeripheralError>) {
        
        switch result {
        case .failure(let error): wwPrint(error)
        case .success(let info): wwPrint(info.data)
        }
        
        // 在這裡你可以處理特徵的操作，例如訂閱通知
        // peripheral.setNotifyValue(true, for: characteristic)
    }
}
