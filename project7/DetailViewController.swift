//
//  DetailViewController.swift
//  project7
//
//  Created by Ярослав on 3/30/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webview: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webview = WKWebView()
        view = webview
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name = "viewport" content ="width=devaice-width,initial-scale=1">
        <style> body{ front-size: 150%; } </style>
        </head>
        <bodu>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webview.loadHTMLString(html, baseURL: nil)
        

        // Do any additional setup after loading the view.
    }
    

    

}
