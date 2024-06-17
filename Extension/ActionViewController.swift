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

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem { // ExtensionContext lets us control how the extension interacts with the parent app. InputItems is an array of data the parent app is sending to our extension to use.
            
            if let itemProvider = inputItem.attachments?.first { // First attachment from the first input item.
                
                
                //  Ask the item provider to actually provide us with its item. This method is async, so it will carry on executing while the item provider is busy loading and sending us its data.:
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier as String) { [weak self] (dict, error) in // The dictionary that was given to us by the item provider, and any error that occurred.
                    
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
