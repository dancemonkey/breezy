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
      return "Avenir"
    case .document:
      return "Avenir"
    case .preview:
      return "Avenir-Oblique"
    }
  }
  
  var size: CGFloat {
    switch self {
    case .tag:
      return 10.0
    case .document:
      return 16.0
    case .preview:
      return 13.0
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


