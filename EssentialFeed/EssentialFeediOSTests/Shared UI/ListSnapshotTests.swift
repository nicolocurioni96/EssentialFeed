//
//  ListSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Nicolò Curioni on 13/05/24.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class ListSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyList())
        
        //record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "EMPTY_LIST_light")
        //record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "EMPTY_LIST_dark")
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        //record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
        //record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
        //record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_WITH_ERROR_MESSAGE_light_extraExtraExtraLarge")
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_WITH_ERROR_MESSAGE_light_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.tableView.separatorStyle = .none
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }
}
