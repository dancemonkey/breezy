//
//  DefaultKeys.swift
//  Breezy
//
//  Created by Drew Lanning on 2/21/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import Foundation

enum ListSortKeys {
  case created
  case modified
  case title
  
  var value: String {
    switch self {
    case .created:
      return "creation"
    case .modified:
      return "lastUpdated"
    case .title:
      return "title"
    }
  }
}
