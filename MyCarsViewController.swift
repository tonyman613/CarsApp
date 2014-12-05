//
//  MyCarsViewController.swift
//  CarsApp
//
//  Created by Tony's Mac on 11/21/14.
//  Copyright (c) 2014 DeAnza. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MyCarsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NSFetchedResultsControllerDelegate,UIGestureRecognizerDelegate {
    let identifier = "CarsCell"
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    var longPressTarget: (cell: CarsCVCell, indexPath: NSIndexPath)?
    
    @IBOutlet var carsCollectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var value = collectionView.frame.size.width - 10
        return CGSizeMake(value, value * 2 / 3)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var headerView = carsCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "customHeader", forIndexPath: indexPath) as CustomHeader
        headerView.titleLabel.text = "Cars"
        return headerView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)
        
        carsCollectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carsCollectionView!.dataSource = self
        carsCollectionView!.delegate = self
        carsCollectionView!.registerClass(CarsCVCell.self, forCellWithReuseIdentifier: identifier)
        carsCollectionView.clipsToBounds = false
        carsCollectionView!.backgroundColor = nil
        carsCollectionView!.alwaysBounceVertical = true
        
        animateCollectionViewAppearance()
        
        //navigationController?.hidesBarsOnSwipe = true
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler:");
        carsCollectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        longPressGestureRecognizer.delegate = self

    }
    
    // Long press gesture handler
    func longPressHandler(sender:UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            
            var tapLocation: CGPoint = sender.locationInView(carsCollectionView)
            let indexPath = carsCollectionView.indexPathForItemAtPoint(tapLocation)
            println("Long Pressed at: \(indexPath)")
            
            if (indexPath != nil) {
            
            let alert = UIAlertController(title: nil, message: "Do you want to delete this car?", preferredStyle: UIAlertControllerStyle.Alert)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
    
            presentViewController(alert, animated: true, completion: nil)
                
            }

        }
    }
    
    func animateCollectionViewAppearance() {
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: nil, animations: { () -> Void in
            self.carsCollectionView.contentOffset = CGPointMake(0, self.carsCollectionView.frame.size.height)
            }) { (finished: Bool) -> Void in
                if finished == true {
                    self.carsCollectionView.clipsToBounds = true
                }
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Cars")
        let sortDescriptor = NSSortDescriptor(key: "make", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionView
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.registerNib(UINib(nibName: "CarsCVCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as CarsCVCell
        
        // cell design(can change)
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowColor = UIColor.blueColor().CGColor;
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        cell.layer.shadowOpacity = 0.3
        
        let car = fetchedResultController.objectAtIndexPath(indexPath) as MyCars
        cell.ownerLabel.text = car.make + " " + car.model
        
        //cell.ownerLabel.text = car.valueForKey("make") as String?
        var imageFromModel: UIImage = UIImage(data: (car.valueForKey("carImage") as NSData))!
        cell.myCarsImageView.image = imageFromModel
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowCarDetail", sender: indexPath)
    }
    
    //Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCarDetail" {
            let car = fetchedResultController.objectAtIndexPath(sender as NSIndexPath!) as MyCars
            
            let carDetailView = segue.destinationViewController as AddCarsViewController
            carDetailView.title = car.valueForKey("make") as String?
            carDetailView.car = car
        } else if segue.identifier == "embedSegue" {
            var userCollectionView = segue.destinationViewController as UsersCollectionViewController
            let usersInDatabase = Owners.getUsersInDatabase(inManagedObjectContext: managedObjectContext!)!
            userCollectionView.users = usersInDatabase
        }
    }
}