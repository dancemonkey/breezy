//
//  TagSelectVC.swift
//  Breezy
//
//  Created by Drew Lanning on 2/21/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TagSelectVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newBtn: UIBarButtonItem!
  
  var tags: [Tag]? = nil
  var selectedTags = [Tag]()
  var frc: NSFetchedResultsController<Tag>!
  var context: NSManagedObjectContext!
  var tagSelectDelegate: TagSelectDelegate?
  var tagFilterDelegate: TagFilterDelegate?
  
  // MARK: Initialization
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let doneBtn = UIBarButtonItem(image: UIImage(named: "Done"), style: .plain, target: self, action: #selector(self.done))
    let backBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    self.navigationItem.rightBarButtonItem = doneBtn
    self.navigationItem.backBarButtonItem = backBtn
    
    tableView.delegate = self
    tableView.dataSource = self
    
    frc = initializeFRC()
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("no tag fetch :(")
    }
    
    if tags != nil {
      selectDocTags()
    }

  }
  
  func initializeFRC() -> NSFetchedResultsController<Tag> {
    let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Tag> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  func selectDocTags() {
    guard let tags = self.tags, let fetched = frc.fetchedObjects else { return }
    for tag in tags {
      if fetched.contains(tag) {
        tableView.selectRow(at: frc.indexPath(forObject: tag), animated: true, scrollPosition: .none)
        let cell = tableView.cellForRow(at: frc.indexPath(forObject: tag)!) as! TagSelectCell
        cell.selectIndicator.isHidden = false
      }
    }
  }
  
  // MARK: Interface Buttons
  
  @objc func done(sender: UIBarButtonItem) {
    defer {
      navigationController?.popViewController(animated: true)
    }
    guard let selected = tableView.indexPathsForSelectedRows else {
      tagSelectDelegate?.updateDocumentTags(with: nil)
      tagFilterDelegate?.filterBy(tags: nil)
      return
    }
    for selection in selected {
      selectedTags.append(frc.fetchedObjects![selection.row])
    }
    
    if tagSelectDelegate != nil {
      tagSelectDelegate?.updateDocumentTags(with: selectedTags)
    } else if tagFilterDelegate != nil {
      tagFilterDelegate?.filterBy(tags: selectedTags)
    }
    
  }
  
  @IBAction func new(sender: UIBarButtonItem) {
    let popup = UIAlertController(title: "Create Tag", message: "Enter tag name below.", preferredStyle: .alert)
    popup.addAction(UIAlertAction(title: "DONE", style: .default, handler: { (action) in
      let tagName = popup.textFields![0] as UITextField
      guard let tag = tagName.text, tag != "" else { return }
      let newTag = Tag(context: self.context)
      newTag.name = tag
      self.dismiss(animated: true, completion: nil)
    }))
    popup.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    popup.addTextField { (field) in
      field.placeholder = ""
    }
    self.present(popup, animated: true, completion: nil)
  }
  
  @IBAction func clear(sender: UIBarButtonItem) {
    for row in 0 ..< tableView.numberOfRows(inSection: 0) {
      tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
    }
  }
  
  // MARK: Tableview
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let tags = frc.fetchedObjects else { return 0 }
    return tags.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tagSelectCell") as! TagSelectCell
    cell.configure(with: frc.fetchedObjects![indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let tag = frc.object(at: indexPath)
      tag.prepareForDeletion()
      context.delete(tag)
      do {
        try context.save()
      } catch {
        print("did not save after deleting tag")
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! TagSelectCell
    cell.selectIndicator.isHidden = false
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! TagSelectCell
    cell.selectIndicator.isHidden = true
  }
  
  // MARK: NS FRC methods
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .fade)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
    case .move:
      if let indexPath = indexPath, let newIndexPath = newIndexPath {
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.insertRows(at: [newIndexPath], with: .fade)
      }
    }
  }
  
}
