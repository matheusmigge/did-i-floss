//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI


struct CalendarView: View {
    
    @Namespace private var selectedDateNameSpace
    @StateObject var viewModel: ViewModel
    
    init(recordDates: [Date], style: Style) {
        self._viewModel = StateObject(wrappedValue: ViewModel(records: recordDates,
                                                              style: style))
    }
    
    static let gridColums: [GridItem] = Array(repeating:
                                        GridItem(.flexible(minimum: 15, maximum: 50)),
                                       count: 7)
    
    func dayColor(_ date: Date) -> Color {
        if viewModel.isToday(date) {
            return .red
        }
        
        if viewModel.isFromCurrentCalendarSet(date) {
            return .primary
        }
        
        return .secondary
    }
    
    var body: some View {
        VStack {
            calendarHeader
            
            calendarGrid
        }
        .padding()
    }
    
    
    private var calendarHeader: some View {
        HStack {
            Button {
                viewModel.previousCalendarSet()
            } label: {
                Image(systemName: "chevron.backward")
            }
            
            Spacer()
            
            Text(viewModel.dateLabel)
                .font(.headline)
            
            Spacer()
            
            Button {
                viewModel.nextCalendarSet()
            } label: {
                Image(systemName: "chevron.forward")
            }
            .opacity(viewModel.hasNexCalendar ? 1 : 0)
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func FlossIndicatorView(for date: Date) -> some View {
        let flossCount = viewModel.numberOfFlossRecords(for: date)
        
        HStack(spacing: 5) {
            if flossCount > 0 {
                Circle()
                    .foregroundStyle(Color.flossFlamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
            if flossCount > 1 {
                Circle()
                    .foregroundStyle(Color.flossFlamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
            
            if flossCount > 2 {
                Circle()
                    .foregroundStyle(Color.flossFlamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
        }
    }
    
    @ViewBuilder
    func dayMonthCalendarGridView(for date: Date) -> some View {
        Text(date.dayFormatted)
            .foregroundStyle(dayColor(date))
            .background {
                if viewModel.isSelectedDate(date) {
                    Circle()
                        .fill(Color.skyBlue)
                        .frame(width: 30, height: 30)
                        .matchedGeometryEffect(id: "selectedDateNameSpace", in: selectedDateNameSpace)
                }
            }
            .overlay {
                FlossIndicatorView(for: date)
            }
            .onTapGesture {
                withAnimation {
                    viewModel.dayOfCalendarPressed(date)
                }
            }
    }
    
    @ViewBuilder
    func dayWeekCalenderGridView(for date: Date) -> some View {
        if viewModel.hasDayFlossRecords(for: date) {
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
    
    private var calendarGrid: some View {
        LazyVGrid(columns: Self.gridColums, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
            
            ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                Text(day)
                    .monospaced()
            }
            
            ForEach(viewModel.daysCalendarSet, id: \.self) { date in
                switch viewModel.style {
                case .month:
                    dayMonthCalendarGridView(for: date)
                case .week:
                    dayWeekCalenderGridView(for: date)
                    
                }
                
            }
        })
    }
}

extension CalendarView {
    enum Style {
        case month, week
    }
}

extension CalendarView {
    class ViewModel: ObservableObject {
        
        @Published var currentCalendar: Date = .now
        
        @Published var selecteDate: Date = .now
        
        @Published var records: [Date]
        
        @Published var style: Style
        
        init(currentCalendar: Date = .now, selecteDate: Date = .now, records: [Date], style: Style) {
            self.currentCalendar = currentCalendar
            self.selecteDate = selecteDate
            self.records = records
            self.style = style
        }
        
        var filterdRecords: [Date] {
            records.filter { date in
                self.isSelectedDate(date)
            }
        }
        
        var calendar: Calendar {
            Calendar.current
        }
        
        var daysOfTheWeek: [String] {
            calendar.shortWeekdaySymbols
        }
        
        var daysCalendarSet: [Date] {
            switch style {
            case .month:
                return Calendar.getDaysOfTheMonth(for: currentCalendar)
            case .week:
                return Calendar.getDaysOfTheWeek(for: currentCalendar)
            }
           
        }
        
        var dateLabel: String {
            switch style {
            case .month:
                return currentCalendar.dayAndMonthFormatted
            case .week:
                let firstDayOfWeek = daysCalendarSet.first?.dayFormatted ?? "XX"
                let lastDayOfWeek = daysCalendarSet.last?.dayFormatted ?? "XX"
                
                return "\(firstDayOfWeek) - \(lastDayOfWeek) \(currentCalendar.monthFornatted)"
            }
        }
        
        var hasNexCalendar: Bool {
            let dateComponent: Calendar.Component = style == .month ? .month : .weekOfYear
            
            let next = calendar.date(byAdding: dateComponent, value: 1, to: currentCalendar) ?? Date()
            return next <= .now
        }
        
        func nextCalendarSet() {
            if hasNexCalendar {
                let calendarComponent: Calendar.Component = style == .week ? .weekOfYear : .month
                
                currentCalendar = calendar.date(byAdding: calendarComponent, value: 1, to: currentCalendar) ?? Date()
            }
        }
        
        func previousCalendarSet() {
            let calendarComponent: Calendar.Component = style == .week ? .weekOfYear : .month
            
            currentCalendar = calendar.date(byAdding: calendarComponent, value: -1, to: currentCalendar) ?? Date()
        }
        
        func isToday(_ date: Date) -> Bool {
            return calendar.isDateInToday(date)
        }
        
        func isFromCurrentCalendarSet(_ date: Date) -> Bool {
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        }
        
        func addRecordPressed() {
            records.append(selecteDate)
        }
        
        func dayOfCalendarPressed(_ date: Date) {
            selecteDate = date
        }
        
        func isSelectedDate(_ date: Date) -> Bool {
            calendar.isDate(date, equalTo: selecteDate, toGranularity: .day)
        }
        
        func numberOfFlossRecords(for date: Date) -> Int {
            return records
                .filter({calendar.isDate($0, equalTo: date, toGranularity: .day)})
                .count
        }
        
        func hasDayFlossRecords(for date: Date) -> Bool {
            let recordsCount = records
                .filter({calendar.isDate($0, equalTo: date, toGranularity: .day)})
                .count
            return recordsCount > 0
        }
        
    }
}


#Preview {
    CalendarView(recordDates: [
        Date(), Date(), Date(),
        Calendar.current.date(byAdding: .day, value: -2, to: .now)!
    ], style: .week)
}
