//
//  FormBoolViewCell.swift
//  Pulse
//
//  Created by Lobanov Aleksey on 16.03.17.
//  Copyright © 2017 Aleksey Lobanov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ALFBBoolViewCell: UITableViewCell, RxCellReloadeble {
  
  @IBOutlet weak var switchComponent: UISwitch!
  @IBOutlet weak var titleText: UILabel!
  
  private var storedModel: RowFormBoolCompositeOutput!
  private var alreadyInitialized = false
  private var bag = DisposeBag()
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    layoutIfNeeded()
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let formModel = model as? RowFormBoolCompositeOutput else {
      return
    }
    
    switchComponent.accessibilityIdentifier = formModel.identifier
    
    titleText?.text = formModel.title
    switchComponent.isOn = (formModel.value.retriveOriginalValue() as? Bool) ?? false
    
    switchComponent.isEnabled = !formModel.visible.isDisabled
    storedModel = formModel
    if !alreadyInitialized {
      alreadyInitialized = true
      accessoryType = UITableViewCellAccessoryType.none
      configureRx()
    }
  }
  
//  open override func prepareForReuse() {
//    super.prepareForReuse()
//    bag = DisposeBag()
//    alreadyInitialized = false
//  }
  
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
      self?.storedModel.update(value: ALBoolValue(value: state))
    }).disposed(by: bag)
  }
}
