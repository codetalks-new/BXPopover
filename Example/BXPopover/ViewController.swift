//
//  ViewController.swift
//  BXPopover
//
//  Created by banxi1988 on 12/19/2015.
//  Copyright (c) 2015 banxi1988. All rights reserved.
//

import UIKit
import BXPopover
import BXModel

struct WeekItem{
  let week:Int
  init(week:Int){
    self.week = week
  }
  
  var title:String{
    return "第\(week)周"
  }
}

extension WeekItem:BXBasicItemAware{
  var bx_text:String{ return title}
  var bx_detailText:String{ return "" }
}

class ViewController: UIViewController {

    lazy var weekButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("周次", forState: .Normal)
        button.addTarget(self, action: "toggleWeekPopover:", forControlEvents: .TouchUpInside)
        return button
    }()
  
  let popover = BXPopoverView<WeekItem>(size:CGSize(width: 120, height: 300))
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationItem.titleView = weekButton
      weekButton.sizeToFit()
//      weekButton.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view, typically from a nib.
      let weekItems = (1...20).map{ WeekItem(week: $0)}
      popover.bind(weekItems)
    }
  
  var currentWeek = 3
  func toggleWeekPopover(sender:AnyObject){
    if popover.hidden{
      popover.selectRow(currentWeek)
      popover.showAsDropDown(weekButton)
    }else{
      popover.dismiss()
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

