//
//  DiscoverViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 12/29/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import SpriteKit
import FirebaseDatabase
import FirebaseAuth
import PopupDialog
import CoreLocation

class DiscoverViewController: UIViewController, SIFloatingCollectionSceneDelegate {
    
    let loginSegue = "loginSegue"
    
    //MARK: Firebase
    //Firebase Refs
    lazy var ref = FIRDatabase.database().reference(withPath: "opnPlaceID")
    lazy var usersRef = FIRDatabase.database().reference(withPath: "online")
    //Current Firebase User
    var currentUser : User!
    //MARK: DataSources
    var businesses : [Business] = []
    var placesDictionary : [String : [Business]] = [:]
    var menuNodesDataSource : [String] = []
    //MARK: SpriteKit BitMasks
    
    //MARK: Corelocation Elements
    var locationManager : CLLocationManager!
    var currentLat : CLLocationDegrees?
    var currentLong : CLLocationDegrees?
    
    //MARK: SpriteKit vars
    fileprivate var opnSKView: SKView!
    var floatingCollectionScene: BubblesScene!
    @IBOutlet weak var skContainerView: UIView!
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineMyCurrentLocation()
        
        //MARK: Firebase Listener for Businesses. Listen for add/removed/changed event to .value type
        ref.queryOrdered(byChild: "businessName").observe(.value, with: { snapshot in
            
            var newBusiness: [Business] = []

            for item in snapshot.children {
                let business = Business(snapshot: item as! FIRDataSnapshot)
                newBusiness.append(business)
                
                //Build menuNodesDataSource
                for item in business.businessTags {
                    if !self.menuNodesDataSource.contains(item) && item.containsEmoji {
                        self.menuNodesDataSource.append(item)
                        
                    }
                }
            }
            
            self.businesses = newBusiness
            
            self.placesDictionary = self.createEmojiBusinessDict(emojiArray: self.menuNodesDataSource, businessArray: self.businesses)
            
            self.showFullMenu()

        })
        
        //MARK: Firebase Listener for Users.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.currentUser.uid)
            currentUserRef.setValue(self.currentUser.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        setupSpriteKitScene()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }

    private func createEmojiBusinessDict(emojiArray: [String], businessArray: [Business]) -> [String: [Business]] {
        
//        let dictionary = businessArray.filter({ (business) -> Bool in
//            var bool : Bool?
//            if business.businessTags.contains() {
//                if menuNodesDataSource.contains(business.businessTags)
//            }
//            return bool!
//        })
        
        var dict: [String : [Business]] = [:]
        
        for emoji in emojiArray {
            var array = [Business]()
            for business in self.businesses {
                if business.businessTags.contains(emoji) {
                    array.append(business)
                }
            }
            dict[emoji] = array
        }

        return dict
        
    }
    
    func setupSpriteKitScene() {
        
        opnSKView = SKView(frame: skContainerView.bounds)
        opnSKView.backgroundColor = SKColor.cyan
        
        skContainerView.backgroundColor = .green
        skContainerView.addSubview(opnSKView)
        
        floatingCollectionScene = BubblesScene(size: skContainerView.bounds.size)
        floatingCollectionScene.scaleMode = .aspectFill
        floatingCollectionScene.backgroundColor = .darkGray
        //        let navBarHeight = navigationController!.navigationBar.frame.height
        //        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        //        floatingCollectionScene.topOffset = navBarHeight + statusBarHeight
        opnSKView.presentScene(floatingCollectionScene)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(DiscoverViewController.commitSelection)
        )
    
        floatingCollectionScene.floatingDelegate = self
        
