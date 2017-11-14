//
//  ALFBHtmlTextViewCell.swift
//  FormBuilder
//
//  Created by NVV on 14/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import WebKit

open class ALFBHtmlTextViewCell: UITableViewCell, RxCellReloadeble, WKNavigationDelegate {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  var webView: WKWebView?
  var webViewHeight: NSLayoutConstraint?
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
//    textView.textColor = ALFBStyle.fbDarkGray
    titleLabel.textColor = ALFBStyle.fbDarkGray

    let webView = WKWebView(frame: CGRect.zero)
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(webView)
    webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[wv]-8-|", options: [], metrics: nil, views: ["wv" : webView]))
    webView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[title]-5-[vw]-8-|", options: [], metrics: nil, views: ["title" : titleLabel, "wv" : webView]))
    let h = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 0.0)
    webView.addConstraint(h)
    self.webViewHeight = h
    self.webView = webView
  }
  
  open override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFormTextCompositeOutput else {
      return
    }
    let htmlString = vm.value.transformForDisplay() ?? ""
    webView?.loadHTMLString(htmlString, baseURL: nil)
    titleLabel.text = vm.visualisation.placeholderTopText
  }
  
  // MARK: - WKNavigationDelegate
  
  public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    decisionHandler(WKNavigationActionPolicy.cancel)
    //TODO: open link
  }
  
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    DispatchQueue.main.async {
      self.webViewHeight?.constant = self.webView?.scrollView.contentSize.height ?? 0.0
    }
  }
  
  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    DispatchQueue.main.async {
      self.webViewHeight?.constant = (self.webView?.scrollView.contentSize.height)!
    }
  }
  
}
