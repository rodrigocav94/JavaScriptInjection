//
//  ActionViewControllerDataSource.swift
//  Extension
//
//  Created by Rodrigo Cavalcanti on 21/06/24.
//

import UIKit
import UniformTypeIdentifiers

class ActionViewControllerDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var scripts: [SavedScript] = {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        if let encodedData = defaults.data(forKey: "scripts"), let savedScripts = try? decoder.decode([SavedScript].self, from: encodedData) {
            return savedScripts
        }
        
        return []
    }() {
        didSet {
            saveToUserDefaults()
        }
    }
    
    var extensionContext: NSExtensionContext?
    var onAdd: (() -> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scripts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        let scriptRow = scripts[indexPath.row]
        cell.textLabel?.text = scriptRow.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedScript = scripts[indexPath.row]
        let argument: NSDictionary = ["customJavaScript": selectedScript.script as Any]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier as String)
        
        let item = NSExtensionItem()
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(scripts) {
            defaults.setValue(encodedData, forKey: "scripts")
        }
    }
}
