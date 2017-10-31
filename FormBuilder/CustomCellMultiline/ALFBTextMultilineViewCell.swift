//
//  ALFBTextMultilineViewCell.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 30/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import ALFormBuilder

protocol TableReloadable {
  var reload: (() -> Void)? {set get}
}

class ALFBTextMultilineViewCell: UITableViewCell, RxCellReloadeble, UITextViewDelegate, TableReloadable {

  var reload: (() -> Void)?
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var heightValue: NSLayoutConstraint!
  @IBOutlet weak var heightTextValue: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func reload(with model: RxCellModelDatasoursable) {
    
  }
  
  func textViewDidChange(_ textView: UITextView) {
    print(self.textView.contentSize.height)
    self.heightValue.constant = self.textView.contentSize.height
    self.heightTextValue.constant = self.textView.contentSize.height + 10
    self.textView.layoutIfNeeded()
    self.reload?()
  }
}
