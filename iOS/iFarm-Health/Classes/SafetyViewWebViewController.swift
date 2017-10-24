//
//  SafetyViewWebViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/10/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit
import WebKit
class SafetyViewWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration();
        webView = WKWebView(frame: .zero, configuration: webConfiguration);
        webView.uiDelegate = self;
        view = webView;
        self.navigationItem.title = "UNMC"
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let myURL = URL(string: "https://www.unmc.edu");
        let myRequest = URLRequest(url: myURL!);
        webView.load(myRequest);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
    }
}

