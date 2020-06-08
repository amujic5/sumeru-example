//
//  WebViewController.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 20/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import SVProgressHUD

class WebViewController: UIViewController, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? String {
            print(messageBody)
        }
        
        if let scriptMessage = NUScriptMessage(message: message) {
            switch scriptMessage.action {
            case .payment:
                break
            case .login:
                print(scriptMessage.values)
                
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
                
                LoginService.shared.getData { (response) in
                    SVProgressHUD.dismiss(withDelay: 0.2)
                    if let data = response {
                        self.webView.evaluateJavaScript("continueLogin(\(data))") { (info, error) in
                            print(info)
                            print(error?.localizedDescription)
                        }
                    }
                }

            default:
                break
            }
        }
    }
    
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        userContentController.add(self, name: "sumeru")
        
        config.userContentController = userContentController

        // Inject JavaScript into the webpage. You can specify when your script will be injected and for
        // which frames–all frames or the main frame only.
        //let scriptSource = "window.webkit.messageHandlers.test.postMessage(`Hello, world!`);"
        // let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //  userContentController.addUserScript(userScript)

        let webview = WKWebView(frame: .zero, configuration: config)
        webview.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        webview.backgroundColor = .clear
        webview.scrollView.isScrollEnabled = true
        webview.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        webview.contentMode = .scaleAspectFit
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        
        return webview
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.init(style: .medium)
        view.hidesWhenStopped = true
        
        return view
    }()
    
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    
    var urlString: String
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(activityIndicatorView)
        
        webView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        

//        let htmlString = """
//<script>
//
//  function paymentDone() {
//    var message = `{\"action\": \"payment-action\", \"value\": {\"merchantId\": \"34234\", \"amount\": \"3423\", \"currency\": \"USD\", \"orderId\": \"2\",\"success\": true}}`;
//
//    if (typeof AndroidSumeru != `undefined`) {
//        AndroidSumeru.paymentDone(message);
//    }
//
//    if (typeof window.webkit.messageHandlers.sumeru != `undefined`) {
//        window.webkit.messageHandlers.sumeru.postMessage(message);
//    }
//  }
//  window.onload = paymentDone;
//</script>
//"""
//
//        webView.loadHTMLString(htmlString, baseURL: nil)
        
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)

        track()
       // setBottomButtons()
    }
    
    func setBottomButtons() {
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goBack))
        let forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goForward))
        let reloadButton = UIBarButtonItem(
                   image: UIImage(systemName: "arrow.counterclockwise")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                   style: .plain,
                   target: self.webView,
                   action: #selector(WKWebView.reload))
        
        self.toolbarItems = [backButton, forwardButton,
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             reloadButton
        ]
        self.backButton = backButton
        self.forwardButton = forwardButton
        
        self.backButton?.isEnabled = self.webView.canGoBack
        self.forwardButton?.isEnabled = self.webView.canGoForward
    }
    
    var savedUrl: String?
    
    func track() {
        //document.body.innerHTML
        webView.evaluateJavaScript("document.documentElement.outerHTML", completionHandler: { (value: Any!, error: Error!) -> Void in
            if
                let valueString = value as? String
            {
                if self.savedUrl == self.webView.url?.absoluteString {
                    return
                }
                
                if self.urlString == "https://www.pepperfry.com/" && self.webView.url?.absoluteString == "https://www.pepperfry.com/checkout/payment" {
                    
                    if let amount = valueString.slice(from: "class=\"cartProduct__finalPrice\">", to: "</span>") {
                        self.savedUrl = self.webView.url?.absoluteString
                        TrackingManager().save(payment: TrackingPayment(hostUrl: self.urlString, amount: amount, urlString: self.savedUrl ?? ""))
                    }
                    return
                }
                
                
                if self.webView.url?.absoluteString.contains("www.flipkart.com/rv/pay") == true {
                    if let amount = valueString.slice(from: "class=\"_3NH1UN\">", to: "</div>") {
                        self.savedUrl = self.webView.url?.absoluteString
                        TrackingManager().save(payment: TrackingPayment(hostUrl: self.urlString, amount: amount, urlString: self.savedUrl ?? ""))
                    }
                }

            }
            if error != nil {
                //Error logic
                return
            }
          //  print(value)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.track()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.title) {
            self.navigationItem.title = self.webView.title
        }
        if let _ = object as? WKWebView {
            if keyPath == #keyPath(WKWebView.canGoBack) {
                self.backButton?.isEnabled = self.webView.canGoBack
            } else if keyPath == #keyPath(WKWebView.canGoForward) {
                self.forwardButton?.isEnabled = self.webView.canGoForward
            }
        }
    }

}


extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
        
        self.webView.evaluateJavaScript(
            "document.title"
        ) { (result, error) -> Void in
            self.navigationItem.title = result as? String
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
        
        let alertController = UIAlertController(title: "Something went wrong", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) {[weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
      //  present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        activityIndicatorView.stopAnimating()
        decisionHandler(.allow)
        
        if navigationResponse.response.url?.absoluteString != self.savedUrl {
            self.savedUrl = nil
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}

extension WebViewController: WKUIDelegate {

    /**
     * Force all popup windows to remain in the current WKWebView.
     * By default, WKWebView is blocking new windows from being created
     * ex <a href="link" target="_blank">text</a>.
     * This code catches those popup windows and displays them in the current WKWebView.
     */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if (navigationAction.targetFrame == nil) {
            // Let's create a new webview on the fly with the provided configuration,
            // set us as the UI delegate and return the handle to the parent webview
            let popup = WKWebView(frame: self.view.frame, configuration: configuration)
            popup.uiDelegate = self
            self.view.addSubview(popup)
            return popup
        }
        
        // open in current view
        webView.load(navigationAction.request)

        // don't return a new view to build a popup into (the default behavior).
        return nil;
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        // Popup window is closed, we remove it
        webView.removeFromSuperview()
    }
}

extension String {

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
