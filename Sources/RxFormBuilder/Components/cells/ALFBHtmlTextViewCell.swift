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
  
  private var webView: WKWebView?
  private var webViewHeight: NSLayoutConstraint?
  private let contentSizePath = "contentSize"
  private let loadingPath = "loading"
  private var wvHeight: CGFloat = 1.0
  private var htmlStr: String?
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    //disable auto shrink
    let scaleJS = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'initial-scale=1, width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
    let cssString = "body { font-family: Helvetica; font-size: 14px; word-break:break-all }"
    let defaultStyleJS = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.getElementsByTagName('head')[0].appendChild(style);"
    let wkUScript1 = WKUserScript(source: scaleJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
    let wkUScript2 = WKUserScript(source: defaultStyleJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
    let wkUController = WKUserContentController()
    wkUController.addUserScript(wkUScript1)
    wkUController.addUserScript(wkUScript2)
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
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[wv]-8@999-|", options: [], metrics: nil, views: ["wv" : webView]))
    let h = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 1.0)
    h.priority = 999
    webView.addConstraint(h)
    self.webViewHeight = h
    self.webView = webView
    
    //observe contentSize to change height
    webView.scrollView.addObserver(self, forKeyPath: contentSizePath, options: [.new], context: nil)
    webView.addObserver(self, forKeyPath: loadingPath, options: [.new], context: nil)
    
    contentView.clipsToBounds = true
    clipsToBounds = true
    webView.clipsToBounds = true
    webView.scrollView.clipsToBounds = true
  }
  
  deinit {
    self.webView?.scrollView.removeObserver(self, forKeyPath: contentSizePath)
    self.webView?.removeObserver(self, forKeyPath: loadingPath)
  }
  
  // MARK: - KVO
  
  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let keyPath = keyPath else { return }
    guard let change = change else { return }
    
    switch keyPath {
    case loadingPath:
      if let val = change[NSKeyValueChangeKey.newKey] as? Bool {
        if !val {
          
        }
      }
    case contentSizePath:
      let height = self.webView?.scrollView.contentSize.height ?? 0.0
      if self.wvHeight != height && htmlStr != nil {
        print("\(self.wvHeight) == \(height)")
        self.wvHeight = height
        self.webViewHeight?.constant = self.wvHeight
        self.reload?()
      }
      break
      
    default:
      break
    }
  }
  
  // MARK: - RxCellReloadeble
  
  public func reload(with model: RxCellModelDatasoursable) {
    // check visuzlization model
    guard let vm = model as? RowFormTextCompositeOutput else {
      return
    }
    let htmlString = vm.value.transformForDisplay() ?? ""
    if self.htmlStr == htmlString {
      return
    }
    
    DispatchQueue.main.async {
      self.htmlStr = htmlString
      self.webView?.loadHTMLString(htmlString, baseURL: nil)
    }
    webView?.isUserInteractionEnabled = !vm.visible.isDisabled
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
