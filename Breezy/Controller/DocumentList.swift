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
  
  lazy var frc: NSFetchedResultsController<Document> {
    
    let context = 

    var fetchedResultsController = NSFetchedResultsController<Document>(fetchRequest: Document.fetchRequest(), managedObjectContext: <#T##NSManagedObjectContext#>, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return DocumentListCell()
  }
  
}


