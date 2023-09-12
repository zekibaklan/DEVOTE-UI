//
//  ChechBoxStyle.swift
//  Devote
//
//  Created by Zeki Baklan on 13.09.2023.
//

import SwiftUI

struct ChechBoxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }//:HSTACK
    }
}

struct ChechBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder Label",isOn: .constant(true))
            .toggleStyle(ChechBoxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
        
    }
}
