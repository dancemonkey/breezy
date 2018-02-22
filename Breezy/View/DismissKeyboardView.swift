//
//  DismissKeyboardView.swift
//  Breezy
//
//  Created by Drew Lanning on 2/22/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//

import UIKit

class DismissKeyboardView: UIView {

  @IBOutlet weak var dismissBtn: UIButton!
  
  var action: (() -> ())?
  
  @IBAction func dismiss(sender: UIButton) {
    guard let action = self.action else { return }
    action()
  }

}
