//
//  TimePeriodPicker.swift
//  Wipe Out
//
//  Created by Angelina Staeck on 19.07.22.
//

import SwiftUI

struct TimePeriodPicker: View {
    @EnvironmentObject var viewModel: CardsViewModel
    @State var currentDate: Date = Date()

    var body: some View {
        DatePicker("", selection: $currentDate, displayedComponents: [.date])
            .datePickerStyle(.compact)
            .labelsHidden()
    }
}
