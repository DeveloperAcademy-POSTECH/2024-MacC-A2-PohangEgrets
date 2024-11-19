//
//  HostTagView.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/16/24.
//

import SwiftUI

struct HostTagView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.hostBackground)
            .stroke(.hostStroke, style: .init(lineWidth: 1))
            .frame(width: 32, height: 12)
            .overlay {
                Text("Host")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(.lightGray2)
            }
    }
}
