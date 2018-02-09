//
//  DocumentVC.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DocumentVC: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  var document: Document?
    
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let doc = document else {
      textView.text = ""
      self.title = "New Document"
      return
    }
    textView.text = doc.text
    self.title = doc.title
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
