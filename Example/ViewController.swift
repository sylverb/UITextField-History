//
//  ViewController.swift
//  Example
//
//  Created by DamonDing on 15/12/18.
//  Copyright © 2015年 morenotepad. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var textField1: UITextField!
    @IBOutlet var textField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField1.identify = "ViewController:textField1"
        textField1.clearButtonTitle = "清除所有历史"
        textField1.showHistoryBeginEdit = true
        textField1.dismissHistoryEndEdit = true
        textField1.delegate = self
        
        textField2.identify = "ViewController:textField2"
        textField2.clearButtonTitle = "清除历史"
        textField2.showHistoryBeginEdit = true
        textField2.delegate = self
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        textField2.addHistory()
        textField2.resignFirstResponder()
        textField2.dismissHistoryView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.textField1.dismissHistoryView()
        self.textField2.dismissHistoryView()
    }
}

extension ViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        if textField === textField1 {
            textField1.addHistory()
        }
    }
    
    func textField(textField: UITextField, selectHistroy history:String) {
        let alert = UIAlertView(title: "Hello", message: history, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
}

class ViewController2: UIViewController {
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.identify = "ViewController2:textField"
        textField.showHistoryBeginEdit = true
        textField.dismissHistoryEndEdit = true
    }
}
