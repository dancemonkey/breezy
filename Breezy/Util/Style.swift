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
  case title
  
  var face: String {
    switch self {
    case .tag:
      return "Avenir-Oblique"
    case .document, .preview:
      return "Avenir"
    case .title:
      return "Avenir-Heavy"
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
    case .title:
      return 22.0
    }
  }
  
  var color: UIColor {
    switch self {
    case .tag:
      return UIColor(red: 144/255, green: 19/255, blue: 254/255, alpha: 1.0)
    case .document, .preview:
      return .black
    case .title:
      return .darkGray
    }
  }
  
}


