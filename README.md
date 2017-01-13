# collection-view-sample
Sample to compare data update behaviour on AsyncDisplayKit and UIKit versions of Collection View.

Toggles between showing 3 cells in a single column, and 6 cells in two columns. Uses `performBatchUpdates` to make the data changes. Returns appropriate sizes to achieve the columns from `constrainedSizeForItemAtIndexPath` in the ASDK implementation, and from `sizeForItemAtIndexPath` in the UIKit implementation.

![UIKit](/README/UICollectionView.gif) ![ASDK](/README/ASCollectionNode.gif)

I'm seeing two main differences:
- The ADSK version doesn't resize the cells that are not directly changed by the update. `constrainedSizeForItemAtIndexPath` is called for new cells, but is not called for cells that weren't referenced in the update. The question is whether there are code changes that can be made within the sample to fix this, or whether changes would be needed within ASDK.
- The ASDK version doesn't animate the moves. This is a known issue/enhancement and work is going on (https://github.com/facebook/AsyncDisplayKit/issues/698).
