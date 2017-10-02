//
//  ViewPDFController.swift
//  Product Name Checker
//
//  Created by Michael Smith on 10/1/17.
//  Copyright © 2017 CAFNR EDDEV. All rights reserved.
//

import UIKit

class ViewPDFController: UIViewController {

    public var pdfURL: URL?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: pdfURL!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
