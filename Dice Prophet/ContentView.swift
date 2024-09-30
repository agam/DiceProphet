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
    @State private var gameState: GameState = .guessing
    @State private var showingCreatorInfo = false

    enum GameState {
        case guessing, result
    }

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Dice image
                    Image(systemName: diceImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                    
                    // User guess buttons in a 2x3 grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...6, id: \.self) { number in
                            Button(action: {
                                makeGuess(number)
                            }) {
                                Image(systemName: "die.face.\(number)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(userGuess == number ? .blue : .gray)
                            }
                            .disabled(gameState != .guessing)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Result display
                    if showResult {
                        Text(isCorrect ? "Correct!" : "Incorrect!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                    
                    // Roll Again button
                    Button(action: {
                        rollDice()
                    }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                            .background(Circle().fill(Color.white))
                            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(gameState == .guessing)
                    
                    Spacer()
                    
                    // History view
                    NavigationLink("View History") {
                        HistoryView(guesses: guesses)
                    }
                    .padding()
                }
                .navigationTitle("Dice Prophet")
                .padding(.top, 20) // Add some vertical space above the title
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Dice Prophet")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 60) // Increased height
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.blue, .purple, .pink]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                // Info button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingCreatorInfo = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreatorInfo) {
            CreatorInfoView()
        }
    }

    private var diceImageName: String {
        switch gameState {
        case .guessing:
            return "die.face.blank"
        case .result:
            return "die.face.\(currentDice)"
        }
    }

    private func rollDice() {
        currentDice = Int.random(in: 1...6)
        gameState = .guessing
        showResult = false
        userGuess = nil
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
        List {
            ForEach(groupedGuesses, id: \.date) { dayGroup in
                Section(header: Text(dayGroup.date, style: .date)) {
                    ForEach(dayGroup.hourGroups, id: \.hour) { hourGroup in
                        HourGroupView(hourGroup: hourGroup)
                    }
                }
            }
        }
        .navigationTitle("Guess History")
    }
    
    private var groupedGuesses: [DayGroup] {
        let sortedGuesses = guesses.sorted { $0.timestamp > $1.timestamp }
        let groupedByDay = Dictionary(grouping: sortedGuesses) { Calendar.current.startOfDay(for: $0.timestamp) }
        
        return groupedByDay.map { (day, dayGuesses) in
            let hourGroups = Dictionary(grouping: dayGuesses) { Calendar.current.component(.hour, from: $0.timestamp) }
                .map { (hour, hourGuesses) in
                    HourGroup(hour: hour, guesses: hourGuesses)
                }
                .sorted { $0.hour > $1.hour }
            
            return DayGroup(date: day, hourGroups: hourGroups)
        }
        .sorted { $0.date > $1.date }
    }
}

struct HourGroupView: View {
    let hourGroup: HourGroup
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(hourGroup.hour):00 - \(hourGroup.hour):59")
                .font(.headline)
            Text("Guesses: \(hourGroup.guesses.count)")
            Text("Correct: \(hourGroup.correctGuesses)")
            Text("Hit Rate: \(hourGroup.hitPercentage, specifier: "%.1f")%")
        }
    }
}

struct DayGroup {
    let date: Date
    let hourGroups: [HourGroup]
}

struct HourGroup {
    let hour: Int
    let guesses: [Guess]
    
    var correctGuesses: Int {
        guesses.filter { $0.userGuess == $0.actualRoll }.count
    }
    
    var hitPercentage: Double {
        guard !guesses.isEmpty else { return 0 }
        return Double(correctGuesses) / Double(guesses.count) * 100
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Guess.self, inMemory: true)
}
