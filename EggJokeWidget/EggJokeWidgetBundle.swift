//
//  EggJokeWidgetBundle.swift
//  EggJokeWidget
//
//  Created by Isack Häring on 13.07.23.
//

import WidgetKit
import SwiftUI

@main
struct EggJokeWidgetBundle: WidgetBundle {
    var body: some Widget {
        EggJokeWidget()
        EggJokeWidgetLiveActivity()
    }
}
