//
//  PlaceSection.swift
//  Placer
//
//  Created by Kawoou on 07/10/2019.
//  Copyright © 2019 kawoou. All rights reserved.
//

import RxDataSources

enum PlaceSection {
    case items([PlaceItem])
}

extension PlaceSection: SectionModelType {
    var items: [PlaceItem] {
        switch self {
        case let .items(items):
            return items
        }
    }

    init(original: PlaceSection, items: [PlaceItem]) {
        switch original {
        case .items:
            self = .items(items)
        }
    }
}

enum PlaceItem {
    case user(PostCellModel)
    case image(PostCellModel)
    case content(PostCellModel)
    case action(PostCellModel)
}
