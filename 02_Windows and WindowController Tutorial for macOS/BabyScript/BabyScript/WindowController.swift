//
//  WindowController.swift
//  BabyScript
//
//  Created by Hiroki Ikeuchi on 2019/12/22.
//  Copyright © 2019 ikeh1024. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    shouldCascadeWindows = true
  }
}