        //SHOWING PHYSICS / FIELDS CAUSES MEMORY LEAKS!
        opnSKView.showsPhysics = false
        
    }
    
    
    @IBAction func addNode(_ sender: Any) {
    
        self.performSegue(withIdentifier: self.loginSegue, sender: nil)
        
    }
    
    @IBAction func removeNode(_ sender: Any) {
        floatingCollectionScene.removeFloatingNodeAtIndex(randomInt(0, max: floatingCollectionScene.floatingNodes.count))
        //update()
    }
    
    dynamic fileprivate func commitSelection() {
        floatingCollectionScene.performCommitSelectionAnimation()
    }
    
    func showFullMenu() {
        
        for string in menuNodesDataSource {
            
            guard let node = MenuNode.instantiate(category: string) else {
                print("Error for \(string) category!")
                return
            }
            
            if let category = node.category {
                if !floatingCollectionScene.currentMenu.contains(category) {
                
                let range : Range<Int> = Range(10...400)
                node.position = CGPoint(x: Int.random(range: range), y: Int.random(range: range))
                self.floatingCollectionScene.currentMenu.append(node.category!)
                self.floatingCollectionScene.addChild(node)
                
                print("node category is \(category)")
                    
                }

            }
        }
    }
    
    func showActionMenuForBubbleNode(node: BubbleNode) {
        
        let range : Range<Int> = Range(10...400)
        
        guard let phoneNode = PhoneNode.instantiate(node: node) else { return }
        phoneNode.position = CGPoint(x: Int.random(range: range), y: Int.random(range: range))
        self.floatingCollectionScene.addChild(phoneNode)
        
        guard let directionsNode = DirectionsNode.instantiate(node: node) else { return }
        directionsNode.position = CGPoint(x: Int.random(range: range), y: Int.random(range: range))
        self.floatingCollectionScene.addChild(directionsNode)
        
        guard let websiteNode = WebsiteNode.instantiate(node: node) else { return }
        if let url = websiteNode.url, !url.isEmpty {
                websiteNode.position = CGPoint(x: Int.random(range: range), y: Int.random(range: range))
                self.floatingCollectionScene.addChild(websiteNode)
        }
        
        for i in 0...2 {
            guard let phoneNode = PhoneNode.instantiate(name: actionTypes[i]) else { return }
            let range : Range<Int> = Range(10...400)
            phoneNode.position = CGPoint(x: Int.random(range: range), y: Int.random(range: range))
            self.floatingCollectionScene.addChild(phoneNode)
        }
    }
    
    func showFocusMenuForBubbleNode(node: BubbleNode) {
        //TO DO: Real error handling
        guard let selectedMenuNode = floatingCollectionScene.selectedMenuNode else { return }
        selectedMenuNode.strokeColor = node.strokeColor
        selectedMenuNode.labelNode.text = selectedMenuNode.category
        let boundingBox = selectedMenuNode.path?.boundingBox
        let radius = ((boundingBox?.size.width)! / 2.0) * 1.3
        selectedMenuNode.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        selectedMenuNode.physicsBody?.allowsRotation = false
        
        guard let menuCategory = selectedMenuNode.category else { return }
        
        guard let bizArrayForNode = self.placesDictionary[menuCategory] else { return }
        
        for biz in bizArrayForNode {
            if !floatingCollectionScene.currentBusinesses.contains(biz) {
                guard let businessNode = BubbleNode.instantiate(business: biz, menuNode: selectedMenuNode) else { return }
                businessNode.zPosition = selectedMenuNode.zPosition - 1
                self.floatingCollectionScene.currentBusinesses.append(biz)
                self.floatingCollectionScene.addNodeForMenuNode(selectedMenuNode, childNode: businessNode)
            }
        }
        
    }
    
    func showFocusMenuForMenuNode(node: MenuNode) {
        
        guard let menuCategory = node.category else { return }
        
        guard let bizArrayForNode = self.placesDictionary[menuCategory] else { return }
        
        for biz in bizArrayForNode {
            if !floatingCollectionScene.currentBusinesses.contains(biz) {
                guard let businessNode = BubbleNode.instantiate(business: biz, menuNode: node) else { return }
                self.floatingCollectionScene.currentBusinesses.append(biz)
                self.floatingCollectionScene.addNodeForMenuNode(node, childNode: businessNode)
            }
        }

        
    }
    
    func showCurrentMenu() {
        
        for string in menuNodesDataSource {
            
            guard let node = MenuNode.instantiate(category: string) else {
                print("Error for \(string) category!")
                return
            }
            if let category = node.category {
                if floatingCollectionScene.currentMenu.contains(category) && !floatingCollectionScene.menuNodeWithCategoryExists(node: node) {
                    
                    let range : Range<Int> = Range(10...400)
                    node.position = CGPoint(x: Int.random(range: range), y: Int.random(range: range))
                    self.floatingCollectionScene.addChild(node)
                    
                    print("node category is \(category)")
                    
                }
                
            }
        }
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

extension DiscoverViewController {
    
    
    func floatingScene(_ scene: SIFloatingCollectionScene, didSelectFloatingNodeAtIndex index: Int) {
        
        print("didSelect node at index \(index)")
        
        guard let nodeAtIndex = floatingCollectionScene.floatingNodes[index] as? SIFloatingNode else { return }
        
        
        //MARK: Website Node Selected
        if let node = nodeAtIndex as? WebsiteNode {
            guard let nodeUrl = node.url else { return }
            
            if let checkURL = URL(string: nodeUrl) {
                UIApplication.shared.open(checkURL, options: [:], completionHandler: nil)
            } else {
                print("Invalid URL")
            }
            
        }
        
        //MARK: Directions Node Selected
        if let node = nodeAtIndex as? DirectionsNode {
                
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=\(currentLat!),\(currentLong!)&daddr=\(node.latitude!),\(node.longitude!)&directionsmode=transit")!
                    
                )
            } else {
                print("Can't use comgooglemaps://");
            }
            
        }
        
        //MARK: Phone node Selected
        if let node = nodeAtIndex as? PhoneNode {
            
            guard let digits = node.phoneNumber else { return } //Get Digits 😜
            
            let numOnly = String(digits.characters.filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
            
            if let phoneCallURL = NSURL(string: "tel:\(numOnly)") {
                let application = UIApplication.shared
                if application.canOpenURL(phoneCallURL as URL) {
                    application.openURL(phoneCallURL as URL)
                }
                else{
                    print("failed")
                }
            }
            
        }
        
        //MARK: Bubble node Selected
        if let node = nodeAtIndex as? BubbleNode {
            
            //TO DO: Add real error handling
            guard let parentNode = floatingCollectionScene.selectedMenuNode else {
                return
            }

            parentNode.strokeColor = UIColor.clear
            parentNode.labelNode.text = ""
            parentNode.physicsBody = nil
            floatingCollectionScene.removeNonSelectedNodes()

            node.removeAllActions()
            
            node.run(action: floatingCollectionScene.centerNodeAction(node: node), withKey: "centerChild", optionalCompletion: {
                
                guard let biz = node.business else { return }
                let open = biz.isOpen
                switch open {
                case true:
                    self.headlineLabel.text = "\(biz.businessName) is open until \(biz.opnTil)"
                case false:
                    self.headlineLabel.text = "\(biz.businessName) is closed, but will be open again at \(biz.nxtOpn)"
                }
                
                self.showActionMenuForBubbleNode(node: node)
            
            })
            
        }
        
        //MARK: Menu node selected
        //NOTE: This code block must be executed last due to removal of Nodes... error with array indexes will result otherwise!
        if let node = nodeAtIndex as? MenuNode {
            
            floatingCollectionScene.selectedMenuNode = node
            
            floatingCollectionScene.removeNonSelectedNodes()
            node.removeAllActions()
            node.run(action: floatingCollectionScene.centerNodeAction(node: node), withKey: "centerNode", optionalCompletion: {
                
                self.showFocusMenuForMenuNode(node: node)
                
//                //TO DO: Real error handling
//                guard let menuCategory = node.category else { return }
//                
//                guard let bizArrayForNode = self.placesDictionary[menuCategory] else { return }
//                
//                for biz in bizArrayForNode {
//                    guard let businessNode = BubbleNode.instantiate(business: biz, menuNode: node) else { return }
//                    self.floatingCollectionScene.addNodeForMenuNode(node, childNode: businessNode)
//                }
                
            })
            
        }
        
    }
    
    func floatingScene(_ scene: SIFloatingCollectionScene, didDeselectFloatingNodeAtIndex index: Int) {
        
        if let node = floatingCollectionScene.floatingNodes[index] as? BubbleNode {
            //remove business specific elements
            self.floatingCollectionScene.removeNodesOfType(nodeType: PhoneNode.self)
            self.floatingCollectionScene.removeNodesOfType(nodeType: DirectionsNode.self)
            self.floatingCollectionScene.removeNodesOfType(nodeType: WebsiteNode.self)
            //show businesses that were removed
            showFocusMenuForBubbleNode(node: node)
            
            //show menu node that was removed
            
        }
        //MARK: Menu node deselected
        if let node = floatingCollectionScene.floatingNodes[index] as? MenuNode {
            
            //TO DO: Real error handling
            
            //currentlyUnused//node.physicsBody?.isDynamic = true
            
            floatingCollectionScene.removeChildrenFromMenuNode(node)
            showFullMenu()
            
            
        }

    }
    
    func floatingScene(_ scene: SIFloatingCollectionScene, didRemoveFloatingNodeAtIndex index: Int) {
        print("didRemove node at index \(index)")
    }
    
    func floatingScene(_ scene: SIFloatingCollectionScene, startedRemovingOfFloatingNodeAtIndex index: Int) {
        print("startedRemoving node at index \(index)")
    }
    
    func floatingScene(_ scene: SIFloatingCollectionScene, canceledRemovingOfFloatingNodeAtIndex index: Int) {
        print("canceledRemoving node at index \(index)")
    }
  
    
    
    
//    func floatingScene(_ scene: SIFloatingCollectionScene, shouldRemoveFloatingNodeAtIndex index: Int) -> Bool {
//        print("shouldRemove node at index \(index)")
//        return true
//    }
//
//    func floatingScene(_ scene: SIFloatingCollectionScene, shouldSelectFloatingNodeAtIndex index: Int) -> Bool {
//        print("shouldSelect node at index \(index)")
//    }
//    
//    func floatingScene(_ scene: SIFloatingCollectionScene, shouldDeselectFloatingNodeAtIndex index: Int) -> Bool {
//        print("shouldDeselect node at index \(index)")
//    }
    
}

