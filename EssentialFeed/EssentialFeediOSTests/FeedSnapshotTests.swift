//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Nicolò Curioni on 08/04/24.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

class FeedSnapshotTests: XCTestCase {
    
    func test_emptyFeed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "EMPTY_FEED_LIGHT")
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "EMPTY_FEED_DARK")
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "EMPTY_FEED_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "EMPTY_FEED_DARK")
    }
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_CONTENT_LIGHT")
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_CONTENT_DARK")
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_CONTENT_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_CONTENT_DARK")
    }
    
    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
       
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_ERROR_MESSAGE_LIGHT")
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE_DARK")
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_ERROR_MESSAGE_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE_DARK")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()
        
        sut.display(feedWithFailedImageLoading())
        
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_LIGHT")
        record(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_DARK")
        
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone15Pro(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedViewController
        controller.loadViewIfNeeded()
        
        return controller
    }
    
    private func emptyFeed() -> [FeedImageCellController] {
        return []
    }
    
    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [
            ImageStub(description: nil, location: "Cannon Street, London", image: nil),
            ImageStub(description: nil, location: "Brighton Seafront", image: nil)
        ]
    }
    
    private func feedWithContent() -> [ImageStub] {
        return [
            ImageStub(
                description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Garth Pier",
                image: UIImage.make(withColor: .green)
            )
        ]
    }
}

private extension FeedViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel<UIImage>
    weak var controller: FeedImageCellController?

    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(
            description: description,
            location: location,
            image: image,
            isLoading: false,
            shouldRetry: image == nil)
    }

    func didRequestImage() {
        controller?.display(viewModel)
    }

    func didCancelImageRequest() {}
}