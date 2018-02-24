//
//  ViewController.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DocumentList: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
  
  // TODO: call new document command on every launch
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newBtn: UIBarButtonItem!
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  var frc: NSFetchedResultsController<Document>!
  var defaults: UserDefaults!
  
  // MARK: App Start
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // BELOW IS HACK TO FIX GRAYED-OUT UIBARBUTTONITEM BUG
    // https://forums.developer.apple.com/thread/75521
    newBtn.isEnabled = false
    newBtn.isEnabled = true    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    frc = initializeFRC(withSort: NSSortDescriptor(key: ListSortKeys.modified.value, ascending: false))
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("no fetchie")
    }
    tableView.reloadData()
    
    defaults = UserDefaults.standard
  }
  
  func initializeFRC(withSort sort: NSSortDescriptor) -> NSFetchedResultsController<Document> {
    let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
    fetchRequest.sortDescriptors = [sort]
    let fetchedResultsController: NSFetchedResultsController<Document> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  // MARK: Document Methods
  @IBAction func newDocument() {
    performSegue(withIdentifier: "showDocument", sender: nil)
  }
  
  // MARK: Tableview Methods
  
  func configure(cell: DocumentListCell, at indexPath: IndexPath) {
    cell.configure(with: frc.object(at: indexPath))
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let documents = frc.fetchedObjects else {
      return 0
    }
    return documents.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell") as! DocumentListCell
    configure(cell: cell, at: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showDocument", sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//      let doc = frc.object(at: indexPath)
//      doc.prepareForDeletion()
//      context.delete(doc)
//      do {
//        try context.save()
//      } catch {
//        print("failure to delete")
//      }
//    }
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let share = UITableViewRowAction(style: .normal, title: "Share") { (action, index) in
      var shareItems = [Any]()
      if let title = self.frc.object(at: index).title {
        shareItems.append(title)
      }
      if let text = self.frc.object(at: index).text {
        shareItems.append(text)
      }
      let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
      self.present(vc, animated: true, completion: nil)
    }
    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
      let doc = self.frc.object(at: indexPath)
      doc.prepareForDeletion()
      self.context.delete(doc)
      do {
        try self.context.save()
      } catch {
        print("failure to delete")
      }
    }
    return [share, delete]
  }
  
  // MARK: NS FRC Methods
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
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
  
  // MARK: Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDocument" {
      let destination = segue.destination as! DocumentVC
      if let indexPath = sender {
        destination.document = frc.fetchedObjects![(indexPath as! IndexPath).row]
      } else {
        destination.document = nil
      }
      destination.context = self.context
    }
  }
  
}


