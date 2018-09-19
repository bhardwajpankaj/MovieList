//
//  CoreDataManager.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum MyError: Error {
    case FoundNil(String)
}

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {} // Prevent clients from creating another instance.
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MovieList")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func delete(query: String) {
        
        /*get reference of managed object context*/
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*init fetch request*/
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        
        /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
        fetchRequest.predicate = NSPredicate(format: "queryString == %@" ,query)
        do {
            
            /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
            let item = try managedContext.fetch(fetchRequest)
            for i in item {
                
                /*call delete method(aManagedObjectInstance)*/
                /*here i is managed object instance*/
                managedContext.delete(i)
                
                /*finally save the contexts*/
                try managedContext.save()
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    /*delete*/
    func delete(movieEntity : MovieEntity){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do {
            if movieEntity.queryString != nil {
                managedContext.delete(movieEntity)
            }else
            {
                throw MyError.FoundNil("models")
            }
            
        } catch {
            // Do something in response to error condition
            print(error)
        }
        
        do {
            try managedContext.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    /*Insert*/
    func insertMovie(name: String)->MovieEntity? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*
         Retrieving an Entity with a Given Name here Movie
         */
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity",
                                                in: managedContext)!
        
        /*
         Initializes a managed object and inserts it into the specified managed object context.
         
         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let movie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        movie.setValue(name, forKeyPath: "queryString")
        
        /*
         You commit your changes to movie and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try managedContext.save()
            return movie as? MovieEntity
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchAllMovies() -> [MovieEntity]?{
        
        /*Before you can do anything with Core Data, you need a managed object context. */
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
         
         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Movie entities.
         */
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        
        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let people = try managedContext.fetch(fetchRequest)
            return people as? [MovieEntity]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
