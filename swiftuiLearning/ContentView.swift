//
//  ContentView.swift
//  swiftuiLearning
//
//  Created by Alex Babich on 21.06.2020.
//  Copyright © 2020 Alex Babich. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var potatoes: [NSManagedObject] = []
    @State var newPotatoString = ""
    @State var modifyingPotato: String? = nil
    @State var showSheet = false
    
    var body: some View {
        
        VStack {
            VStack {
                TextField("What is your favorite potato", text: $newPotatoString)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Button(action: {
                    self.addNewPotato()
                }) {
                    Text("Add new potato")
                }
            }
            .padding()
            .background(Color.init(white: 0.9))
            .cornerRadius(10)
            .padding()
            
            ForEach(potatoes, id: \.self) { thisPotato in
                
                Button(action: {
                    self.modifyingPotato = (thisPotato as? Potato)?.stringAttr ?? "potato string error"
                    self.newPotatoString = (thisPotato as? Potato)?.stringAttr ?? "potato string error"
                    self.showSheet = true
                }) {
                    Text((thisPotato as? Potato)?.stringAttr ?? "potato string error")
                        .background(Color.yellow)
                        .frame(height: 20)
                        .padding(5)
                }
                .sheet(isPresented: self.$showSheet) {
                    VStack {
                        TextField("Give this potato some value", text: self.$newPotatoString)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(5)
                        
                        HStack {
                            Button(action: {
                                if let potatoToModify = self.modifyingPotato {
                                    self.deletePotato(thisPotatoString: potatoToModify)
                                }
                            }) {
                                Text("Delete potato")
                            }
                            
                            Button(action: {
                                if let potatoToModify = self.modifyingPotato {
                                    self.updatePotato(currentPotatoString: potatoToModify, newPotatoString: self.$newPotatoString.wrappedValue)
                                }
                            }) {
                                Text("Update potato")
                            }
                        }
                    }
                    .padding()
                    .background(Color.init(white: 0.9))
                    .cornerRadius(10)
                    .padding()
                }

                
            }
        }
        .onAppear() {
            self.loadPotatos()
        }
    }
    
    func addNewPotato() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Potato", in: managedContext)!
        
        let newPotato = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newPotato.setValue($newPotatoString, forKey: "stringAttr")
        
        do {
            try managedContext.save()
            
            print("saved successfully --- \($newPotatoString.wrappedValue)")
            
            self.loadPotatos()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadPotatos() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Potato")
        
        do {
            potatoes = try managedContext.fetch(fetchRequest)
            self.showSheet = false
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updatePotato(currentPotatoString: String, newPotatoString: String) {
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Potato")
        fetchRequest.predicate = NSPredicate(format: "stringAttr = %@", currentPotatoString)
        
        do {
            let fetchReturn = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = fetchReturn[0] as! NSManagedObject
            objectUpdate.setValue(newPotatoString, forKey: "stringAttr")
            
            do {
                try managedContext.save()
                print("update successfully")
                self.loadPotatos()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deletePotato(thisPotatoString: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Potato")
        fetchRequest.predicate = NSPredicate(format: "stringAttr = %@", thisPotatoString)
        
        do {
            let fetchReturn = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = fetchReturn[0] as! NSManagedObject
            managedContext.delete(objectUpdate)
            
            do {
                try managedContext.save()
                print("delete successfully")
                self.loadPotatos()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
