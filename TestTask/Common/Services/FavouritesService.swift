//
//  FavouritesService.swift
//  TestTask
//
//  Created by Аскар on 5/15/19.
//  Copyright © 2019 askar.ulubayev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct FavouritesService {
    
    var realm = try! Realm()
    
    static let shared = FavouritesService()
    
    private init() { }
    
    func add(_ object: MovieIDForRealm) {
        let newObject = MovieIDForRealm(value: object, schema: .partialPrivateShared())
        do {
            try realm.write {
                print("added new recipe !!!")
                realm.add(newObject, update: true)
            }
        } catch {
            print("Exception realm !!!  \(error.localizedDescription)")
        }
    }
    
    func remove(_ object: MovieIDForRealm) {
        do {
            try realm.write {
                let itemToRemove = realm.objects(MovieIDForRealm.self).filter("id == %@", object.id ?? "").first
                if let item = itemToRemove {
                    realm.delete(item)
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func contains(recipe: MovieIDForRealm) -> Bool {
        guard let id = recipe.id else { return false }
        let item = realm.objects(MovieIDForRealm.self).filter("id == %@", id).first
        return item != nil
    }
}
