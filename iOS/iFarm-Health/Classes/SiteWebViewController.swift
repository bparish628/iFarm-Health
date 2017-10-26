//
//  @file
//  SafetyViewWebViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/10/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit
import WebKit

/**
 Controls the webview of the site that is passed in when clicked from the TableCell
 */
class SiteWebViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Variables

    /**
     Contains the webview
     */
    var webView: WKWebView!
    
    /**
     Contains the passed in site
     */
    var site: Site!
    
    // MARK: - Functions

    /**
     Sets up the initial webview
     */
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration();
        webView = WKWebView(frame: .zero, configuration: webConfiguration);
        webView.uiDelegate = self;
        view = webView;
    }
    
    /**
     After the view loads, use the sites url
     */
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let myURL = URL(string: self.site.url);
        let myRequest = URLRequest(url: myURL!);
        webView.load(myRequest);
    }
    
    /**
     When the view will appear, set it's navigation title to the sites title
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // Set the title to the title of the site
        navigationItem.title = self.site.title
    }
}

