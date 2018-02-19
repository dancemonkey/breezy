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
  @IBOutlet weak var tagLbl: TagLabel!
  @IBOutlet weak var tagView: UIView!
  @IBOutlet weak var tagViewBtmConstraint: NSLayoutConstraint!
  
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
      navigationController?.setToolbarHidden(true, animated: true)
    }
    
    guard let doc = document else {
      textView.text = ""
      tagLbl.text = "No tags"
      return
    }
    textView.text = doc.text
    
    if let tags = doc.getTagText() {
      tagLbl.text = tags
    } else {
      tagLbl.text = "No tags"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(DocumentVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(DocumentVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      tagViewBtmConstraint.constant -= keyboardSize.height
      print(tagViewBtmConstraint.constant)
      print(keyboardSize.height)
      print(keyboardSize)
//      self.view.frame.origin.y -= keyboardSize.height
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      tagViewBtmConstraint.constant += keyboardSize.height
//      self.view.frame.origin.y += keyboardSize.height
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
