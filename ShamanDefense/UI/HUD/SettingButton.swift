//
//  SettingButton.swift
//  ShamanDefense
//
//  Created by Mohammad Rizaldy Ramadhan on 13/05/26.
//

import SwiftUI

struct SettingButton: View {
    let isPaused: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(isPaused ? "continue" : "pause")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    SettingButton(isPaused: false, onTap: {})
}
