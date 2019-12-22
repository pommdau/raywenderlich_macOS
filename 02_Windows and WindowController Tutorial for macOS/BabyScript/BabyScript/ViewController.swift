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

  @IBAction func showWordCountWindow(_ sender: AnyObject) {
    // 1
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let wordCountWindowController = storyboard.instantiateController(withIdentifier: "Word Count Window Controller") as! NSWindowController
    
    if let wordCountWindow = wordCountWindowController.window, let textStorage = text.textStorage {
      
      // 2
      let wordCountViewController = wordCountWindow.contentViewController as! WordCountViewController
      wordCountViewController.wordCount = textStorage.words.count
      wordCountViewController.paragraphCount = textStorage.paragraphs.count
      
      // 3
      let application = NSApplication.shared
      application.runModal(for: wordCountWindow)
      // 4
      wordCountWindow.close()
    }
  }

}

