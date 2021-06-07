//
//  DBHelper.swift
//  MyRecipe
//
//  Created by Tim Sun on 2/6/21.
//

import Foundation
import SQLite3
//adapted from pushpendra saini youtube channel
class DBHelper{
    var db: OpaquePointer?
    var path: String = "db.sqlite"
    init(){
        self.db = createDB()
        self.createTable()
        self.createTableHistory()
    }
    //create db for use, check if it is created successfully
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            print("Failed to create DB")
            return nil
        }else{
            print("Database created with path \(path)")
            return db
        }
    }
    
    func createTableHistory(){
        let query = "CREATE TABLE IF NOT EXISTS recipeHistory2(name TEXT NOT NULL, date TEXT NOT NULL, comment TEXT NOT NULL, rating INT NOT NULL);"
        var createTable : OpaquePointer? = nil
        
        if sqlite3_prepare(self.db, query, -1, &createTable, nil) == SQLITE_OK{
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("Table created successfully")
            }else{
                //if sql is excuted correctly
                print("Failed to create table")
            }
        }else{
            //fail to prepare
            print("Preparation fail")
        }
    }
    
    func createTable(){
        let query = "CREATE TABLE IF NOT EXISTS recipe2(name TEXT NOT NULL, cooktime TEXT NOT NULL, ingredients TEXT NOT NULL, steps TEXT NOT NULL, difficulty INT NOT NULL, PRIMARY KEY (name));"
        var createTable : OpaquePointer? = nil
        
        if sqlite3_prepare(self.db, query, -1, &createTable, nil) == SQLITE_OK{
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("Table created successfully")
            }else{
                //if sql is excuted correctly
                print("Failed to create table")
            }
        }else{
            //fail to prepare
            print("Preparation fail")
        }
    }
    
    //insert history after clicking finish button
    func insertHistory(name: String, date: String, comment: String, rating: Int){
        let query = "INSERT INTO recipeHistory2(name, date, comment, rating) VALUES ('\(name)', '\(date)', '\(comment)', '\(rating)');"
        var statement : OpaquePointer? = nil
        if (sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK){
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Insertion complete")
            }else{
                print("Insertion fail")
            }
            
        }else{
            print("Query failed")
        }
    }
    
    
    func insert(name: String, cooktime: String, ingredients: String, steps: String, difficulty: Int){
        let query = "INSERT INTO recipe2 (name, cooktime, ingredients, steps, difficulty) VALUES ('\(name)', '\(cooktime)', '\(ingredients)', '\(steps)', '\(difficulty)');"
        var statement : OpaquePointer? = nil
        if (sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK){
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            //sqlite3_bind_int(statement,1, Int32(int))
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Insertion complete")
            }else{
                print("Insertion fail")
            }
            
        }else{
            print("Query failed")
        }
    }
    
    func read() -> [Recipe]{
        var list = [Recipe]()
        let query = "SELECT * FROM recipe2"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let name = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let cooktime = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let ingredients = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let steps = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let difficulty = Int(sqlite3_column_int(statement, 4))
                let recipe = Recipe()
                recipe.name = name
                recipe.cooktime = cooktime
                recipe.ingredients = ingredients
                recipe.steps = steps
                recipe.difficulty = difficulty
                list.append(recipe)
            }
        }
        return list
    }
    
    func readHistory() -> [History]{
        var list = [History]()
        let query = "SELECT * FROM recipeHistory2"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let name = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                //let date = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(statement, 1))
                let date = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let comment = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let rating = Int(sqlite3_column_int(statement, 3))
                let history = History()
                history.name = name
                history.date = date
                history.comment = comment
                history.rating = rating
                list.append(history)
            }
        }
        return list
    }
    
    //delete recipe by name
    func delete(name: String){
        let query = "DELETE FROM recipe2 WHERE name = '\(name)'"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Successfully delete data")
            }
            else{
                print("Error deleting data")
            }
        }
    }
    
}
