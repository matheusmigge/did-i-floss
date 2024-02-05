//
//  CalendarView+WeekView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import SwiftUI

extension CalendarView {

    var weekCalendarGrid: some View {
        HStack(spacing: 5) {
            ForEach(self.daysCalendarSet, id: \.self) { day in
                VStack {
                    Text(day.dayOfTheWeek)
                        .monospaced()
                        .font(.callout)
                    
                    Group {
                        if self.hasDayFlossRecords(for: day) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .foregroundStyle(.greenyBlue)
                                .frame(width: 30, height: 30)
                        } else {
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 30, height: 30)
                        }
                    }
                    .onTapGesture {
                        didTapOnDate(day)
                    }
                }
                .padding(5)
                .background {
                    if shouldDayOfTheWeekBePink(day) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.flossFlamingoPink)
                    }
                }
            }
        }
    }
}
