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
        JokeEntry(date: Date(), configuration: ConfigurationIntent(), joke: PresentJoke.sharedJoke)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (JokeEntry) -> ()) {
        let entry = JokeEntry(date: Date(), configuration: configuration, joke: PresentJoke.sharedJoke)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [JokeEntry] = []
            
            let currentDate = Date()
            for minuteOffset in 0 ..< 60 {
                let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
                let vm = await MainViewModel()
                let joke = try await vm.fetchWidgetJoke()
                let entry = JokeEntry(date: entryDate, configuration: configuration, joke: joke)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct JokeEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let joke: PresentJoke
}

struct EggJokeWidgetEntryView : View {
    var entry: JokeEntry

    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(Color("Background"))
            Text(entry.joke.joke)
                .padding()
//            Image(entry.joke.background)
        }
//        .widgetURL(URL(string: "EggJoke://\(entry.joke.joke)"))
    }
}

struct EggJokeWidget: Widget {
    let kind: String = "EggJokeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            EggJokeWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("EggJoke")
        .description("It will provide you with a new joke every minute.")
    }
}

struct EggJokeWidget_Previews: PreviewProvider {
    static var previews: some View {
        EggJokeWidgetEntryView(entry: JokeEntry(date: Date(), configuration: ConfigurationIntent(), joke: PresentJoke.sharedJoke))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
