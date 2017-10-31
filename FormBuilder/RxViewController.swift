//
//  RxViewController.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxViewController: UIViewController, UITableViewDelegate {

  var bag = DisposeBag()
  var fb: RxALFormBuilderProtocol!
  let logger = Atlantis.Logger()
  
  // IBOutlet & UI
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let d = BoolVvv(value: false)
//    d.change(originalValue: true)
//    logger.debug("first = \(d.transformForDisplay())")
//    d.change(originalValue: false)
//    logger.debug("first = \(d.transformForDisplay())")

    
    // Do any additional setup after loading the view.
    self.configureUI()
    self.configureTable()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func configureTable() {
    self.fb = RxALFormBuilder(compositeFormData: AuthFormDirector.build(),
                            jsonBuilder: ALFormJSONBuilder(predefinedObject: [:]))
    
    let datasource = BehaviorSubject<[RxSectionModel]>(value: [])

    fb.rxDidChangeFormModel.subscribe(onNext: { [weak self] item in
      if let p = item as? RowCompositeValueTransformable {
        print("something change in \(item.identifier) to: \(p.value.transformForDisplay() ?? "")")
      }
      self?.logger.debug(self?.fb.object(withoutNull: false) ?? [:])
    }).disposed(by: bag)
    fb.rxDidDatasource.bind(to: datasource).disposed(by: bag)
    
    fb.rxDidChangeFormState.subscribe(onNext: { isChange in
      print("something change in all form to: \(isChange)")
    }).disposed(by: bag)
    fb.rxDidChangeCompletelyValidation.subscribe(onNext: { state in
      print("all form completely valid: \(state)")
    }).disposed(by: bag)
    
//    fb.didChangeFormModel = { item in
//      datasource.onNext(FormBuilder.buildRxDataSource(item: item))
//    }
//
//    fb.didChangeFormState = { state in
//      print("something change in all form to: \(state)")
//    }
//
//    fb.didChangeCompletelyValidation = { state in
//      print("all form completely valid: \(state)")
//    }
    
    self.fb.prepareDatasource()
    
    // Table view
    let rxDataSource = RxTableViewSectionedAnimatedDataSource<RxSectionModel>()
    
    
    rxDataSource.configureCell = { (dataSource, table, idxPath, _) in
      var item: RxSectionItemModel
      
      do {
        item = try dataSource.model(at: idxPath) as! RxSectionItemModel
      } catch {
        return UITableViewCell()
      }
      
      let cellType = item.model.cellType.type
      let cell = table.dequeueReusableTableCell(forIndexPath: idxPath, andtype: cellType)
      
      if let c = cell as? RxCellReloadeble {
        c.reload(with: item.model)
      }
      
      if var c = cell as? TableReloadable {
        c.reload = { _ in
          table.beginUpdates()
          table.endUpdates()
        }
      }
      
      cell.selectionStyle = UITableViewCellSelectionStyle.none
      return cell
    }
    
    rxDataSource.animationConfiguration =
      AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
    
    tableView.rx.setDelegate(self)
      .disposed(by: bag)
    
    tableView.rx.modelSelected(RxSectionItemModel.self).asObservable().subscribe(onNext: { model in
      print(model.model.identifier)
      guard let item = model.model as? RowFormTextComposite else {
        return
      }
      
      item.base.needReloadModel()
      item.validate(value: TupleValue(value: ALTupleValue("Екатеринбург", 23)))
    }).disposed(by: bag)
    
    rxDataSource.titleForHeaderInSection = { ds, index in
      return ds.sectionModels[index].model.header
    }
    
    rxDataSource.titleForFooterInSection = { ds, index in
      return ds.sectionModels[index].model.footer
    }
    
    datasource
      .bind(to: tableView.rx.items(dataSource: rxDataSource))
      .disposed(by: bag)
  }
  
  func configureUI() {
    tableView.setupEstimatedRowHeight()
    tableView.registerCells(by: [ALFBTextViewCell.cellIdentifier, ALFBButtonViewCell.cellIdentifier,
                                 ALFBBoolViewCell.cellIdentifier, ALFBPickerViewCell.cellIdentifier,
                                 ALFBTextInfoViewCell.cellIdentifier, ALFBPhoneViewCell.cellIdentifier], bundle: Bundle.alfb_frameworkBundle())
    tableView.registerCells(by: [ALFBTextMultilineViewCell.cellIdentifier])
  }
  
  deinit {
    print("RxViewController dead")
  }
}
