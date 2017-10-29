//
//  RxViewController.swift
//  FormBuilder
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
  var fb: RxFormBuilderProtocol!
  let logger = Atlantis.Logger()
  
  // IBOutlet & UI
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let d = BoolVvv(value: false)
    d.change(originalValue: true)
    logger.debug("first = \(d.transformForDisplay())")
    d.change(originalValue: false)
    logger.debug("first = \(d.transformForDisplay())")

    
    // Do any additional setup after loading the view.
    self.configureUI()
    self.configureTable()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func configureTable() {
    self.fb = RxFormBuilder(compositeFormData: AuthFormDirector.build(),
                            jsonBuilder: FormJSONBuilder(predefinedObject: [:]))
    
    let datasource = BehaviorSubject<[RxSectionModel]>(value: [])

    fb.rxDidChangeFormModel.bind(to: datasource).disposed(by: bag)
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
    let rxDataSource = RxTableViewSectionedAnimatedDataSource<RxSectionModel>(configureCell: { (dataSource, table, idxPath, _) in
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
      
      cell.selectionStyle = UITableViewCellSelectionStyle.none
      return cell
    })
    
    rxDataSource.animationConfiguration =
      AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
    
    tableView.rx.setDelegate(self)
      .disposed(by: bag)
    
    tableView.rx.modelSelected(RxSectionItemModel.self).asObservable().subscribe(onNext: { model in
      print(model.model.identifier)
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
    tableView.registerCells(by: [FormTextViewCell.cellIdentifier, FormButtonViewCell.cellIdentifier, FormBoolViewCell.cellIdentifier])
  }
  
  
  
  deinit {
    print("RxViewController dead")
  }
}