//MARK: Popover
extension DiscoverViewController {
    
    func showPopoverForBusiness(_ business: Business) {
        
        let businessVc = ModalBusinessViewController(nibName: "ModalBusinessViewController", bundle: nil)
        
        let popup = PopupDialog(viewController: businessVc,
                                buttonAlignment: .vertical,
                                transitionStyle: .fadeIn,
                                gestureDismissal: true) {
                                    print("done!")
        }
        
        let vc = popup.viewController as! ModalBusinessViewController
        vc.businessName.text = business.businessName
        
        let mondayOpen = firebaseTimeStringToDate( business.mondayOpen)
        let mondayClose = firebaseTimeStringToDate( business.mondayClose)
        let tuesdayOpen = firebaseTimeStringToDate( business.tuesdayOpen)
        let tuesdayClose = firebaseTimeStringToDate( business.tuesdayClose)
        let wednesdayOpen = firebaseTimeStringToDate( business.wednesdayOpen)
        let wednesdayClose = firebaseTimeStringToDate( business.wednesdayClose)
        let thursdayOpen = firebaseTimeStringToDate(business.thursdayOpen)
        let thursdayClose = firebaseTimeStringToDate( business.thursdayClose)
        let fridayOpen = firebaseTimeStringToDate(business.fridayOpen)
        let fridayClose = firebaseTimeStringToDate( business.fridayClose)
        let saturdayOpen = firebaseTimeStringToDate( business.saturdayOpen)
        let saturdayClose = firebaseTimeStringToDate( business.saturdayClose)
        let sundayOpen = firebaseTimeStringToDate( business.sundayOpen)
        let sundayClose = firebaseTimeStringToDate( business.sundayClose)
        
        vc.mondayOpen.text = mondayOpen.stringify() == mondayClose.stringify() ? "CLOSED!" : "\(mondayOpen.stringify()) - \(mondayClose.stringify())"
        vc.tuesdayOpen.text = tuesdayOpen.stringify() == tuesdayClose.stringify() ? "CLOSED!" :"\(tuesdayOpen.stringify()) - \(tuesdayClose.stringify())"
        vc.wednesdayOpen.text = wednesdayOpen.stringify() == wednesdayClose.stringify() ? "CLOSED!" :"\(wednesdayOpen.stringify()) - \(wednesdayClose.stringify())"
        vc.thursdayOpen.text = thursdayOpen.stringify() == thursdayClose.stringify() ? "CLOSED!" :"\(thursdayOpen.stringify()) - \(thursdayClose.stringify())"
        vc.fridayOpen.text = fridayOpen.stringify() == fridayClose.stringify() ? "CLOSED!" :"\(fridayOpen.stringify()) - \(fridayClose.stringify())"
        vc.saturdayOpen.text = saturdayOpen.stringify() == saturdayClose.stringify() ? "CLOSED!" :"\(saturdayOpen.stringify()) - \(saturdayClose.stringify())"
        vc.sundayOpen.text = sundayOpen.stringify() == sundayClose.stringify() ? "CLOSED!" :"\(sundayOpen.stringify()) - \(sundayClose.stringify())"
        
        let overlayAppearance = PopupDialogOverlayView.appearance()
        
        overlayAppearance.opacity = 0.50
        overlayAppearance.blurEnabled = false
        
        // Present dialog
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // in half a second...
            self.present(popup, animated: true, completion: nil)
        }
        
    }

    
}

extension DiscoverViewController {
    func update() {
        headlineLabel.text = ("There are \(floatingCollectionScene.floatingNodes.count) businesses OPN within 3 mi. of you")
    }
}

//MARK: Location Manager Delegate Methods
extension DiscoverViewController: CLLocationManagerDelegate {
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        
        currentLat = userLocation.coordinate.latitude
        currentLong = userLocation.coordinate.longitude
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}
