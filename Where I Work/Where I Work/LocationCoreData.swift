//
//  LocationCoreData.swift
//  Where I Work
//
//  Created by Sean Wernimont on 3/10/16.
//  Copyright © 2016 Just One Guy. All rights reserved.
//

import Foundation
import CoreData

class LocationCoreData: NSObject, NSFetchedResultsControllerDelegate{
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Location")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "businessName", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    func loadSavedLocations() -> [Location]{
        var locations: [Location] = []
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        fetchedResultsController.delegate = self
        
        for index in 0 ..< fetchedResultsController.sections![0].numberOfObjects {
            guard let item = fetchedResultsController.sections![0].objects?[index] as? Location else {
                continue
            }
            locations.append(item)
        }
        
        return locations
    }
}