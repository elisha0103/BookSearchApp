//
//  TextFieldClearButton.swift
//  BookSearchApp
//
//  Created by 진태영 on 2023/04/11.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content

            if !fieldText.isEmpty {
                HStack {
                    Spacer()
                    Button(action: {
                        fieldText = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                    }
                    .foregroundColor(.secondary)
                    .padding(.trailing, 4)
                }
            }
        }
    }
}
