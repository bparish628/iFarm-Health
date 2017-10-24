//
//  SafetyViewWebViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/10/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit
import WebKit
class SiteWebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var site: Site!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration();
        webView = WKWebView(frame: .zero, configuration: webConfiguration);
        webView.uiDelegate = self;
        view = webView;
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let myURL = URL(string: self.site.url);
        let myRequest = URLRequest(url: myURL!);
        webView.load(myRequest);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // Set the title to the title of the site
        navigationItem.title = self.site.title
//        navigationItem.backBarButtonItem?.title = "Back"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    }
}

