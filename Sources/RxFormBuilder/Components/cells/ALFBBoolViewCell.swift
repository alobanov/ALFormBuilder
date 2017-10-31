//
//  FormBoolViewCell.swift
//  Pulse
//
//  Created by Lobanov Aleksey on 16.03.17.
//  Copyright © 2017 MOPC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ALFBBoolViewCell: UITableViewCell, RxCellReloadeble {
  
  @IBOutlet weak var switchComponent: UISwitch!
  @IBOutlet weak var titleText: UILabel!
  
  private var storedModel: RowFormBoolCompositeOutput!
  private var alreadyInitialized = false
  private let bag = DisposeBag()
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    layoutIfNeeded()
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let formModel = model as? RowFormBoolCompositeOutput else {
      return
    }
    
    titleText?.text = formModel.title
    switchComponent.isOn = (formModel.value.retriveOriginalValue() as? Bool) ?? false
    
    if !alreadyInitialized {
      storedModel = formModel
      alreadyInitialized = true
      accessoryType = UITableViewCellAccessoryType.none
      configureRx()
    }
  }
  
  private func configureRx() {
    // configure rx
    let checkButtonSelected = self.switchComponent.rx
      .controlEvent(UIControlEvents.valueChanged)
      .asDriver()
      .map { [weak self] _ -> Bool in
        return self?.switchComponent.isOn ?? false
      }.startWith(storedModel.value.retriveOriginalValue() as? Bool ?? false)
    
    checkButtonSelected.drive(onNext: {[weak self] state in
      self?.switchComponent.isSelected = state
      self?.storedModel.validate(value: BoolValue(value: state))
    }).disposed(by: bag)
  }
}
