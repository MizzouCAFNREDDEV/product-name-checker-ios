//
//  ViewController.swift
//  Product Name Checker
//
//  Created by Michael Smith on 10/1/17.
//  Copyright © 2017 CAFNR EDDEV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var printName: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var viewPDF: UIButton!
    var pdfURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCheckProductName(_ sender: Any) {
        guard let productNameString = productName.text else{
            print("productName text was nil")
            return
        }
        self.resultLabel.isHidden = true
        self.viewPDF.isHidden = true
        if(productNameString != ""){
            checkProductName(productName: productNameString){ (statusCode:Int, error:String?) -> Void in
                DispatchQueue.main.async{
                    if(statusCode == 200){
                        self.resultLabel.text = "Allowed!"
                        self.resultLabel.isHidden = false
                        self.viewPDF.isHidden = false
                    }else if(statusCode == 406){
                        self.resultLabel.text = "Not Allowed. Please try again."
                        self.resultLabel.isHidden = false
                    }
                }
            }
        }
        
    }

    @IBAction func onViewPDF(_ sender: Any) {
        if let printNameString = printName.text, let productNameString = productName.text{
            let A4paperSize = CGSize(width: 595, height: 842)
            let pdf = SimplePDF(pageSize: A4paperSize)
            pdf.addText("Name: \(printNameString) \n\n")
            pdf.addText("\(productNameString) has been checked and is approved \n\n")
            // get the current date and time
            let currentDateTime = Date()
            
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            // get the date time String from the date object
            pdf.addText("Date: \(formatter.string(from: currentDateTime))")
            let pdfData = pdf.generatePDFdata()
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
            let url = documentsUrl.appendingPathComponent("/product-check.pdf")
            pdfURL = url
            try? pdfData.write(to: url, options: .atomic)
            //performSegue(withIdentifier: "viewPDF", sender: self)
            let activityViewController = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil)
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.sourceRect = CGRect.zero
                popoverPresentationController.sourceView = viewPDF
            }
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func checkProductName(productName: String, completionHandler:@escaping (_ statusCode: Int, _ error:String?)->Void){
         let config = URLSessionConfiguration.default //sets config as a URL Session
        config.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: config) //create a session
        //let url = URL(string: "http://product-check.dev/check?name=\(productName)") //setting the URL to a variable for easy use
        let url = URL(string: "http://cafnr-eddev.dev/products?name=\(productName)")
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if let response = response as? HTTPURLResponse { //unwrap the optional if it exists yet
                //print("data: \(data)")
                completionHandler(response.statusCode, nil)
            }
            if let error = error{
                completionHandler(404, error.localizedDescription)
            }
            print("error: \(String(describing: error?.localizedDescription))")
        })
        
        task.resume()//start the post "task"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ViewPDFController{
            controller.pdfURL = self.pdfURL
        }
    }
}

