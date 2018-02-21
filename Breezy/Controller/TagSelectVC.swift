//
//  TagSelectVC.swift
//  Breezy
//
//  Created by Drew Lanning on 2/21/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit
import CoreData

class TagSelectVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneBtn: UIButton!
  
  var allTags = [Tag]()
  var document: Document?
  var frc: NSFetchedResultsController<Tag>!
  var context: NSManagedObjectContext!
  
  // MARK: Initialization
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
    let backBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    self.navigationItem.rightBarButtonItem = doneBtn
    self.navigationItem.backBarButtonItem = backBtn
    
    tableView.delegate = self
    tableView.dataSource = self
    frc = initializeFRC()
    do {
      try frc.performFetch()
    } catch {
      print("no tag fetch :(")
    }
    setupTags()
  }
  
  func setupTags() {
    guard let tags = frc.fetchedObjects else {
      return
    }
    
    for tag in tags {
      allTags.append(tag)
    }
  }
  
  func initializeFRC() -> NSFetchedResultsController<Tag> {
    let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let fetchedResultsController: NSFetchedResultsController<Tag> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return fetchedResultsController
  }
  
  
  
  @objc func done(sender: UIBarButtonItem) {
    // save tags to existing doc OR send chosen tags back to document screen for saving to new doc
  }
  
  // MARK: Tableview
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allTags.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell")
    cell?.textLabel?.text = allTags[indexPath.row].name!
    return cell!
  }
  
}
