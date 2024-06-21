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
        
        let notificationCenter = NotificationCenter.default // Get a reference to the default notification center.
        notificationCenter.addObserver(
            self, // The object that should receive notifications (it's self)
            selector: #selector(adjustForKeyboard), // The method that should be called
            name: UIResponder.keyboardWillHideNotification, // The notification we want to receive
            object: nil // The object we want to watch. Nil means "we don't care who sends the notification."
        )
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func done() {
        let argument: NSDictionary = ["customJavaScript": script.text as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier as String)
        
        let item = NSExtensionItem()
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return } // UIResponder.keyboardFrameEndUserInfoKey tells us the frame of the keyboard after it has finished animating. This will be of type NSValue, which in turn is of type CGRect. The CGRect struct holds both a CGPoint and a CGSize, so it can be used to describe a rectangle.
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue // pulling out the correct frame of the keyboard
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window) // Converting the rectangle to our view's co-ordinates. Convert() is used to be make sure it works on landscape too.
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero //  workaround for hardware keyboards being connected by explicitly setting the insets to be zero.
        } else {
            script.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, //  indent the edges of our text view so that it appears to occupy less space even though its constraints are still edge to edge in the view.
                right: 0
            )
        }
        
        // scroll so that the text entry cursor is visible. If the text view has shrunk this will now be off screen, so scrolling to find it again keeps the user experience intact.
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
}
