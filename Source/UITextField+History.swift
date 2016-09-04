//
//  UITextField+History.swift
//  Example
//
//  Created by zhangxiuming on 15/12/18.
//  Copyright © 2015年 morenotepad. All rights reserved.
//

import Foundation
import UIKit

//extension UITextFieldDelegate {
//    func textField(textField: UITextField, selectHistory history:String) {
//    }
//}

public extension UITextField {
    var showHistoryBeginEdit:Bool {
        get {
            if let yes = objc_getAssociatedObject(self, &AssociatedKeys.ShowHistoryBeginEditKey) {
                return (yes as! NSNumber).boolValue
            }
            
            return false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ShowHistoryBeginEditKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dismissHistoryEndEdit:Bool {
        get {
            if let yes = objc_getAssociatedObject(self, &AssociatedKeys.DismissHistoryEndEditKey) {
                return (yes as! NSNumber).boolValue
            }
            
            return false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.DismissHistoryEndEditKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var identify:String! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IdentifyKey) as? String
        }
        
        set {
            if self.identify == nil {
                self.addNotification()
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.IdentifyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var clearButtonTitle:String! {
        get {
            if let title = objc_getAssociatedObject(self, &AssociatedKeys.ClearButtonTitleKey) {
                return title as! String
            }
            
            return "Clear All History"
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ClearButtonTitleKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var itemHeight:Float {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedKeys.ItemCellHeightKey) {
                return (h as! NSNumber).floatValue
            }
            
            return 43.7
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ItemCellHeightKey, NSNumber(float: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var maximumItem:NSInteger {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedKeys.MaximumItemKey) {
                return (h as! NSNumber).integerValue
            }
            
            return 8
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.MaximumItemKey, NSNumber(integer: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var maximumSavedEntries:NSInteger {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedKeys.MaximumSavedEntriesKey) {
                return (h as! NSNumber).integerValue
            }

            return 0
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.MaximumSavedEntriesKey, NSNumber(integer: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func dismissHistoryView() {
        self.historyIsVisible = false;
        self.tableView.removeFromSuperview()
    }
    
    func showHistoryView() {
        if self.historys.count != 0 {
            self.historyIsVisible = true;
            let selfOriginFrame = self.convertRect(self.bounds, toView: nil)
            var tableViewFrame = selfOriginFrame.offsetBy(dx: 0, dy: CGRectGetHeight(self.bounds) + 2)
            tableViewFrame.size.height = CGFloat(self.itemHeight) * CGFloat(min(8, self.historys.count+1))

            self.tableView.frame = tableViewFrame

            let window = UIApplication.sharedApplication().delegate?.window

            window??.addSubview(self.tableView)
            self.tableView.reloadData()

            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITextField.handleTextFieldTap(_:)))
            self.addGestureRecognizer(tapRecognizer)
        }
    }

    var tableView:UITableView! {
        get {
            if let t = objc_getAssociatedObject(self, &AssociatedKeys.TableViewKey) {
                return t as! UITableView
            }
            
            let t = UITableView(frame: CGRectZero, style: .Plain)
            t.delegate   = self
            t.dataSource = self
            t.tableFooterView = UIView()
            t.tableHeaderView = UIView()
            t.layer.cornerRadius = 4
            t.layer.borderColor = UIColor.grayColor().CGColor
            t.layer.borderWidth = 1
            
            objc_setAssociatedObject(self, &AssociatedKeys.TableViewKey, t, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return t
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.TableViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    var historyIsVisible:Bool {
        get {
            if let yes = objc_getAssociatedObject(self, &AssociatedKeys.HistoryIsVisibleKey) {
                return (yes as! NSNumber).boolValue
            }

            return false
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.HistoryIsVisibleKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextField.beginEditingNotification(_:)), name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextField.endEditingNotification(_:)), name: UITextFieldTextDidEndEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextField.textDidChangeNotification(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextField.orientationdidChangeNotification(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidEndEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }

    func handleTextFieldTap(recognizer: UITapGestureRecognizer) {
        if self.historyIsVisible {
            self.dismissHistoryView()
        } else {
            if self.filterHistory != nil && self.filterHistory.count > 0 {
                self.showHistoryView()
            }
        }
    }

    func beginEditingNotification(aNoti:NSNotification) {
        if aNoti.object === self {
            if self.historys.count == 0 { return }
            self.filterHistory = self.historys
            
            if self.showHistoryBeginEdit {
                self.showHistoryView()
            }
        }
    }
    
    func endEditingNotification(aNoti:NSNotification) {
        if aNoti.object === self {
            if self.dismissHistoryEndEdit {
                self.dismissHistoryView()
            }
        }
    }
    
    func textDidChangeNotification(aNoti:NSNotification) {
        if aNoti.object === self {
            if let t = self.text where !t.isEmpty {
                let predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", t)
                self.filterHistory = self.historys.filteredArrayUsingPredicate(predicate)
                if self.filterHistory.count == 0 {
                    if self.historyIsVisible {
                        self.dismissHistoryView()
                    }
                }
                else {
                    self.showHistoryView()
                }
            } else {
                self.filterHistory = self.historys
                if !self.historyIsVisible {
                    self.showHistoryView()
                }
            }

            self.tableView.reloadData()
        }
    }

    func orientationdidChangeNotification(aNoti:NSNotification) {
        if self.historyIsVisible {
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.showHistoryView()
            })
        }
    }
}

public extension UITextField {
    private struct AssociatedKeys {
        static var HistoryKey               = "UITextField+History+HistoryKey"
        static var HistoryIsVisibleKey      = "UITextField+History+HistoryIsVisibleKey"
        static var IdentifyKey              = "UITextField+History+Identify"
        static var TableViewKey             = "UITextField+History+TableView"
        static var ItemCellHeightKey        = "UITextField+History+ItemCellHeight"
        static var MaximumItemKey           = "UITextField+History+MaximumItem"
        static var MaximumSavedEntriesKey   = "UITextField+History+MaximumSavedEntries"
        static var FilterArrayKey           = "UITextField+History+FilterArray"
        static var ClearButtonTitleKey      = "UITextField+History+ClearButtonTitle"
        static var ShowHistoryBeginEditKey  = "UITextField+History+ShowHistoryBeginEdit"
        static var DismissHistoryEndEditKey = "UITextField+History+DismissHistoryEndEdit"
    }
    
    private var filterHistory:NSArray! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.FilterArrayKey) as? NSArray
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.FilterArrayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var historys:NSMutableArray {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedKeys.HistoryKey) {
                return h as! NSMutableArray
            }
            
            let h = self.load()
            objc_setAssociatedObject(self, &AssociatedKeys.HistoryKey, h, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return h
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.HistoryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func synchronize() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.historys, forKey: self.identify)
        return userDefaults.synchronize()
    }
    
    private func load() -> NSMutableArray {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let obj = userDefaults.objectForKey(self.identify)
        if obj == nil {
            return NSMutableArray()
        }
        
        return NSMutableArray(array: obj as! NSArray)
    }

    func addHistory() {
        guard let value = self.text else { return }
        
        if value.isEmpty { return }
        
        let index = self.historys.indexOfObject(value)
        
        if index != NSNotFound {
            historys.removeObject(value)
        }
        
        historys.insertObject(value, atIndex: 0)

        if self.maximumSavedEntries != 0 {
            if historys.count > self.maximumSavedEntries {
                historys.removeLastObject()
            }
        }

        self.synchronize()
    }
    
    func clearAllHistory() {
        self.historys.removeAllObjects()
        self.filterHistory = self.historys
        self.synchronize()
        
        self.tableView.removeFromSuperview()
    }
}


extension UITextField:UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.filterHistory { } else { self.filterHistory = self.historys }
        
        return self.filterHistory.count
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UITextFiled+History+Cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "UITextFiled+History+Cell")
            cell?.selectionStyle = .None
        }
        
        cell?.textLabel?.text = self.filterHistory.objectAtIndex(indexPath.row) as? String
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(self.itemHeight)
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIButton(type: .RoundedRect)
        footer.setTitle(self.clearButtonTitle, forState: .Normal)
        footer.addTarget(self, action: #selector(UITextField.clearAllHistory), forControlEvents: .TouchUpInside)
        
        return footer
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let t = self.text where !t.isEmpty {
            return 0
        }
        
        return CGFloat(self.itemHeight)
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let history = self.filterHistory[indexPath.row] as! String
        
        if let dlg = self.delegate where dlg.respondsToSelector("textField:selectHistory:") {
            dlg.performSelector("textField:selectHistory:", withObject: self, withObject: history)
        }
        
        self.tableView.removeFromSuperview()
        self.resignFirstResponder()
    }
}
