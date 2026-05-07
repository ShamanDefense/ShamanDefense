//
//  DragPreview.swift
//  ShamanDefense
//
//  Created by Mohammad Rizaldy Ramadhan on 06/05/26.
//

import SwiftUI

struct DragPreview: View {
    let character: CharacterData

    var body: some View {
        ZStack {
            Circle()
                .fill(character.tint)
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .frame(width: 56, height: 56)
            Text(character.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    DragPreview(character: GameCollection.allCharacters[0])
}
