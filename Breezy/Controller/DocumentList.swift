//
//  ViewController.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DocumentList: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource {
  
  // TODO: call new document command on every launch
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  
  var frc: NSFetchedResultsController<Document> {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creation", ascending: true)]
    let fetchedResultsController = NSFetchedResultsController<Document>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  // MARK: App Start
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: Tableview Methods
  
  func configure(_ cell: DocumentListCell, with object: Document) {
    cell.configure(with: object)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = frc.sections else {
      return 0
    }
    
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return frc.sections![section].numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell") as! DocumentListCell
    configure(cell, with: frc.object(at: indexPath))
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
    
    switch type {
    case .update:
      // update table
    case .move:
      // update table
    case .delete:
      // update table
    case .insert:
      // update table
    }
  }
  
}


