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
    @State private var gameState: GameState = .ready

    enum GameState {
        case ready, guessing, result
    }

    var body: some View {
        NavigationView {
            VStack {
                // Dice image
                Image(systemName: diceImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                
                // User guess buttons
                HStack {
                    ForEach(1...6, id: \.self) { number in
                        Button(action: {
                            makeGuess(number)
                        }) {
                            Image(systemName: "die.face.\(number)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(userGuess == number ? .blue : .gray)
                        }
                        .disabled(gameState != .guessing)
                    }
                }
                .padding()
                
                // Roll button
                Button(rollButtonText) {
                    rollDice()
                }
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

    private var diceImageName: String {
        switch gameState {
        case .ready:
            return "die.face.6"
        case .guessing:
            return "die.face.blank"
        case .result:
            return "die.face.\(currentDice)"
        }
    }

    private var rollButtonText: String {
        switch gameState {
        case .ready:
            return "Roll Dice"
        case .guessing:
            return "Reveal"
        case .result:
            return "Roll Again"
        }
    }

    private func rollDice() {
        switch gameState {
        case .ready:
            currentDice = Int.random(in: 1...6)
            gameState = .guessing
            showResult = false
            userGuess = nil
        case .guessing:
            gameState = .result
            showResult = true
        case .result:
            gameState = .ready
        }
    }

    private func makeGuess(_ guess: Int) {
        userGuess = guess
        isCorrect = guess == currentDice
        
        // Save the guess
        let newGuess = Guess(userGuess: guess, actualRoll: currentDice, timestamp: Date())
        modelContext.insert(newGuess)
        
        gameState = .result
        showResult = true
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
