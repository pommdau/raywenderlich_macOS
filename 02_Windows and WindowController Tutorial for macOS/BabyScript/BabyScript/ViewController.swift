//
//  ViewController.swift
//  BabyScript
//
//  Created by Hiroki Ikeuchi on 2019/12/22.
//  Copyright © 2019 ikeh1024. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  @IBOutlet var text: NSTextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    text.toggleRuler(nil)
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

