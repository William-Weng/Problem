//
//  WWBluetoothManager.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//  ~/Library/Caches/org.swift.swiftpm/
/// [[iOS] Core Bluetooth 使用筆記](http://wisdomskyduan.blogspot.com/2013/06/ios-cb-class-note.html)
/// [如何開發iOS Swift BLE通訊 (QCA402X BLE應用) - 大大通(繁體站)](https://www.wpgdadatong.com/blog/detail/40547)

import UIKit
import CoreBluetooth
import WWPrint

public protocol WWBluetoothManagerDelegate {
    
    func updateState(_ state: CBManagerState)
    func discoveredPeripherals(_ peripherals: Set<CBPeripheral>)
    func discoverPeripheral(information: WWBluetoothManager.PeripheralInformation)
    func didConnectPeripheral(result: Result<UUID, WWBluetoothManager.PeripheralError>)
    func didDiscoverServices(result: Result<WWBluetoothManager.DiscoverServicesInformation, WWBluetoothManager.PeripheralError>)
    func didDiscoverCharacteristics(result: Result<WWBluetoothManager.DiscoverCharacteristics, WWBluetoothManager.PeripheralError>)
    func didDiscoverDescriptors(result: Result<WWBluetoothManager.DiscoverDescriptors, WWBluetoothManager.PeripheralError>)
    func didUpdateNotificationState(result: Result<WWBluetoothManager.UpdateNotificationStateInformation, WWBluetoothManager.PeripheralError>)
    func didUpdateValue(result: Result<WWBluetoothManager.UpdateValueInformation, WWBluetoothManager.PeripheralError>)
}

// descriptors

// MARK: - WWBluetoothManager
open class WWBluetoothManager: NSObject {
    
    public enum PeripheralError: Error {
        case connect(_ UUID: UUID, name: String?, error: Error)
        case discover(_ UUID: UUID, name: String?, error: Error)
        case update(_ UUID: UUID, name: String?, error: Error)
    }
    
    public typealias PeripheralInformation = (UUID: UUID, name: String?, advertisementData: [String : Any], RSSI: NSNumber)
    public typealias DiscoverServicesInformation = (UUID: UUID, name: String?, services: [CBService]?)
    public typealias DiscoverCharacteristics = (UUID: UUID, name: String?, characteristics: [CBCharacteristic]?)
    public typealias DiscoverDescriptors = (UUID: UUID, name: String?, descriptors: [CBDescriptor]?)
    public typealias UpdateNotificationStateInformation = (UUID: UUID, name: String?, data: Data?)
    public typealias UpdateValueInformation = (UUID: UUID, name: String?, data: Data?)

    public static let shared = WWBluetoothManager()

    private var peripherals: Set<CBPeripheral> = []
    private var centralManager: CBCentralManager!
    private var delegate: WWBluetoothManagerDelegate?
    
    private override init() {}
}

/// MARK: - 公開函式
public extension WWBluetoothManager {
    
    /// 開始掃瞄
    /// - Parameters:
    ///   - queue: DispatchQueue?
    ///   - delegate: WWBluetoothManagerDelegate?
    func startScan(queue: DispatchQueue? = nil, delegate: WWBluetoothManagerDelegate?) {
        self.delegate = delegate
        self.peripherals.removeAll()
        centralManager = CBCentralManager(delegate: self, queue: queue)
    }
    
    /// 停止掃瞄
    func stopScan() {
        centralManager.stopScan()
    }
    
    /// 連接藍牙設備
    /// - Parameters:
    ///   - peripheral: CBPeripheral
    ///   - options: [String : Any]?
    func connect(peripheral: CBPeripheral, options: [String : Any]? = nil) {
        centralManager.connect(peripheral, options: options)
    }
    
    /// 搜尋設備
    /// - Parameter UUIDString: String
    /// - Returns: CBPeripheral?
    func findPeripheral(UUIDString: String) -> CBPeripheral? {
        
        guard let UUID = UUID(uuidString: UUIDString) else { return nil }
        
        let peripheral = peripherals.first { $0.identifier == UUID }
        return peripheral
    }
}

// MARK: - WWBluetoothManager
extension WWBluetoothManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        delegate?.updateState(central.state)
        
        switch central.state {
        case .poweredOn: centralManager?.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff: break
        case .resetting: break
        case .unauthorized: break
        case .unsupported: break
        case .unknown: break
        @unknown default: break
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        let information: PeripheralInformation = (UUID: peripheral.identifier, name: peripheral.name, advertisementData: advertisementData, RSSI: RSSI)
        
        peripherals.insert(peripheral)
        delegate?.discoveredPeripherals(peripherals)
        delegate?.discoverPeripheral(information: information)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.didConnectPeripheral(result: .success(peripheral.identifier))
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error { delegate?.didConnectPeripheral(result: .failure(PeripheralError.connect(peripheral.identifier, name: peripheral.name, error: error))) }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error { delegate?.didConnectPeripheral(result: .failure(PeripheralError.connect(peripheral.identifier, name: peripheral.name, error: error))) }
    }
}

// MARK: - WWBluetoothManager
extension WWBluetoothManager: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error { delegate?.didDiscoverServices(result: .failure(PeripheralError.discover(peripheral.identifier, name: peripheral.name, error: error))); return }
        delegate?.didDiscoverServices(result: .success((UUID: peripheral.identifier, name: peripheral.name, services: peripheral.services)))
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error { delegate?.didDiscoverCharacteristics(result: .failure(PeripheralError.discover(peripheral.identifier, name: peripheral.name, error: error))); return }
        delegate?.didDiscoverCharacteristics(result: .success((UUID: peripheral.identifier, name: peripheral.name, characteristics: service.characteristics)))
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error { delegate?.didDiscoverDescriptors(result: .failure(PeripheralError.discover(peripheral.identifier, name: peripheral.name, error: error))); return }
        delegate?.didDiscoverDescriptors(result: .success((UUID: peripheral.identifier, name: peripheral.name, descriptors: characteristic.descriptors)))
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error { delegate?.didUpdateValue(result: .failure(PeripheralError.update(peripheral.identifier, name: peripheral.name, error: error))); return }
        delegate?.didUpdateValue(result: .success((UUID: peripheral.identifier, name: peripheral.name, data: characteristic.value)))
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error { delegate?.didUpdateNotificationState(result: .failure(PeripheralError.update(peripheral.identifier, name: peripheral.name, error: error))); return }
        delegate?.didUpdateNotificationState(result: .success((UUID: peripheral.identifier, name: peripheral.name, data: characteristic.value)))
    }
}

