//
//  ContentView.swift
//  SwiftUILayoutTest
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

    @State private var integers = [0, 1, 2, 3, 4, 5]
    @State private var selection = 0

    var body: some View {
        VStack(alignment: .labelTrailingAlignment) {
            HStack {
                wrappedText("Title")
                Picker("Title", selection: self.$selection) {
                    ForEach(integers, id: \.self) {
                        Text("Selection \($0)")
                    }
                }
            }

            HStack {
                wrappedText("Long Title")
                Picker("Long Title", selection: self.$selection) {
                    ForEach(integers, id: \.self) {
                        Text("Selection \($0)")
                    }
                }
            }
        }
        .labelsHidden()
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
