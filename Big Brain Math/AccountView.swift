//
//  AccountView.swift
//  Big Brain Math
//
//  Created by ParkingPal on 9/28/21.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
            }
            .navigationTitle("Profile")
        }
        
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
