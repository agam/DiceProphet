//
//  ContentView.swift
//  Dice Prophet
//
//  Created by Agam Brahma on 9/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var guesses: [Guess]
    
    @State private var currentDice = 1
    @State private var userGuess: Int?
    @State private var showResult = false
    @State private var isCorrect = false

    var body: some View {
        NavigationView {
            VStack {
                // Dice image
                Image(systemName: "die.face.\(currentDice)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                
                // User guess buttons
                HStack {
                    ForEach(1...6, id: \.self) { number in
                        Button(action: {
                            userGuess = number
                        }) {
                            Image(systemName: "die.face.\(number)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(userGuess == number ? .blue : .gray)
                        }
                    }
                }
                .padding()
                
                // Roll button
                Button("Roll") {
                    rollDice()
                }
                .disabled(userGuess == nil)
                .padding()
                
                // Result display
                if showResult {
                    Text(isCorrect ? "Correct!" : "Incorrect!")
                        .font(.headline)
                        .foregroundColor(isCorrect ? .green : .red)
                        .padding()
                }
                
                // History view
                NavigationLink("View History") {
                    HistoryView(guesses: guesses)
                }
                .padding()
            }
            .navigationTitle("Dice Prophet")
        }
    }

    private func rollDice() {
        guard let userGuess = userGuess else { return }
        
        currentDice = Int.random(in: 1...6)
        isCorrect = userGuess == currentDice
        showResult = true
        
        // Save the guess
        let newGuess = Guess(userGuess: userGuess, actualRoll: currentDice, timestamp: Date())
        modelContext.insert(newGuess)
        
        // Reset for next round
        self.userGuess = nil
    }
}

struct HistoryView: View {
    let guesses: [Guess]
    
    var body: some View {
        List(guesses) { guess in
            HStack {
                Text("Guessed: \(guess.userGuess)")
                Text("Actual: \(guess.actualRoll)")
                Spacer()
                Text(guess.timestamp, format: .dateTime)
            }
        }
        .navigationTitle("Guess History")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Guess.self, inMemory: true)
}
