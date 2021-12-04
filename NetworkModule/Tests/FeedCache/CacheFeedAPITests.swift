import NetworkModule
import XCTest

//write tests to guarantee a method was called
//Also write tests to guarentee a method was not called
class LocalFeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
    var insertCallCount = 0
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
    
    func completionDeletion(with error: Error, at index: Int = 0) {
        
    }
}

final class Tests: XCTestCase {
    func test_init_doesNotDeleteCacheUponCreation() throws {
        XCTAssertEqual(makeSUT().store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items)
        
        store.completionDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
        
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeaks(store, file: file, line: line)
        trackMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        .init(id: UUID(), description: "any", location: "any", imageURL: .anyURL)
    }
}
