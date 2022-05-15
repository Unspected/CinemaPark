//
//  DataPersistantManager.swift
//  Cinema Park
//
//  Created by Pavel Andreev on 5/12/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistantManager {
    
    enum DatabaseError: Error {
        case FailedToSaveData
        case FailedToFetchData
        case FailedToDeleteData
    }
    
    static let shared = DataPersistantManager()
    
    func downloadTitleWith(model:Title, complition: @escaping (Result<Void,Error> ) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.id = Int64(model.id)
        item.release_date = model.release_date
        item.vote_avarage = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            complition(.success(()))
        } catch {
            complition(.failure(DatabaseError.FailedToSaveData))
        }
    }
    
    func fetchingTitlesFromDataBase( complition: @escaping (Result<[TitleItem],Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            
            let titles = try context.fetch(request)
            complition(.success(titles))
            
        } catch {
            complition(.failure(DatabaseError.FailedToFetchData))
        }
    }
    
    func deleteTitileWith(model: TitleItem, complition: @escaping (Result<Void, Error> ) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        do {
            try context.save()
            complition(.success(()))
        } catch {
            complition(.failure(DatabaseError.FailedToDeleteData))
        }
        
    }
}
