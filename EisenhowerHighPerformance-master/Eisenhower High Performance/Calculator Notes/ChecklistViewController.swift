

import UIKit
import SwiftReorder
import GoogleMobileAds
import StoreKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate, GADBannerViewDelegate {
    var bannerView: GADBannerView!
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    @IBOutlet weak var navegationTitle: UINavigationItem!
    var checklist: Checklist!
    var dataModel: DataModel!
    
    @IBOutlet weak var editModeButton: UIBarButtonItem!
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        if(self.isEditing) {
            self.setEditing(false, animated: true)
            editModeButton.tintColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
            rateApp()
        }  else {
            self.setEditing(true, animated: true)
            editModeButton.tintColor = UIColor.red
        }
    }

    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
        if(RazeFaceProducts.store.isProductPurchased("NoAds.Cronos") || (UserDefaults.standard.object(forKey: "NoAds.Cronos") != nil)) {
            if let banner = bannerView {
                banner.removeFromSuperview()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        for list in dataModel.lists {
            if(self.navigationController?.title == list.name) {
                checklist = list
            }
        }
        
        if(checklist == nil) {
            print("not found")
            checklist = dataModel.lists[0]
        }
        
        self.navegationTitle.title = checklist.name
        
        tableView.reorder.delegate = self
        tableView.reorder.cellScale = 1
        tableView.reorder.shadowOpacity = 1
        tableView.reorder.shadowRadius = 20
        
        switch checklist.name {
        case "Important & Urgent":
            self.navigationController?.navigationBar.backgroundColor = UIColor.red
            
        case "Important & Not Urgent":
            self.navigationController?.navigationBar.backgroundColor = UIColor.yellow
            
        case "Not Important & Urgent":
            self.navigationController?.navigationBar.backgroundColor = UIColor.green
            
        default:
            self.navigationController?.navigationBar.backgroundColor = UIColor.black
        }
        
        
        if(RazeFaceProducts.store.isProductPurchased("NoAds.Cronos") || (UserDefaults.standard.object(forKey: "NoAds.Cronos") != nil)) {
            if let banner = bannerView {
                banner.removeFromSuperview()
            }
        }
        else {

            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addBannerViewToView(bannerView)

            bannerView.adUnitID = "ca-app-pub-8858389345934911/2246971036"
            bannerView.rootViewController = self

            bannerView.load(GADRequest())
            bannerView.delegate = self    
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self //接收delegate
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        if item.checked {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        } else {
            cell.backgroundColor = UIColor.white
            cell.backgroundColor?.withAlphaComponent(0)
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = "\(item.text)"
        
        let label2 = cell.viewWithTag(123321)!
        StyleClass().cropBounds(viewlayer: label2.layer, cornerRadius: 5)
        StyleClass().applicShadow(Layer: label2.layer)
        
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension ChecklistViewController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data model
        print("destinationIndexPath", destinationIndexPath)
        print("sourceIndexPath", sourceIndexPath)
        let item = checklist.items[sourceIndexPath[1]]
        checklist.items.remove(at: sourceIndexPath[1])
        checklist.items.insert(item, at: Int(destinationIndexPath[1]))
    }
}
