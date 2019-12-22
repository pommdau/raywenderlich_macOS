//
//  WordCountViewController.swift
//  BabyScript
//
//  Created by Hiroki Ikeuchi on 2019/12/22.
//  Copyright © 2019 ikeh1024. All rights reserved.
//

import Cocoa

class WordCountViewController: NSViewController {
  
  @objc dynamic var wordCount = 0
  @objc dynamic var paragraphCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
  
  @IBAction func dismissWordCountWindow(_ sender: NSButton) {
    let application = NSApplication.shared
    application.stopModal()
  }
}
