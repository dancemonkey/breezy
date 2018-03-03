//
//  ViewController.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class DocumentList: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TagFilterDelegate {
  
  // MARK: Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newBtn: UIBarButtonItem!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var frc: NSFetchedResultsController<Document>!
  var filterTags: [Tag]? = nil
  var currentSort: ListSort?
  
  // MARK: App Start
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // HACK TO FIX GRAYED-OUT UIBARBUTTONITEM BUG
    // https://forums.developer.apple.com/thread/75521
    newBtn.isEnabled = false
    newBtn.isEnabled = true    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    searchBar.showsCancelButton = true
    
    var ascending = false
    if getDefaultSort() == .title {
      ascending = true
    }
    frc = initializeFRC(withSort: NSSortDescriptor(key: getDefaultSort().rawValue, ascending: ascending))
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      print("no fetchie")
    }
    tableView.reloadData()
  }
  
  func getDefaultSort() -> ListSort {
    guard let sortMethod = UserDefaults().value(forKey: DefaultKeys.sortMethod.rawValue) else {
      currentSort = .lastUpdated
      return .lastUpdated
    }
    guard let method = ListSort(rawValue: sortMethod as! String) else {
      currentSort = .lastUpdated
      return .lastUpdated
    }
    currentSort = method
    return method
  }
  
  func initializeFRC(withSort sort: NSSortDescriptor) -> NSFetchedResultsController<Document> {
    let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
    fetchRequest.sortDescriptors = [sort]
    let fetchedResultsController: NSFetchedResultsController<Document> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  // MARK: Filter and Sort Buttons
  @IBAction func sort(sender: UIBarButtonItem) {
    var message = ""
    switch currentSort! {
    case .creation:
      message = "Sorting by creation date."
    case .lastUpdated:
      message = "Sorting by date last modified."
    case .title:
      message = "Sorting by title."
    }
    
    let alert = UIAlertController(title: message, message: nil, preferredStyle: .actionSheet)
    let created = UIAlertAction(title: "Created", style: .default) { (action) in
      self.currentSort = .creation
      self.sort(by: .creation)
    }
    let modified = UIAlertAction(title: "Modified", style: .default) { (action) in
      self.currentSort = .lastUpdated
      self.sort(by: .lastUpdated)
    }
    let name = UIAlertAction(title: "Name", style: .default) { (action) in
      self.currentSort = .title
      self.sort(by: .title)
    }
    alert.addAction(modified)
    alert.addAction(created)
    alert.addAction(name)
    self.present(alert, animated: true, completion: nil)
  }
  
  private func sort(by method: ListSort) {
    frc.delegate = nil
    var ascending = false
    if method == .title {
      ascending = true
    }
    self.frc = initializeFRC(withSort: NSSortDescriptor(key: method.rawValue, ascending: ascending))
    frc.delegate = self
    do {
      try frc.performFetch()
      tableView.reloadData()
    } catch {
      print("failed fetch after setting new sort method")
    }
    UserDefaults().set(method.rawValue, forKey: DefaultKeys.sortMethod.rawValue)
  }
  
  @IBAction func filter(sender: UIBarButtonItem) {
    performSegue(withIdentifier: "selectTagFilter", sender: nil)
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
  
  // MARK: Search bar delegate
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    var predicate: NSPredicate? = nil
    if let text = searchBar.text, text.count > 0 {
      predicate = NSPredicate(format: "(title contains[c] %@) || (text contains[c] %@)", text, text)
      frc.fetchRequest.predicate = predicate
      do {
        try frc.performFetch()
      } catch {
        print("predicated fetch not successful")
      }
      tableView.reloadData()
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.text = ""
    frc.fetchRequest.predicate = nil
    do {
      try frc.performFetch()
    } catch {
      print("search fetch not successful")
    }
    tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.text = ""
    frc.fetchRequest.predicate = nil
    do {
      try frc.performFetch()
    } catch {
      print("clearing search fetch not successful")
    }
    tableView.reloadData()
  }
  
  // MARK: Tag Filter Delegate
  func filterBy(tags: [Tag]?) {
    filterTags = tags
    guard let t = tags else {
      frc.fetchRequest.predicate = nil
      do {
        try frc.performFetch()
      } catch {
        print("filtered fetch not successful")
      }
      tableView.reloadData()
      return
    }
    var filters = [NSPredicate]()
    for tag in t {
      let new = NSPredicate(format: "%@ IN tags", tag)
      filters.append(new)
    }
    let filter = NSCompoundPredicate(orPredicateWithSubpredicates: filters)
    frc.fetchRequest.predicate = filter
    do {
      try frc.performFetch()
    } catch {
      print("filtered fetch not successful")
    }
    tableView.reloadData()
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
    } else if segue.identifier == "selectTagFilter" {
      let destinaton = segue.destination as! TagSelectVC
      destinaton.context = self.context
      destinaton.tagFilterDelegate = self
      destinaton.tags = filterTags
    }
  }
  
}


