//
//  RatingCoreData.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/23/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import CoreData

class RatingCoreData: NSObject, NSFetchedResultsControllerDelegate{
    var location: Location?
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Rating")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
//        if(self.location != nil){
            fetchRequest.predicate = NSPredicate(format: "location == %@", self.location!)
//        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func loadRatingForLocation(location: Location) -> Rating?{
        self.location = location
        var rating: Rating? = nil
        do{
            try fetchedResultsController.performFetch()
        }catch{}
        fetchedResultsController.delegate = self
        
        for var index = 0; index < fetchedResultsController.sections![0].numberOfObjects; index++ {
            guard let item = fetchedResultsController.sections![0].objects?[index] as? Rating else {
                continue
            }
           
//            if(item.location.id == location.id){
//                rating = item
//                break
//            }
            rating = item
        }

        return rating
    }
}