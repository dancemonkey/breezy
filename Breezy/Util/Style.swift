//
//  Style.swift
//  Breezy
//
//  Created by Drew Lanning on 2/17/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

enum FontStyle {
  case tag
  case document
  case preview
  
  var face: String {
    switch self {
    case .tag:
      return "Avenir-Oblique"
    case .document:
      return "Avenir"
    case .preview:
      return "Avenir"
    }
  }
  
  var size: CGFloat {
    switch self {
    case .tag:
      return 12.0
    case .document:
      return 18.0
    case .preview:
      return 15.0
    }
  }
  
  var color: UIColor {
    switch self {
    case .tag:
      return UIColor(red: 144/255, green: 19/255, blue: 254/255, alpha: 1.0)
    case .document:
      return .black
    case .preview:
      return .black
    }
  }
  
}


