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
    
    var groupedEntries: [String: [RunEntry]] {
        Dictionary(grouping: items) { item in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: item.date ?? Date())
        }
    }
    
    var sortedMonths: [String] {
        groupedEntries.keys.sorted { a, b in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let dateA = formatter.date(from: a) ?? Date()
            let dateB = formatter.date(from: b) ?? Date()
            return dateA > dateB
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 12) {
                        Spacer()
                        Text("Welcome back, \nDIKU!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        Spacer()

                        HStack{
                            Spacer()
                            Button {
                                showAddView = true
                            } label: {
                                Text("Log a run")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: 140)
                                    .background(Color.teal)
                                    .cornerRadius(20)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    Spacer()

                    Text("Recent Runs")
                        .font(.title2)
                        .fontWeight(.semibold)

                    ForEach(sortedMonths, id: \.self) { month in
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text(month)
                                .font(.headline)
                                .foregroundColor(.gray)

                            ForEach(groupedEntries[month] ?? []) { item in
                                
                                let mood = item.mood ?? "🙂"
                                let runType = item.runType ?? "Run"

                                NavigationLink {
                                    Text("Detail View Placeholder")
                                } label: {
                                    HStack {
                                        Text(mood)
                                            .font(.title2)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(runType)
                                                .font(.headline)

                                            if let date = item.date {
                                                Text(date, formatter: itemFormatter)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }

                                        Spacer()
                                    }
                                    .padding()
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
                .padding()
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
