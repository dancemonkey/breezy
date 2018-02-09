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
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  var frc: NSFetchedResultsController<Document>!
  
  // MARK: App Start
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    frc = initializeFRC()
    frc.delegate = self
    do {
      try frc.performFetch()
      print("fetched")
    } catch {
      print("no fetchie")
    }
    tableView.reloadData()
  }
  
  func initializeFRC() -> NSFetchedResultsController<Document> {
    let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creation", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Document> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  // MARK: Document Methods
  @IBAction func newDocument() {
    // open new document window
    let newDoc = Document(context: context)
    newDoc.title = "New"
    try! context.save()
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
    print("document count = \(documents.count)")
    return documents.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell") as! DocumentListCell
    configure(cell: cell, at: indexPath)
    return cell
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
  
}


