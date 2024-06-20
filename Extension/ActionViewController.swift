//
//  ActionViewController.swift
//  Extension
//
//  Created by Rodrigo Cavalcanti on 17/06/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem { // ExtensionContext lets us control how the extension interacts with the parent app. InputItems is an array of data the parent app is sending to our extension to use.
            
            if let itemProvider = inputItem.attachments?.first { // First attachment from the first input item.
                
                
                //  Ask the item provider to actually provide us with its item. This method is async, so it will carry on executing while the item provider is busy loading and sending us its data.:
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier as String) { [weak self] (dict, error) in // The dictionary that was given to us by the item provider, and any error that occurred.
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return } // NSExtensionJavaScriptPreprocessingResultsKey is a special key that holds the data we sent from JavaScript.
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    @IBAction func done() {
        let argument: NSDictionary = ["customJavaScript": script.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier as String)
        
        let item = NSExtensionItem()
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }

}
