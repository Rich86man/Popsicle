//
//  Interpolator.swift
//  Popsicle
//
//  Created by David Román Aguirre on 04/11/15.
//  Copyright © 2015 David Román Aguirre. All rights reserved.
//

/// Value type on which interpolation values rely on.
public typealias Time = Double

/// `Interpolator` collects and coordinates a set of related interpolations through its `time` property.
open class Interpolator {
	var interpolations = [Timeable]()

	public init() {}

	open func addInterpolation<T: Interpolable>(_ interpolation: Interpolation<T>) {
		self.interpolations.append(interpolation)
	}

	open var time: Time = 0 {
		didSet {
			self.interpolations.forEach { $0.setTime(self.time) }
		}
	}

	open func removeInterpolation<T: Interpolable>(_ interpolation: Interpolation<T>) {
		for (index, element) in self.interpolations.enumerated() {
			if let interpolation = element as? Interpolation<T> {
				if interpolation == interpolation {
					self.interpolations.remove(at: index)
				}
			}
		}
	}

	/// Removes all interpolations containing the specified object.
	open func removeInterpolations(forObject object: NSObject) {
		for (index, element) in self.interpolations.enumerated() {
			if let interpolation = element as? ObjectReferable {
				if interpolation.objectReference == object {
					self.interpolations.remove(at: index)
					self.removeInterpolations(forObject: object) // Recursivity FTW
					return
				}
			}
		}
	}

	open func removeAllInterpolations() {
		self.interpolations.removeAll()
	}
}
