//
//  TrailingIconLabelStyle.swift
//  RecordMedi
//  Created by showna hsue on 2022/10/8.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}



struct CenterIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment:.center) {
            configuration.icon
            configuration.title
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}

extension LabelStyle where Self == CenterIconLabelStyle {
    static var centerIcon: Self { Self() }
}
