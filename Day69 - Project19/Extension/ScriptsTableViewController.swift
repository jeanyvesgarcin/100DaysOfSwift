//
//  ScriptsTableViewController.swift
//  Extension
//  Day69 - Project19
//
//  Created by Jean-Yves Garcin on 24/06/2023.
//

import UIKit
import MobileCoreServices

class ScriptsTableViewController: UITableViewController {
    var items: [SiteScript] = []
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Scripts"
        load()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewScript))
        
        if pageURL == "" {
            if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
                if let itemProvider = inputItem.attachments?.first {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in

                        guard let itemDictionary = dict as? NSDictionary else { return }
                        guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }

                        self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                        self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.scriptName
        cell.detailTextLabel?.text = item.url?.absoluteString
        cell.accessoryType = .detailButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("accessoryButtonTappedForRowWith")
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "sb_Script") as? ActionViewController {
            
            vc.initialItem = items[indexPath.row]
            
            vc.didUpdateItem = {
                [weak self] (item) in
                // update
                self?.items[indexPath.row] = item
                self?.save()
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        
        let scriptItem = items[indexPath.row]
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript" : scriptItem.script ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }

    @objc func addNewScript() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "sb_Script") as? ActionViewController {
            vc.initialItem = SiteScript(urlPageTitle: pageTitle, url: pageURL)
            vc.didUpdateItem = {
                [weak self] (item) in
                // add
                self?.items.append(item)
                self?.save()
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(items) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "items")
            print("Saved data")
        } else {
            print("Failed to save items")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedItems = defaults.object(forKey: "items") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                items = try jsonDecoder.decode([SiteScript].self, from: savedItems)
                print("Loaded data")
            } catch {
                print("Failed to load items.")
            }
        }
    }
}
