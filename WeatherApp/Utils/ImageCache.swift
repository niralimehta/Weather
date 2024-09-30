//
//  ImageCache.swift
//  WeatherApp
//
//  Created by Nirali Mehta on 9/30/24.
//

import Foundation
import SwiftUI

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
