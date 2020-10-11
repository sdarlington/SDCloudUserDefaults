//
//  ViewController.swift
//  SDCloudUserDefaults_Swift
//
//  Created by Peter Easdown on 10/10/20.
//  Copyright © 2020 Wandle Software Limited. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var keyNameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: Notification.Name.SDCloudValueUpdatedNotification, object: nil, queue: nil) { (notification) in
            notification.userInfo?.keys.forEach({ (key) in
                if (key as! String) == self.keyNameTextField.text {
                    self.valueTextField.text = (notification.userInfo![key as! String] as! String)
                }
            })
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.keyNameTextField {
            self.valueTextField.text = SDCloudUserDefaults.shared.string(forKey: textField.text!)
        } else if (textField == self.valueTextField) {
            SDCloudUserDefaults.shared.set(textField.text!, forKey: self.keyNameTextField.text!)
        }
    }

    @IBAction func switchChanged(_ sender: Any) {
        SDCloudUserDefaults.shared.setiCloud(enabled: self.enabledSwitch.isOn)
    }
}

