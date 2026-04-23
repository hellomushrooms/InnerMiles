//
//  ContentView.swift
//  InnerMiles
//
//  Created by Disha Kurkuri on 23/04/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RunEntry.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<RunEntry>
    
    @State private var reflectionText = ""
    @State private var showAddView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(item.reflection ?? "No Reflection")
                                .font(.title2)

                            if let date = item.date {
                                Text(date, formatter: itemFormatter)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    } label: {
                        Text(item.reflection ?? "No Reflection")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddView = true
                    } label: {
                        Label("Add Entry", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddView) {
            AddEntryView()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = RunEntry(context: viewContext)
            newItem.date = Date()
            newItem.reflection = reflectionText
            reflectionText = ""

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
