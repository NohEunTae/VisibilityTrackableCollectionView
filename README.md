VisibilityTrackableCollectionView
=================================

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![swift-package-manager](https://img.shields.io/badge/package%20manager-compatible-brightgreen.svg?logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iNjJweCIgaGVpZ2h0PSI0OXB4IiB2aWV3Qm94PSIwIDAgNjIgNDkiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8IS0tIEdlbmVyYXRvcjogU2tldGNoIDYzLjEgKDkyNDUyKSAtIGh0dHBzOi8vc2tldGNoLmNvbSAtLT4KICAgIDx0aXRsZT5Hcm91cDwvdGl0bGU+CiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4KICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPgogICAgICAgIDxnIGlkPSJHcm91cCIgZmlsbC1ydWxlPSJub256ZXJvIj4KICAgICAgICAgICAgPHBvbHlnb24gaWQ9IlBhdGgiIGZpbGw9IiNEQkI1NTEiIHBvaW50cz0iNTEuMzEwMzQ0OCAwIDEwLjY4OTY1NTIgMCAwIDEzLjUxNzI0MTQgMCA0OSA2MiA0OSA2MiAxMy41MTcyNDE0Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDI1IDMxIDI1IDM1IDI1IDM3IDI1IDM3IDE0IDI1IDE0IDI1IDI1Ij48L3BvbHlnb24+CiAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJQYXRoIiBmaWxsPSIjRUZDNzVFIiBwb2ludHM9IjEwLjY4OTY1NTIgMCAwIDE0IDYyIDE0IDUxLjMxMDM0NDggMCI+PC9wb2x5Z29uPgogICAgICAgICAgICA8cG9seWdvbiBpZD0iUmVjdGFuZ2xlIiBmaWxsPSIjRjdFM0FGIiBwb2ludHM9IjI3IDAgMzUgMCAzNyAxNCAyNSAxNCI+PC9wb2x5Z29uPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+)](https://github.com/apple/swift-package-manager)
[![license](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://en.wikipedia.org/wiki/MIT_License)

The easiest way to find fully visible CollectionView's Cell & ReusableView while scrolling

At a Glance
-----------

Detect CollectionView's Cell or ReusableView fully visible

![ezgif com-video-to-gif-2](https://user-images.githubusercontent.com/35591476/125188179-ce933a80-e26d-11eb-8965-f63a4926f5f6.gif)

And also can detect nested CollectionView's fully visibility

![ezgif com-video-to-gif-3](https://user-images.githubusercontent.com/35591476/125188190-dc48c000-e26d-11eb-863d-cfb302974849.gif)

Getting Started
---------------

#### Step 1. Use VisibilityTrackableCollectionView

use VisibilityTrackableCollectionView and set delegate just like UICollectionView

```swift

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: VisibilityTrackableCollectionView!
    collectionView.delegate = self
}

```

#### Step 2. Setting Properties

you can set boundary that to be detected

default boundary is superior viewController's view (not safeArea)

```swift

collectionView.setBoundary(.init(view: someView, mode: .safeArea))

```


#### Step 3. Adopt `CollectionViewDelegateVisibleItems` with `UICollectionViewDelegate` just like `UICollectionViewDelegateFlowLayout`

```swift

extension ViewController: CollectionViewDelegateVisibleItems {

    func collectionView(_ collectionView: UICollectionView, firstTimeOfFullyVisibleItems items: [IndexPath]) {
    }
    
    func collectionView(_ collectionView: UICollectionView, allOfFullyVisibleItems items: [IndexPath]) {
    }
    
    func collectionView(_ collectionView: UICollectionView, supplementaryElementOfKind kind: String, firstTimeOfFullyVisibleItems items: [IndexPath]) {
    }
    
    func collectionView(_ collectionView: UICollectionView, supplementaryElementOfKind kind: String, allOfFullyVisibleItems items: [IndexPath]) {
    }    

}

```

Tips and Tricks
---------------

- **I want to refresh `firstTimeOfFullyVisibleItems`**

```swift

collectionView.refreshSeenData()

```


- **I want to use nesting**

just use `VisibilityTrackableCollectionView` for nesting.

It's designed for reuse, so you don't have to worry about `firstTimeOfFullyVisibleItems`.



- **I want to refresh nested `VisibilityTrackableCollectionView` when superior has been refreshed**

just call superior `VisibilityTrackableCollectionView`'s `refreshSeenData()` that causes all of internal data refreshed.



Installation
------------

Use Swift Package Manager (SPM)


License
-------
VisibilityTrackableCollectionView is under MIT license.

