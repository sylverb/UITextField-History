//
//  UITextField+Histroy.swift
//  Example
//
//  Created by zhangxiuming on 15/12/18.
//  Copyright © 2015年 morenotepad. All rights reserved.
//

import Foundation
import UIKit

//extension UITextFieldDelegate {
//    func textField(textField: UITextField, selectHistroy history:String) {
//    }
//}

extension UITextField {
    var showHistoryBeginEdit:Bool {
        get {
            if let yes = objc_getAssociatedObject(self, &AssociatedKeys.showHistoryBeginEditKey) {
                return (yes as! NSNumber).boolValue
            }
            
            return false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.showHistoryBeginEditKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var dismissHistoryEndEdit:Bool {
        get {
            if let yes = objc_getAssociatedObject(self, &AssociatedKeys.dismissHistoryEndEditKey) {
                return (yes as! NSNumber).boolValue
            }
            
            return false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dismissHistoryEndEditKey, NSNumber(bool: newValue), .OBJC_ASSOCIATION_RETAIN)
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
            if let title = objc_getAssociatedObject(self, &AssociatedKeys.clearButtonTitleKey) {
                return title as! String
            }
            
            return "Clear All History"
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.clearButtonTitleKey, newValue, .OBJC_ASSOCIATION_RETAIN)
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

    func dismissHistoryView() {
        self.tableView.removeFromSuperview()
    }
    
    func showHistoryView() {
        let selfOriginFrame = self.convertRect(self.bounds, toView: nil)
        var tableViewFrame = selfOriginFrame.offsetBy(dx: 0, dy: CGRectGetHeight(self.bounds) + 2)
        tableViewFrame.size.height = CGFloat(self.itemHeight) * CGFloat(min(8, self.historys.count+1))
        
        self.tableView.frame = tableViewFrame
        
        let window = UIApplication.sharedApplication().delegate?.window
        
        window??.addSubview(self.tableView)
        self.tableView.reloadData()
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

    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beginEditingNotification:", name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endEditingNotification:", name: UITextFieldTextDidEndEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidEndEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    func beginEditingNotification(aNoti:NSNotification) {
        if aNoti.object === self {
            if self.historys.count == 0 { return }
            self.filterHistroy = self.historys
            
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
                self.filterHistroy = self.historys.filteredArrayUsingPredicate(predicate)
            } else {
                self.filterHistroy = self.historys
            }

            self.tableView.reloadData()
        }
    }
}

extension UITextField {
    private struct AssociatedKeys {
        static var HistoryKey            = "UITextField+historyKey"
        static var IdentifyKey           = "UITextField+History+Identify"
        static var TableViewKey          = "UITextField+History+TableView"
        static var ItemCellHeightKey     = "UITextField+History+ItemCellHeight"
        static var MaximumItemKey        = "UITextField+History+MaximumItem"
        static var filterArrayKey        = "UITextField+History+filterArray"
        static var clearButtonTitleKey   = "UITextField+History+clearButtonTitle"
        static var showHistoryBeginEditKey  = "UITextField+History+showHistoryBeginEdit"
        static var dismissHistoryEndEditKey = "UITextField+History+dismissHistoryEndEdit"
    }
    
    private var filterHistroy:NSArray! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.filterArrayKey) as? NSArray
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.filterArrayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
        self.synchronize()
    }
    
    func clearAllHistory() {
        self.historys.removeAllObjects()
        self.filterHistroy = self.historys
        self.synchronize()
        
        self.tableView.removeFromSuperview()
    }
}


extension UITextField:UITableViewDelegate, UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.filterHistroy { } else { self.filterHistroy = self.historys }
        
        return self.filterHistroy.count
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
        
        cell?.textLabel?.text = self.filterHistroy.objectAtIndex(indexPath.row) as? String
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(self.itemHeight)
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIButton(type: .RoundedRect)
        footer.setTitle(self.clearButtonTitle, forState: .Normal)
        footer.addTarget(self, action: "clearAllHistory", forControlEvents: .TouchUpInside)
        
        return footer
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let t = self.text where !t.isEmpty {
            return 0
        }
        
        return CGFloat(self.itemHeight)
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let history = self.historys[indexPath.row] as! String
        
        if let dlg = self.delegate where dlg.respondsToSelector("textField:selectHistroy:") {
            dlg.performSelector("textField:selectHistroy:", withObject: self, withObject: history)
        }
        
        self.tableView.removeFromSuperview()
        self.resignFirstResponder()
    }
}
