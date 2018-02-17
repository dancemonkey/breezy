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
  
  // MARK: App Start
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // BELOW IS HACK TO FIX GRAYED-OUT UIBARBUTTONITEM BUG
    // https://forums.developer.apple.com/thread/75521
    newBtn.isEnabled = false
    newBtn.isEnabled = true
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 75
    
    frc = initializeFRC()
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("no fetchie")
    }
    tableView.reloadData()
  }
  
  func initializeFRC() -> NSFetchedResultsController<Document> {
    let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
    let fetchedResultsController: NSFetchedResultsController<Document> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  // MARK: Document Methods
  @IBAction func newDocument() {
    // open new document window
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
    if editingStyle == .delete {
      let doc = frc.object(at: indexPath)
      doc.clearTags()
      context.delete(doc)
      do {
        try context.save()
      } catch {
        print("failure to delete")
      }
    }
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


