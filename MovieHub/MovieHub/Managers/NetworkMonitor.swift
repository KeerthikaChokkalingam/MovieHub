//
//  NetworkMonitor.swift
//  MovieHub
//
//  Created by Keerthika on 15/11/25.
//

import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private var isMonitoring = false

    var isConnected: Bool {
        monitor.currentPath.status == .satisfied
    }

    func startMonitoring() {
        guard !isMonitoring else { return }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        isMonitoring = true
    }


    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
}
