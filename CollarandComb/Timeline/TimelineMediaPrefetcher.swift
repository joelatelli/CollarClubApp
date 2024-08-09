//
//  TimelineMediaPrefetcher.swift
//  CollarandComb
//
//  Created by Joel Muflam on 1/24/24.
//

import Nuke
import Observation
import SwiftUI
import UIKit

@Observable final class TimelineMediaPrefetcher: NSObject, UICollectionViewDataSourcePrefetching {
  private let prefetcher = ImagePrefetcher()

  weak var viewModel: TimelineViewModel?

  func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
	let imageURLs = getImageURLs(for: indexPaths)
	prefetcher.startPrefetching(with: imageURLs)
  }

  func collectionView(_: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
	let imageURLs = getImageURLs(for: indexPaths)
	prefetcher.stopPrefetching(with: imageURLs)
  }

  private func getImageURLs(for indexPaths: [IndexPath]) -> [URL] {
	guard let viewModel, case let .display(statuses, _) = viewModel.productsState else {
	  return []
	}
	return indexPaths.compactMap {
	  $0.row < statuses.endIndex ? statuses[$0.row] : nil
	}.flatMap(getImages)
  }
}

private func getImages(for status: Product) -> [URL] {
//	var urls = status.mediaAttachments?.compactMap {
//	if $0.supportedType == .image {
//		return status.mediaAttachments?.count ?? 0 > 1 ? $0.previewUrl ?? $0.url : $0.url
//	}
//	return nil
//  }
//  if let url = status.card?.image {
//	urls.append(url)
//  }
//	return urls ?? []
	return []
}

@Observable final class ProductTimelineMediaPrefetcher: NSObject, UICollectionViewDataSourcePrefetching {
  private let prefetcher = ImagePrefetcher()

  weak var viewModel: ProductTimelineListViewModel?

  func collectionView(_: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
	let imageURLs = getImageURLs(for: indexPaths)
	prefetcher.startPrefetching(with: imageURLs)
  }

  func collectionView(_: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
	let imageURLs = getImageURLs(for: indexPaths)
	prefetcher.stopPrefetching(with: imageURLs)
  }

  private func getImageURLs(for indexPaths: [IndexPath]) -> [URL] {
	guard let viewModel, case let .display(statuses, _) = viewModel.productsState else {
	  return []
	}
	return indexPaths.compactMap {
	  $0.row < statuses.endIndex ? statuses[$0.row] : nil
	}.flatMap(getImages)
  }
}
