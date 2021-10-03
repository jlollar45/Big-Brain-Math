//
//  StatsView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/28/21.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
            }
            .navigationTitle("Progress")
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
