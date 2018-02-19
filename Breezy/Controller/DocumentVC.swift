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
  @IBOutlet weak var tagView: TagShareView!
  @IBOutlet weak var tagViewBtmConstraint: NSLayoutConstraint!
  @IBOutlet weak var shareBtn: UIBarButtonItem!
  
  var context: NSManagedObjectContext!
  var document: Document?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    defer {
      let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
      self.navigationItem.rightBarButtonItem = doneBtn
      self.title = ""
      navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    guard let doc = document else {
      textView.text = ""
      textView.becomeFirstResponder()
      return
    }
    textView.text = doc.text
    tagView.configure(with: doc)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(DocumentVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(DocumentVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      tagViewBtmConstraint.constant += keyboardSize.height - (navigationController?.toolbar.frame.height)!
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      tagViewBtmConstraint.constant -= keyboardSize.height + (navigationController?.toolbar.frame.height)!
    }
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
