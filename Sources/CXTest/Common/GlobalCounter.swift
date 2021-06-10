enum GlobalCounter {
    
    private static let lock = Lock()
    private static var count = 0
    
    static func next() -> Int {
        return lock.withLock {
            count += 1
            return count
        }
    }
}
