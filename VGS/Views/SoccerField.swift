//
//  SoccerField.swift
//  VGS
//
//  Created by Huy Ong on 10/5/23.
//

import SwiftUI

struct SoccerField: View {
    
    private let strokeWidth: CGFloat = 3
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Rectangle()
                    .stroke(lineWidth: strokeWidth)
                
                Rectangle()
                    .frame(height: strokeWidth)
                
                Circle()
                    .stroke(lineWidth: strokeWidth)
                    .frame(width: size.width / 5)
                
                VStack {
                    Rectangle()
                        .stroke(lineWidth: strokeWidth)
                        .frame(width: size.width / 2, height: size.height / 10)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Rectangle()
                        .stroke(lineWidth: strokeWidth)
                        .frame(width: size.width / 2, height: size.height / 10)
                }
            }

        }
    }
}

#Preview {
    SoccerField()
}
