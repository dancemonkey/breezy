//
//  TagSelectDelegate.swift
//  Breezy
//
//  Created by Drew Lanning on 2/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

protocol TagSelectDelegate {
  func updateDocumentTags(with newTags: [Tag]?)
}
