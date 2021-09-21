//
//  ViewController.swift
//  Lab_Assignment_A2
//
//  Created by Janakiram Gupta on 19/09/21.
//

import UIKit

class ProductProviderListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private var productData = [Product]()
    var providerData = [[String : String]]()
    var keysArray = [String]()
    var filteredCandies = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Providers"
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.done, target: self, action: #selector(editButtonPressed))
        
         // Search Controller
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Type here to search products")
        
        searchController.searchBar.tintColor = UIColor.black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.navigationController?.isToolbarHidden = false
        
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(title: "Show Products", style: UIBarButtonItem.Style.done, target: self, action: #selector(providerButtonPressed))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(addButtonPressed))
        )
        toolbarItems = items
        UINavigationBar.appearance().barTintColor = UIColor.black
                
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        getAllItems()
    }
    
    @objc private func providerButtonPressed() {
       
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func addButtonPressed() {
     
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.flag = "Add"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        self.navigationController?.isToolbarHidden = false
        getAllItems()
    }
    
    @objc private func editButtonPressed() {
            navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonPressed))
            tableView.isEditing = true
    }
    
    @objc private func doneButtonPressed() {
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.done, target: self, action: #selector(editButtonPressed))
            tableView.isEditing = false
    }
    //Core Data
    func getAllItems() {
        
        do {
            productData = try context.fetch(Product.fetchRequest())
            
            var valuseDict = [String:String]()
            var dataArry = [[String:String]]()
            for item in productData {
                valuseDict["productid"] = "\(item.productid)"
                valuseDict["productname"] = item.productname
                valuseDict["productprice"] = item.productprice
                valuseDict["productprovider"] = item.productprovider
                valuseDict["productdescription"] = item.productdescription
                dataArry.append(valuseDict)
            }
            
            let providerDataArry = Dictionary(grouping: dataArry, by: { $0["productprovider"]! } )
            //print(providerDataArry)
            
            keysArray = Array(providerDataArry.keys)
            // print(keysArray)
            
            
            
            DispatchQueue.main.async {
                self.filteredCandies = self.keysArray
                self.tableView.reloadData()
            }
        } catch {
            //error
            print(error)
        }
    }
    
    func removeDuplicateElements(post: [Product]) -> [Product] {
        var uniquePosts = [Product]()
        for post in productData {
            if !uniquePosts.contains(where: {$0.productprovider == post.productprovider }) {
                uniquePosts.append(post)
            }
        }
        return uniquePosts
    }
    
    // logic for deleting any product
    func deleteItem(item: Product) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
            print(error)
        }
    }
    
    // creating item logic starts here
    func createProductItem(productId: Int, productName: String, productDescription: String, productPrice: String, productProvider: String) {
        
        let newItem = Product(context: context)
        newItem.productid = Int64(productId)
        newItem.productname = productName
        newItem.productprice = productPrice
        newItem.productprovider = productProvider
        newItem.productdescription = productDescription
        
        do {
            try context.save()
            getAllItems()
        } catch {
            //error
            print(error)
        }
    }
    
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCandies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredCandies[indexPath.row]
        
        cell.detailTextLabel?.text = "1"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       // Return false if you do not want the specified item to be editable.
       return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
            
            filteredCandies.remove(at: indexPath.row)
            
            // Delete the row from the data source
            //   tableView.deleteRows(at: [indexPath], with: .fade)
            
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }
}

extension ProductProviderListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredCandies = keysArray
        } else {
            // Filter the results
            filteredCandies = keysArray.filter {
                $0.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        }
        self.tableView.reloadData()
    }
   
}

extension Array {
    func unique(selector:(Element,Element)->Bool) -> Array<Element> {
        return reduce(Array<Element>()){
            if let last = $0.last {
                return selector(last,$1) ? $0 : $0 + [$1]
            } else {
                return [$1]
            }
        }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

