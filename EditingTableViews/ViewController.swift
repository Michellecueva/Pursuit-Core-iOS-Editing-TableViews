import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shoppingItemsTableView: UITableView!
    
    @IBOutlet weak var toggleEditMode: UIButton!
    
    
    var shoppingItems = [ShoppingItem]()
    
    var addedShoppingItems  = [ShoppingItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShoppingItems()
        configureShoppingItemsTableView()
        shoppingItemsTableView.isEditing = false

    }
    
    
    @IBAction func toggleEditMode(_ sender: UIButton) {
        switch shoppingItemsTableView.isEditing {
        case true:
            shoppingItemsTableView.setEditing(false, animated: true)
            sender.setTitle("Edit", for: .normal)
        case false:
            shoppingItemsTableView.setEditing(true, animated: false)
            sender.setTitle("Done", for: .normal)
        }
    }
    
    @IBAction func cancelUnwind(segue: UIStoryboardSegue) {
        return
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        guard let addItemVC =  segue.source as? AddItemViewController else {fatalError("Not found")
            
        }
            
        guard let textName = addItemVC.nameLabel.text, let priceName = addItemVC.priceLabel.text, let priceAsDouble = Double(priceName) else {
            fatalError()
            
        }
        
        let newItem = ShoppingItem(name: textName, price: priceAsDouble)
        
        let lastIndex = shoppingItemsTableView.numberOfRows(inSection: 0)
        
        let lastIndexPath = IndexPath(row: lastIndex, section: 0)

        addedShoppingItems.append(newItem)
        shoppingItemsTableView.insertRows(at: [lastIndexPath], with: .automatic)
        
    }
    
    private func loadShoppingItems() {
        let allItems = ShoppingItemFetchingClient.getShoppingItems()
        shoppingItems = allItems
    }
    
    private func configureShoppingItemsTableView() {
        shoppingItemsTableView.dataSource = self
        shoppingItemsTableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addedShoppingItems.count
        } else {
            return shoppingItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        if indexPath.section == 0 {
            let shoppingItem = addedShoppingItems[indexPath.row]
            cell.textLabel?.text = shoppingItem.name
            cell.detailTextLabel?.text = shoppingItem.price.description
        } else {
            let shoppingItem = shoppingItems[indexPath.row]
            cell.textLabel?.text = shoppingItem.name
            cell.detailTextLabel?.text = shoppingItem.price.description
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Purchased Items"
        } else {
            return "Unpurchased Items"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch editingStyle {
            case .delete:
                addedShoppingItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default: break
            }
        } else {
            switch editingStyle {
            case .delete:
                shoppingItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let lastItem = addedShoppingItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            shoppingItems.append(lastItem)
           
            let lastIndex = shoppingItemsTableView.numberOfRows(inSection: 1)
            
            let lastIndexPath = IndexPath(row: lastIndex, section: 1)
            
            
            shoppingItemsTableView.insertRows(at: [lastIndexPath], with: .automatic)
        } else {
        
            let lastItem = shoppingItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            addedShoppingItems.append(lastItem)
            
            let lastIndex = shoppingItemsTableView.numberOfRows(inSection: 0)
            
            let lastIndexPath = IndexPath(row: lastIndex, section: 0)
            
            
            shoppingItemsTableView.insertRows(at: [lastIndexPath], with: .automatic)
            
        }
    }
    
    
}

