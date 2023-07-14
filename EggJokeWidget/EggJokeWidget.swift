//
//  EggJokeWidget.swift
//  EggJokeWidget
//
//  Created by Isack Häring on 13.07.23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> JokeEntry {
        JokeEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (JokeEntry) -> ()) {
        let entry = JokeEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [JokeEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 61 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = JokeEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct JokeEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct EggJokeWidgetEntryView : View {
    var entry: JokeEntry

    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(Color("Background"))
            Text(entry.date, style: .time)
        }
    }
}

struct EggJokeWidget: Widget {
    let kind: String = "EggJokeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            EggJokeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct EggJokeWidget_Previews: PreviewProvider {
    static var previews: some View {
        EggJokeWidgetEntryView(entry: JokeEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
