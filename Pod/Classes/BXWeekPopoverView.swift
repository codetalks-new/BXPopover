//
//  BXWeekPopoverView.swift
//  Youjia
//
//  Created by Haizhen Lee on 15/12/19.
//  Copyright © 2015年 xiyili. All rights reserved.
//

import UIKit
import BXModel
import PinAutoLayout

// -BXWeekPopoverView(adapter=t):v
// _[e7]:t
// background[e0]:i


public class BXPopoverView<T:BXBasicItemAware> : UIView{
  public let backgroundImageView = UIImageView(frame:CGRectZero)
  public let tableView = UITableView(frame:CGRectZero)
  public var dimBackground = true
  public var didSelectItem :(T -> Void)?
  
  lazy var adapter:SimpleTableViewAdapter<T> = { [unowned self] in
    return SimpleTableViewAdapter(tableView: self.tableView,cellStyle:.Default)
    }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  public convenience init(size:CGSize){
    self.init(frame:CGRect(origin: CGPointZero, size: size))
  }
  
  public convenience init() {
    self.init(frame:CGRect(x: 0, y: 0, width: 120, height: 320))
  }
  
  public func bind<S:SequenceType where S.Generator.Element == T>(item:S){
    adapter.updateItems(item)
    adapter.didSelectedItem = {
      item,index in
      self.dismiss()
      self.didSelectItem?(item)
    }
  }
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  var allOutlets :[UIView]{
    return [backgroundImageView,tableView]
  }
  var allUIImageViewOutlets :[UIImageView]{
    return [backgroundImageView]
  }
  var allUITableViewOutlets :[UITableView]{
    return [tableView]
  }
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func commonInit(){
    for childView in allOutlets{
      addSubview(childView)
      childView.translatesAutoresizingMaskIntoConstraints = false
    }
    installConstaints()
    setupAttrs()
    
    adapter.configureCellBlock = {
      cell,index in
      cell.removeLayoutMargins()
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.backgroundColor = .clearColor()
      cell.textLabel?.backgroundColor = .clearColor()
      let selectedView = UIView()
      selectedView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
      cell.selectedBackgroundView = selectedView
      
    }
  }
  
  func installConstaints(){
    tableView.pinEdge(UIEdgeInsets(top: 13, left: 3, bottom: 8, right: 3))
    backgroundImageView.pinEdge(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    
  }
  
  public func selectRow(row:Int){
    tableView.selectRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), animated: true, scrollPosition: .Middle)
  }
  
  public func dismiss(){
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.alpha = 0.0
      self.dimmingView?.alpha = 0.0
      }) { (finished) -> Void in
        self.hidden = true
        self.removeFromSuperview()
        self.dimmingView?.removeFromSuperview()
    }
  }
  
  public func showAsDropDown(anchor:UIView,xoff:CGFloat = 0,yoff:CGFloat=0){
    guard let window = UIApplication.sharedApplication().keyWindow else {
      return
    }
    let anchorPoint = CGPoint(x: anchor.bounds.midX, y: anchor.bounds.maxY)
    var windowAnchorPoint = anchor.convertPoint(anchorPoint, toView: window)
    windowAnchorPoint.x += xoff
    windowAnchorPoint.y += yoff
   
    var newFrame = frame
    newFrame.origin.y = windowAnchorPoint.y
    newFrame.origin.x = windowAnchorPoint.x - (newFrame.width * 0.5)
    frame = newFrame.offsetBy(dx: 0, dy: -20)
    self.alpha = 0.0
    
    if dimBackground{
      let dimmingView = UIView()
      dimmingView.frame = window.bounds
      dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
      dimmingView.alpha = 0.0
      window.addSubview(dimmingView)
      self.dimmingView = dimmingView
      dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismiss"))
    }
    
    window.addSubview(self)
    backgroundColor = nil
    tableView.backgroundColor = .clearColor()
    tableView.separatorColor = UIColor(white: 0.1, alpha: 1.0)
    hidden = false
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.frame = newFrame
      self.alpha = 1.0
      self.dimmingView?.alpha = 1.0
    }) { (finished) -> Void in
      if let indexPath = self.tableView.indexPathForSelectedRow{
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
      }
      
    }
    
  }
  
  private var dimmingView:UIView?
  
  func setupAttrs(){
    hidden = true
    backgroundColor = .clearColor()
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    tableView.backgroundColor = nil // .clearColor()
    backgroundImageView.image = bundleImage("popover_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) )
  }
}
extension UITableViewCell{
  func removeSeperatorInset(){
    separatorInset = UIEdgeInsetsZero
    removeLayoutMargins()
  }
  
  func removeLayoutMargins(){
      preservesSuperviewLayoutMargins = false
      layoutMargins = UIEdgeInsetsZero
  }
}

class Stub{
  
}

func bundleImage(name:String) -> UIImage?{
  let bundleOfThis = NSBundle(forClass: Stub.self)
  
  guard let bundleURL = bundleOfThis.URLForResource("BXPopover", withExtension: "bundle") else{
    NSLog("Resources bundle not found")
    return nil
  }
  
  guard let bundle = NSBundle(URL: bundleURL) else{
    NSLog("Could not load Resources Bundle \(bundleURL)")
    return nil
  }
  if let imagePath = bundle.pathForResource(name+"@2x", ofType: "png"){
   return UIImage(contentsOfFile: imagePath)
  }
  return nil
}
