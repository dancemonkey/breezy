//
//  DocumentVC.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DocumentVC: UIViewController, TouchDelegate {
  
  @IBOutlet weak var textView: DocumentTextView!
  @IBOutlet weak var tagView: TagShareView!
  @IBOutlet weak var tagViewBtmConstraint: NSLayoutConstraint!
  @IBOutlet weak var shareBtn: UIBarButtonItem!
  @IBOutlet weak var titleFld: UITextField!
  
  var context: NSManagedObjectContext!
  var document: Document?
  var tags: [Tag]?
  
  // MARK: Initializing
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    defer {
      let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
      self.navigationItem.rightBarButtonItem = doneBtn
      tagView.touchDelegate = self
    }
    
    guard let doc = document else {
      textView.text = ""
      titleFld.text = ""
      titleFld.becomeFirstResponder()
      return
    }
    textView.text = doc.text
    titleFld.text = doc.title!
    tagView.configure(with: doc)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dismissKeyboard = UINib(nibName: "DismissKeyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DismissKeyboardView
    dismissKeyboard.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
    dismissKeyboard.action = { self.dismissKeyboard() }
    textView.inputAccessoryView = dismissKeyboard
    titleFld.inputAccessoryView = dismissKeyboard
    
//    NotificationCenter.default.addObserver(self, selector: #selector(DocumentVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(DocumentVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
//    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
  }
  
  // MARK: Keyboard show/hide
  
  func dismissKeyboard() {
    if textView.isFirstResponder {
      textView.resignFirstResponder()
    } else {
      titleFld.resignFirstResponder()
    }
  }
//  @objc func keyboardWillShow(notification: NSNotification) {
//    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//      tagViewBtmConstraint.constant += keyboardSize.height - 44
//      //- (navigationController?.toolbar.frame.height)! THIS WAS CRASHING
//    }
//  }
//
//  @objc func keyboardWillHide(notification: NSNotification) {
//    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//      tagViewBtmConstraint.constant -= keyboardSize.height + 44
//      //+ (navigationController?.toolbar.frame.height)! THIS WAS CRASHING
//    }
//  }
  
  // MARK: Done
  
  @objc func done() {
    defer {
      navigationController?.popViewController(animated: true)
    }
    
    guard let doc = document else {
      let newDoc = Document(context: context)
      newDoc.setText(to: textView.text, withTitle: titleFld.text!)
//      let tempTag = Tag(context: context)
//      tempTag.name = "TempTag"
//      newDoc.addToTags(tempTag)
//      tempTag.addToDocuments(newDoc)
      newDoc.creation = Date() as NSDate
      newDoc.lastUpdated = Date() as NSDate
      do {
        try context.save()
      } catch {
        print("oops document saving didn't work!")
      }
      return
    }
    doc.setText(to: textView.text, withTitle: titleFld.text!)
    doc.lastUpdated = Date() as NSDate
    do {
      try context.save()
    } catch {
      print("oops document saving didn't work!")
    }
  }
  
  // MARK: Touch Delegate
  
  func handleTouch() {
    performSegue(withIdentifier: "showTagSelect", sender: self)
  }
  
  // MARK: Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTagSelect" {
      let destVC = segue.destination as! TagSelectVC
      destVC.document = self.document
      destVC.context = self.context
    }
  }
  
}
