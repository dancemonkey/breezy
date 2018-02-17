//
//  DocumentVC.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DocumentVC: UIViewController {
  
  @IBOutlet weak var textView: DocumentTextView!
  var context: NSManagedObjectContext!
  var document: Document?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    defer {
      let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
      self.navigationItem.rightBarButtonItem = doneBtn
      textView.becomeFirstResponder()
      self.title = ""
      navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    guard let doc = document else {
      textView.text = ""
      self.title = ""
      return
    }
    textView.text = doc.text
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @objc func done() {
    defer {
      navigationController?.popViewController(animated: true)
    }
    
    guard let doc = document else {
      let newDoc = Document(context: context)
      newDoc.text = textView.text
      let tempTag = Tag(context: context)
      tempTag.name = "TempTag"
      newDoc.addToTags(tempTag)
      tempTag.addToDocuments(newDoc)
      newDoc.creation = Date() as NSDate
      newDoc.lastUpdated = Date() as NSDate
      do {
        try context.save()
      } catch {
        print("oops document saving didn't work!")
      }
      return
    }
    doc.text = textView.text
    doc.lastUpdated = Date() as NSDate
    // TODO: also need to update tags if any new tags have been selected
    // TODO: handle that after tag selection screen? flag 'tag selected' and handle here?
    do {
      try context.save()
    } catch {
      print("oops document saving didn't work!")
    }
    
  }
  
}
