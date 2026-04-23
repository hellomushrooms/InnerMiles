//
//  AddEntryView.swift
//  InnerMiles
//
//  Created by Disha Kurkuri on 24/04/26.
//

import SwiftUI
import CoreData

struct AddEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    @State private var reflectionText = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("How was your run?")
                .font(.title)

            TextField("Type here...", text: $reflectionText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Save") {
                addEntry()
                dismiss()
            }
        }
        .padding()
    }

    private func addEntry() {
        let newEntry = RunEntry(context: viewContext)
        newEntry.date = Date()
        newEntry.reflection = reflectionText

        try? viewContext.save()
    }
}
