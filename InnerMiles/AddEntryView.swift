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
    @State private var difficulty: Double = 3
    @State private var selectedMood: String = ""
    @State private var runType: String = ""
    let runTypes = ["Recovery", "Speed Run", "Long Run"]
    let emojis = ["😞", "😕", "😐", "🙂", "😄"]

    var body: some View {
        VStack(spacing: 25) {
            Text("How did you feel on your run today?")
                .font(.title2)
                .multilineTextAlignment(.center)

            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.largeTitle)
                        .padding(5)
                        .background(selectedMood == emoji ? Color.yellow.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedMood = emoji
                        }
                }
            }
            
            TextEditor(text: $reflectionText)
                .frame(height: 150)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Text("Type of run")
                .font(.headline)
            
            HStack {
                ForEach(runTypes, id: \.self) { type in
                    Text(type)
                        .padding()
                        .multilineTextAlignment(.center)
                        .background(runType == type ? Color.green : Color.green.opacity(0.2))
                        .foregroundColor(runType == type ? .white : .black)
                        .cornerRadius(10)
                        .onTapGesture {
                            runType = type
                        }
                }
            }
            
            Text("Difficulty Level")
                .font(.headline)

            Slider(value: $difficulty, in: 1...10, step: 1)

            Text("\(Int(difficulty))")
            
            Button {
                addEntry()
                dismiss()
            } label: {
                Text("Log")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.teal)
                    .cornerRadius(12)
            }
        }
        .padding()
    }

    private func addEntry() {
        guard !reflectionText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newEntry = RunEntry(context: viewContext)
        newEntry.date = Date()
        newEntry.reflection = reflectionText
        newEntry.mood = selectedMood
        newEntry.runType = runType
        newEntry.difficulty = difficulty

        try? viewContext.save()
    }
}
