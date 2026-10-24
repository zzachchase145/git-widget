//
//  GitTrackerWidget.swift
//  GitTrackerWidget
//
//  Created by Zach Chase on 15/09/2026.
//

// IMPORTS
// ---------------
import WidgetKit
import SwiftUI


// WIDGET TIMELINE PROVIDER
// ------------------------------------
struct Provider: TimelineProvider {
    
    // WIDGET PLACEHOLDER
    // -------------------------
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalContributions: 0)
    }
    
    // WIDGET SNAPSHOT
    // --------------------------
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), totalContributions: 0)
        completion(entry)
    }
    
    // WIDGET TIMELINE
    // --------------------------
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // READ CONTRIBUTIONS FROM SHARED STORAGE
        let sharedDefaults = UserDefaults(
            suiteName: "group.com.zachchase.GitTracker"
        )
        let totalContributions = sharedDefaults?.integer(
            forKey: "totalContributions"
        ) ?? 0
        
        // CREATE CURRENT ENTRY
        let entry = SimpleEntry(
            date: Date(),
            totalContributions: totalContributions
        )
        
        // CREATE TIMELINE
        let timeline = Timeline(
            entries: [entry],
            policy: .atEnd
        )
        // SEND TIMELINE TO WIDGETKIT
        completion(timeline)
    }
    
    
}


// WIDGET TIMELINE ENTRY
// ---------------------------------
struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalContributions: Int
}

// WIDGET ENTRY VIEW
// --------------------------------------
struct GitTrackerWidgetEntryView : View {
    var entry: Provider.Entry
    
    // CURRENT WEEKDAY
    private var currentWeekday: Int {
        Calendar.current.component(.weekday, from: Date())
    }
    
    
    // WEEKDAY ORDERING LOGIC
    // ----------------------------
    private var currentRow: Int {
        if currentWeekday == 1 {
            return 6
        } else {
            return currentWeekday - 2
        }
    }
    
    
    // CURRENT WEEK DATE LOGIC
    // -----------------------------------
    private var startOfCurrentWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        // TEMP TEST DATE
        //let testDate = calendar.date(
        //    from: DateComponents(year: 2026, month: 10, day: 17)
        //)!
        
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: Date()
        )
        return calendar.date(from: components)!
    }
    
    
    // ASSIGN SQUARE IT'S DATE LOGIC FUNC
    // ------------------------------------
    private func dateForSquare(row: Int, column: Int) -> Date {
        let weeksBack = 23 - column
        let calendar = Calendar.current
        
        let weekStart = calendar.date(
            byAdding: .weekOfYear,
            value: -weeksBack,
            to: startOfCurrentWeek
        )!
        
        let squareDate = calendar.date(
            byAdding: .day,
            value: row,
            to: weekStart
        )!
        
        return squareDate
    }
    
    
    // FIRST FULL WEEK IDENTIFIER HELPER
    // -----------------------------------
    private func monthLabel(for column: Int) -> String? {
        let calendar = Calendar.current
        let monday = dateForSquare(row: 0, column: column)
        
        let day = calendar.component(.day, from: monday)
        let columnsRemaining = 24 - column
        
        if day <= 7 && columnsRemaining >= 2 {
            return monday.formatted(.dateTime.month(.abbreviated))
        }
        return nil
    }
    
    
    // LEFT EDGE MONTH INDENTIFIER HELPER
    // -------------------------------------
    private func leftEdgeMonthLabel() -> String {
        let leftEdgeDate = dateForSquare(row: 0, column: 0)
        
        return leftEdgeDate.formatted(.dateTime.month(.abbreviated))
    }
    
    
    // NEXT MONTH COLUMN IDENTIFIER HELPER
    // -----------------------------------------
    private func nextMonthLabelColumn() -> Int? {
        for column in 1..<24 {
            if monthLabel(for: column) != nil {
                return column
            }
        }
        
        return nil
    }
    
    
    // WIDGET LABELING LOGIC
    // -------------------------------
    var body: some View {
        VStack (spacing: 4) {
            // TEMP SQUARE DATE DEBUG
            //Text(
            //    "\(dateForSquare(row: 0, column: 22).formatted(date: .long, time: .omitted)) -> \(dateForSquare(row: 6, column: 22).formatted(date: .long, time: .omitted))"
            //)
            
            // GITHUB CONTRIBUTIONS DISPLAY
            Text("Total Contributions: \(entry.totalContributions)")
                .font(.headline)
            
            
            // MONTH LABELS
            HStack(spacing: 3) {
                ForEach(0..<24, id: \.self) { column in
                    let normalLabel = monthLabel(for: column)
                    
                    let label = if column == 0,
                                   let nextColumn = nextMonthLabelColumn(),
                                   nextColumn >= 2 {
                        normalLabel ?? leftEdgeMonthLabel()
                    } else {
                        normalLabel ?? ""
                    }
                                     
                    Text(label)
                        .fixedSize()
                        .frame(width: 10, alignment: .leading)
                }
            }
            .padding(.top, 2)
            
            
            // WIDGET COMMIT GRID LOGIC
            VStack(spacing: 3) {
                ForEach(0..<7, id: \.self) { row in
                
                HStack(spacing: 3) {
                    ForEach(0..<24, id: \.self) { column in
                        
                        //let squareDate = dateForSquare(row: row, column: column)
                        
                        if column != 23 || row <= currentRow {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    row == 3 && column == 10 ? Color.green.opacity(0.30) :
                                    row == 3 && column == 11 ? Color.green.opacity(0.50) :
                                    row == 3 && column == 12 ? Color.green.opacity(0.75) :
                                    row == 3 && column == 13 ? Color.green :
                                    row == 1 && column == 16 ? Color.green.opacity(0.50) :
                                    row == 5 && column == 18 ? Color.green :
                                    row == 2 && column == 20 ? Color.green.opacity(0.75) :
                                    row == 6 && column == 21 ? Color.green.opacity(0.30) :
                                    Color.gray.opacity(0.20)
                                )
                                .frame(width: 10, height: 10)
                            }
                        }
                    } .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.top, 5)
        }
        
        Spacer()
    }
}



// WIDGET CONFIGURATION
// ----------------------------------
struct GitTrackerWidget: Widget {
    
    // WIDGET IDENTIFIER
    let kind: String = "GitTrackerWidget"
    
    // WIDGET CONFIGURATION BODY
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
            // MACOS VERSION COMPATIBILITY
            if #available(macOS 14.0, *) {
                GitTrackerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                GitTrackerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        // WIDGET GALLERY INFORMATION
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        
        // SUPPORTED WIDGET SIZES
        .supportedFamilies([.systemMedium])
    }
}

// WIDGET PREVIEW
// --------------------------------
#Preview(as: .systemMedium) {
    GitTrackerWidget()
} timeline: {
    SimpleEntry(date: .now, totalContributions: 428)
}


