//
//  ContentView.swift
//  SwiftUILayoutTest-iOS
//
//  Created by Jay Lee on 2020/04/12.
//  Copyright © 2020 Jay Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private static var count = 0

    @State private var maxTextWidth: CGFloat? {
        didSet {
            Self.count += 1
            print(Self.count)
        }
    }

    @State private var text = ""

    var body: some View {
        VStack(alignment: .labelTrailingAlignment) {
            HStack {
                wrappedText("Title")
                TextField("Title", text: $text)
            }

            HStack {
                wrappedText("Long Title")
                TextField("Long Title", text: $text)
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .backgroundPreferenceValue(BoundsPreferenceKey.self) { values in
            GeometryReader { (geometry: GeometryProxy) in
                self.readWidth(from: values, in: geometry)
            }
        }
    }

    private func wrappedText(_ text: String) -> some View {
        Text(text)
            .layoutPriority(1)  // Fixes Text getting truncated or disappear
            .frame(width: maxTextWidth, alignment: .trailing)
            .alignmentGuide(.labelTrailingAlignment) { $0[.trailing] }
            .anchorPreference(
                key: BoundsPreferenceKey.self,
                value: .bounds
            ) {
                [BoundsPreference(bounds: $0)]
            }
    }

    private func readWidth(
        from values: [BoundsPreference],
        in geometry: GeometryProxy
    ) -> some View {
        DispatchQueue.main.async {
            self.maxTextWidth = values
                .map { geometry[$0.bounds].width }
                .max()
        }
        return Rectangle()
            .hidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
