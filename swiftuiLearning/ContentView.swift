//
//  ContentView.swift
//  swiftuiLearning
//
//  Created by Alex Babich on 21.06.2020.
//  Copyright © 2020 Alex Babich. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<self.generateData().count, id: \.self) { index in
                    VStack {
                        Text("\(self.generateData()[index])")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20)
                }
            }
        }
    }

    private func generateData() -> [String] {
        var data: [String] = []
        for _ in 0..<100 {
            data.append(randomEmoji())
        }

        return data
    }
    
    private func randomEmoji() -> String {
        let range = 0x1F300...0x1F3F0
        let index = Int(arc4random_uniform(UInt32(range.count)))
        let ord = range.lowerBound + index
        guard let scalar = UnicodeScalar(ord) else { return "❓" }
        return String(scalar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
