//
//  MarkerData.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/11.
//

import Foundation
import CoreLocation

struct MarkerData {
    var position: CLLocationCoordinate2D // Marker、Clustering Item 的座標
    var title: String // Maker 的 Title
    var snippet: String // Maker 的 描述
}
