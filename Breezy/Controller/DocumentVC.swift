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
  
  // MARK: Properties
  
  @IBOutlet weak var textView: DocumentTextView!
  @IBOutlet weak var tagView: TagShareView!
  @IBOutlet weak var tagViewBtmConstraint: NSLayoutConstraint!
  @IBOutlet weak var shareBtn: UIBarButtonItem!
  @IBOutlet weak var countLbl: CountLbl!
  
  var context: NSManagedObjectContext!
  var document: Document?
  var tags: [Tag]? = nil
  var accessory: DismissKeyboardView?
  var tempTitle: String? = nil
  let headerAttributes = [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
  let bodyAttributes = [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
  
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
    textView.delegate = self
    
    guard let doc = document else {
      textView.text = ""
      textView.becomeFirstResponder()
      return
    }
    textView.text = doc.text
    tagView.configure(with: Array(doc.tags!))
    self.tags = Array(doc.tags!)
    highlightFirstLineInTextView()
  }
  
  func highlightFirstLineInTextView() {
    let textAsNSString = textView.text as NSString
    let lineBreakRange = textAsNSString.range(of: "\n")
    let newAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
    let boldRange: NSRange
    if lineBreakRange.location < textAsNSString.length {
      boldRange = NSRange(location: 0, length: lineBreakRange.location)
    } else {
      boldRange = NSRange(location: 0, length: textAsNSString.length)
    }
    tempTitle = newAttributedText.string
    newAttributedText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: FontStyle.title.face, size: FontStyle.title.size), range: boldRange)
    textView.attributedText = newAttributedText
  }
  
  // MARK: Keyboard show/hide
  
  func dismissKeyboard() {
    if textView.isFirstResponder {
      textView.resignFirstResponder()
      highlightFirstLineInTextView()
    }
  }
  
  // MARK: Done
  
  @objc func done() {
    defer {
      navigationController?.popViewController(animated: true)
    }
    highlightFirstLineInTextView()
    guard let doc = document else {
      let newDoc = Document(context: context)
      newDoc.setText(to: textView.text, withTitle: tempTitle ?? "")
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
    doc.setText(to: textView.text, withTitle: tempTitle ?? "")
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
  
//  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//    let textAsNSString = self.textView.text as NSString
//    let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
//    let boldRange = replaced.range(of: "\n")
//    if boldRange.location <= range.location {
//      self.textView.typingAttributes = self.headerAttributes as! [String:Any]
//    } else {
//      self.textView.typingAttributes = self.bodyAttributes
//    }
//    return true
//  }
  
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
