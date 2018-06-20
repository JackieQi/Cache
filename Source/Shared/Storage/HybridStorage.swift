import Foundation

/// Use both memory and disk storage. Try on memory first.
public class HybridStorage<T> {
  public let memoryStorage: MemoryStorage<T>
  //public let diskStorage: DiskStorage<T>

  public init(memoryStorage: MemoryStorage<T>) {
    self.memoryStorage = memoryStorage
    //self.diskStorage = diskStorage
  }
}

extension HybridStorage: StorageAware {
  public func entry(forKey key: String) throws -> Entry<T> {
    return try memoryStorage.entry(forKey: key)
  }

  public func removeObject(forKey key: String) throws {
    memoryStorage.removeObject(forKey: key)
  }

  public func setObject(_ object: T, forKey key: String, expiry: Expiry? = nil) throws {
    memoryStorage.setObject(object, forKey: key, expiry: expiry)
  }

  public func removeAll() throws {
    memoryStorage.removeAll()
  }

  public func removeExpiredObjects() throws {
    memoryStorage.removeExpiredObjects()
  }
}

public extension HybridStorage {
  func transform<U>(transformer: Transformer<U>) -> HybridStorage<U> {
    let storage = HybridStorage<U>(
      memoryStorage: memoryStorage.transform()
    )

    return storage
  }
}
