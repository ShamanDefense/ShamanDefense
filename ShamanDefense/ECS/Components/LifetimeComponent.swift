//
//  LifetimeComponent.swift
//  ShamanDefense
//

import GameplayKit

final class LifetimeComponent: GKComponent {
    var remaining: TimeInterval
    var onExpire: (() -> Void)?

    init(duration: TimeInterval) {
        self.remaining = duration
        super.init()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func update(deltaTime seconds: TimeInterval) {
        guard remaining > 0 else { return }
        remaining -= seconds
        if remaining <= 0 {
            onExpire?()
        }
    }
}
