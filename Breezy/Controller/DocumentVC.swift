//
//  DocumentVC.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DocumentVC: UIViewController, TouchDelegate, TagSelectDelegate, UITextViewDelegate {
  
  @IBOutlet weak var textView: DocumentTextView!
  @IBOutlet weak var tagView: TagShareView!
  @IBOutlet weak var tagViewBtmConstraint: NSLayoutConstraint!
  @IBOutlet weak var shareBtn: UIBarButtonItem!
  @IBOutlet weak var titleFld: UITextField!
  @IBOutlet weak var countLbl: CountLbl!
  
  var context: NSManagedObjectContext!
  var document: Document?
  var tags: [Tag]? = nil
  var accessory: DismissKeyboardView?
  
  // MARK: Initializing
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
    self.navigationItem.rightBarButtonItem = doneBtn
    tagView.touchDelegate = self
    updateCountLabel()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    accessory = UINib(nibName: "DismissKeyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DismissKeyboardView
    accessory!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
    accessory!.action = { self.dismissKeyboard() }
    textView.inputAccessoryView = accessory!
    titleFld.inputAccessoryView = accessory!
    textView.delegate = self
    
    guard let doc = document else {
      textView.text = ""
      titleFld.text = ""
      titleFld.becomeFirstResponder()
      return
    }
    textView.text = doc.text
    titleFld.text = doc.title!
    tagView.configure(with: Array(doc.tags!))
    self.tags = Array(doc.tags!)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  // MARK: Keyboard show/hide
  
  func dismissKeyboard() {
    if textView.isFirstResponder {
      textView.resignFirstResponder()
    } else {
      titleFld.resignFirstResponder()
    }
  }
  
  // MARK: Done
  
  @objc func done() {
    defer {
      navigationController?.popViewController(animated: true)
    }
    
    guard let doc = document else {
      let newDoc = Document(context: context)
      newDoc.setText(to: textView.text, withTitle: titleFld.text!)
      if let tags = self.tags {
        for tag in tags {
          newDoc.addToTags(tag)
          tag.addToDocuments(newDoc)
        }
      } else {
        newDoc.tags = nil
      }
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
    if let tags = self.tags {
      for tag in tags {
        doc.addToTags(tag)
        tag.addToDocuments(doc)
      }
    } else {
      doc.tags = nil
    }
    doc.lastUpdated = Date() as NSDate
    do {
      try context.save()
    } catch {
      print("oops document saving didn't work!")
    }
  }
  
  // MARK: Share
  @IBAction func share(sender: UIBarButtonItem) {
    var shareItems = [Any]()
    if let title = titleFld.text {
      shareItems.append(title)
    }
    if let text = textView.text {
      shareItems.append(text)
    }
    let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    present(vc, animated: true, completion: nil)
  }
  
  // MARK: Touch Delegate
  
  func handleTouch() {
    performSegue(withIdentifier: "showTagSelect", sender: self)
  }
  
  // MARK: Tag Select Delegate
  
  func updateDocumentTags(with newTags: [Tag]?) {
    self.tags = newTags
    tagView.configure(with: self.tags)
  }
  
  // MARK: TextView Delegate
  
  func updateCountLabel() {
    countLbl.text = "C: \(textView.characterCount)"
    accessory!.updateCountLabel(with: "C: \(textView.characterCount)")
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updateCountLabel()
  }
  
  // MARK: Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTagSelect" {
      let destVC = segue.destination as! TagSelectVC
      destVC.tags = self.tags
      destVC.context = self.context
      destVC.tagSelectDelegate = self
    }
  }
  
}
