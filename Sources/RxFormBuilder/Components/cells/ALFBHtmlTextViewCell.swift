//
//  ALFBHtmlTextViewCell.swift
//  FormBuilder
//
//  Created by NVV on 14/11/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit
import WebKit

open class ALFBHtmlTextViewCell: UITableViewCell, RxCellReloadeble, WKNavigationDelegate, TableReloadable {
  
  public var reload: (() -> Void)?
  
  @IBOutlet weak var titleLabel: UILabel!
  
  private var webView: WKWebView?
  private var webViewHeight: NSLayoutConstraint?
  private let contentSizePath = "contentSize"
  
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
//    textView.textColor = ALFBStyle.fbDarkGray
    titleLabel.textColor = ALFBStyle.fbDarkGray
    
    //disable auto shrink
    let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    let wkUScript = WKUserScript(source: jScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
    let wkUController = WKUserContentController()
    wkUController.addUserScript(wkUScript)
    let wkWebConfig = WKWebViewConfiguration()
    wkWebConfig.userContentController = wkUController;
    
    //create webView
    let webView = WKWebView(frame: CGRect.zero, configuration: wkWebConfig)
    webView.scrollView.contentInset = UIEdgeInsets.zero
    webView.clipsToBounds = true
    webView.navigationDelegate = self
    webView.translatesAutoresizingMaskIntoConstraints = false
    contentView.insertSubview(webView, at: 0)
    
    //setup constraints
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[wv]-12-|", options: [], metrics: nil, views: ["wv" : webView]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[title]-5-[wv]-8@999-|", options: [], metrics: nil, views: ["title" : titleLabel, "wv" : webView]))
    let h = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 0.0)
    h.priority = 999
    webView.addConstraint(h)
    self.webViewHeight = h
    self.webView = webView
    
    //observe contentSize to change height
    webView.scrollView.addObserver(self, forKeyPath: contentSizePath, options: [.new], context: nil)
    
    contentView.clipsToBounds = true
    clipsToBounds = true
    webView.clipsToBounds = true
    webView.scrollView.clipsToBounds = true
  }
  
  deinit {
    self.webView?.scrollView.removeObserver(self, forKeyPath: contentSizePath)
  }
  
  // MARK: - KVO
  
  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == contentSizePath {
      DispatchQueue.main.async {
        let height = self.webView?.scrollView.contentSize.height ?? 0.0
        if self.webViewHeight?.constant ?? 0 != height {
          self.webViewHeight?.constant = height
          self.webView?.alpha = 0.0
          self.reload?()
          UIView.animate(withDuration: 0.3, animations: {
            self.webView?.alpha = 1.0
            self.layoutIfNeeded()
          })
        }
      }
    }
  }
  
  // MARK: - RxCellReloadeble
  
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
    if navigationAction.navigationType == .linkActivated {
      decisionHandler(WKNavigationActionPolicy.cancel)
      if let url = navigationAction.request.url,
        UIApplication.shared.canOpenURL(url)
      {
        UIApplication.shared.openURL(url)
      }
    } else {
      decisionHandler(WKNavigationActionPolicy.allow)
    }
  }
  
}
