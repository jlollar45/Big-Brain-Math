//
//  BackgroundView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/29/21.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle()
        LinearGradient(gradient: Gradient(colors: [.brandPrimary]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
