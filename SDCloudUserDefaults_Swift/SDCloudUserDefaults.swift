//
//  SDCloudUserDefaults.swift
//  Tap Times Tables Swift
//
//  Created by Peter Easdown on 9/10/20.
//

import Foundation

extension Notification.Name {

    static let SDCloudValueUpdatedNotification = Notification.Name(rawValue: "com.wandlesoftware.SDCloudUserDefaults.KeyValueUpdated")

}

class SDCloudUserDefaults {

    static let ICLOUD_DATA_ENABLED_KEY = "iCloudDataEnabled"
    
    static let shared = SDCloudUserDefaults()

    private var userDefaults : UserDefaults? = nil

    func setiCloud(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: SDCloudUserDefaults.ICLOUD_DATA_ENABLED_KEY)
    
        if enabled {
            self.registerForNotifications()
        } else {
            self.removeNotifications()
        }
    }

    func hasiCloudBeenInitialized() -> Bool {
        return UserDefaults.standard.object(forKey: SDCloudUserDefaults.ICLOUD_DATA_ENABLED_KEY) != nil
    }

    func isiCloudEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: SDCloudUserDefaults.ICLOUD_DATA_ENABLED_KEY)
    }

    init() {
        if self.hasiCloudBeenInitialized() {
            if self.isiCloudEnabled() {
                self.registerForNotifications()
            } else {
                self.removeNotifications()
            }
        }
    }
    
    func standardUserDefaults() -> UserDefaults {
        if self.userDefaults == nil {
            self.userDefaults = UserDefaults.standard
        }
        
        return self.userDefaults!
    }

    func string(forKey aKey: String) -> String? {
        if let obj = self.object(forKey: aKey) {
            if obj is String {
                return obj as? String
            }
        }
        
        return nil
    }
    
    func bool(forKey aKey: String) -> Bool {
        if let obj = self.object(forKey: aKey) {
            if obj is Bool {
                return obj as! Bool
            }
        }
        
        return false
    }
    
    func object(forKey aKey: String) -> Any? {
        if self.isiCloudEnabled() {
            if let obj = NSUbiquitousKeyValueStore.default.object(forKey: aKey) {
                return obj
            } else {
                if let obj = self.standardUserDefaults().object(forKey: aKey) {
                    NSUbiquitousKeyValueStore.default.set(obj, forKey: aKey)
                    
                    return obj
                } else {
                    return nil
                }
            }
        } else {
            return self.standardUserDefaults().object(forKey: aKey)
        }
    }

    func array(forKey aKey: String) -> Array<Any>? {
        if let obj = self.object(forKey: aKey) {
            if obj is Array<Any> {
                return obj as? Array<Any>
            }
        }
        
        return nil
    }

    func data(forKey aKey: String) -> Data? {
        if let obj = self.object(forKey: aKey) {
            if obj is Data {
                return obj as? Data
            }
        }
        
        return nil
    }

    func integer(forKey aKey: String) -> Int {
        if let obj = self.object(forKey: aKey) {
            if obj is Int {
                return obj as! Int
            }
        }
        
        return 0
    }

    func float(forKey aKey: String) -> Float {
        if let obj = self.object(forKey: aKey) {
            if obj is Float {
                return obj as! Float
            }
        }
        
        return 0.0
    }

    func double(forKey aKey: String) -> Double {
        if let obj = self.object(forKey: aKey) {
            if obj is Double {
                return obj as! Double
            }
        }
        
        return 0.0
    }

    func set(string aString: String, forKey aKey: String) {
        self.set(aString, forKey:aKey)
    }

    func set(_ aBool: Bool, forKey aKey: String) {
        self.set(NSNumber(booleanLiteral: aBool), forKey: aKey)
    }

    func set(_ object: Any, forKey aKey: String) {
        if self.isiCloudEnabled() {
            NSUbiquitousKeyValueStore.default.set(object, forKey: aKey)
        }

        self.userDefaults?.set(object, forKey: aKey)
    }

    func set(_ integer: Int, forKey aKey: String) {
        self.set(NSNumber(integerLiteral: integer), forKey: aKey)
    }

    func set(_ float: Float, forKey aKey: String) {
        self.set(NSNumber(floatLiteral: Double(float)), forKey: aKey)
    }

    func set(_ double: Double, forKey aKey: String) {
        self.set(NSNumber(floatLiteral: double), forKey: aKey)
    }

    func removeObject(forKey aKey: String) {
        if self.isiCloudEnabled() {
            NSUbiquitousKeyValueStore.default.removeObject(forKey: aKey)
        }
        
        self.userDefaults?.removeObject(forKey: aKey)
    }

    func synchronize() {
        if self.isiCloudEnabled() {
            NSUbiquitousKeyValueStore.default.synchronize()
        }
        
        self.userDefaults?.synchronize()
    }
    
    var notificationObserver : NSObjectProtocol? = nil

    func registerForNotifications() {
        if self.notificationObserver != nil {
            return
        }
        
        self.notificationObserver = NotificationCenter.default.addObserver(forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default, queue: nil, using: { (notification) in
            if let userInfo = notification.userInfo {
                if let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] {
                    let reason = (reasonForChange as! NSNumber).intValue
                    
                    // Update only for changes from the server.
                    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
                            (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
                        
                        let changedKeys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as! Array<String>
                        let cloud = NSUbiquitousKeyValueStore.default
                        let defaults = self.userDefaults
                        
                        changedKeys.forEach { (key) in
                            if let obj = cloud.object(forKey: key) {
                                defaults?.setValue(obj, forKey: key)
                                NotificationCenter.default.post(name: .SDCloudValueUpdatedNotification, object: self, userInfo: [key: obj])
                            }
                        }
                    }
                }
            }
        })
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self.notificationObserver!)
        self.notificationObserver = nil
    }
}
