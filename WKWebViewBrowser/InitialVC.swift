//
//  InitialVC.swift
//  WKWebViewBrowser
//
//  Created by Thomas Richardson on 9/2/16.
//  Copyright © 2016 Thomas Richardson. All rights reserved.
//

import UIKit
import WebKit
class InitialVC: UIViewController, UITextFieldDelegate, WKNavigationDelegate,UIScrollViewDelegate{
    
    //MARK: IBOutlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var reloadBarButton: UIBarButtonItem!
    @IBOutlet weak var forwardBarButton: UIBarButtonItem!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var navBarView: UIView!
    //MARK: Properties
    
    var webView: WKWebView?
    var lastContentOffset : CGPoint  = CGPoint(x: 0, y: 0)
    
    //MARK: Initilize Views
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.navigationDelegate = self
        webView?.scrollView.delegate = self
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 30)
        urlTextField.delegate = self
        
        if let _webView = webView {
            
            view.insertSubview(_webView, belowSubview: progressView)
            
            _webView.translatesAutoresizingMaskIntoConstraints = false
            
            let heightConstraint = NSLayoutConstraint(item: _webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: _webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0)
            
            view.addConstraints([heightConstraint,widthConstraint])
            
            _webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
            _webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            
            if let _googleURL = URL(string: "https://www.Google.com/")
            {
               

                let request = URLRequest(url: _googleURL)
                _webView.load(request)
            }
  
        }
        
    
        backBarButton.isEnabled = false
        forwardBarButton.isEnabled = false
    }
    
   required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        
    }
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 100 , height: 30)

    }
    //MARK: Funtions
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading"
        {
            
            if let _webView = webView
            {
                backBarButton.isEnabled = _webView.canGoBack
                forwardBarButton.isEnabled = _webView.canGoForward
            }
      
        }
        
        if (keyPath == "estimatedProgress") {
            
            if let _webView = webView
            {
                
                progressView.isHidden = _webView.estimatedProgress == 1
                progressView.setProgress(Float(_webView.estimatedProgress), animated: true)
            }
       
        }
    }
    
    //MARK: @IBActions
    
    @IBAction func backBarButtonPressed(_ sender: UIBarButtonItem) {
        
        if let _webView = webView
        {
            _webView.goBack()
        }
    }
    @IBAction func forwardBarButtonPressed(_ sender: AnyObject) {
        if let _webView = webView
        {
            _webView.goForward()
        }
    }
    @IBAction func reloadBarButtonPressed(_ sender: AnyObject) {
        if let _webView = webView
        {
            let request = URLRequest(url: _webView.url!)
            _webView.load(request)
        }
    }
    //MARK: Delegates
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: { 
            
        })  }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        urlTextField.resignFirstResponder()
        

        
        if let textFieldText = urlTextField.text, let url = URL(string: textFieldText), let _webView = webView

        {
            if textFieldText.contains("http://"){
                
            }
            else
            {
                self.urlTextField.text = "http://\(self.urlTextField.text!)"

            }
                _webView.load(URLRequest(url: url))

          

        }
        return false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
        
        
   
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
  
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (lastContentOffset.y < scrollView.contentOffset.y) {
            
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
            
        else if (lastContentOffset.y > scrollView.contentOffset.y) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        }
    }
}

