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
    //1.
    if let window = window, let screen = window.screen {
      let offsetFromLeftOfScreen: CGFloat = 100
      let offsetFromTopOfScreen: CGFloat = 100
      //2.
      let screenRect = screen.visibleFrame
      //3.
      print("\(screenRect.maxY) - \(window.frame.height) - \(offsetFromTopOfScreen)")
      let newOriginY = screenRect.maxY - window.frame.height - offsetFromTopOfScreen
      print("\(newOriginY)")
      //4.
      window.setFrameOrigin(NSPoint(x: offsetFromLeftOfScreen, y: newOriginY))
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    shouldCascadeWindows = true
  }
}
