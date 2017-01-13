//
//  ViewControllerASDK.m
//  CollectionViewSample
//
//

#import "ViewControllerASDK.h"

#import "CellNode.h"
#import "Diff.h"

@interface ViewControllerASDK () <ASCollectionDataSource, ASCollectionDelegate>

@property (nonatomic, readonly) UICollectionViewFlowLayout *layout;
@property (nonatomic, readonly) ASCollectionNode *collectionNode;
@property (nonatomic, readwrite) NSInteger numColumns;
@property (nonatomic, readwrite) NSArray <NSString *> *dataSourceItems;

@property (nonatomic, readonly) NSArray <NSString *> *fewItems;
@property (nonatomic, readonly) NSArray <NSString *> *manyItems;
@property (nonatomic, readonly) NSArray <UIColor *> *cellColors;

@end

@implementation ViewControllerASDK

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    self = [super initWithNode:collectionNode];
    if (self) {
        _layout = layout;
        _collectionNode = collectionNode;
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;

        _fewItems = @[@"One", @"Two", @"Three"];
        _manyItems = @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six"];
        _cellColors = @[[UIColor blueColor], [UIColor brownColor], [UIColor orangeColor], [UIColor lightGrayColor], [UIColor grayColor], [UIColor darkGrayColor]];
        
        _numColumns = 1;
        _dataSourceItems = _fewItems;
        
        _layout.minimumLineSpacing = 1.0;
        _layout.minimumInteritemSpacing = 1.0;
        _layout.sectionInset = UIEdgeInsetsZero;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle Data" style:UIBarButtonItemStylePlain target:self action:@selector(toggleBarButtonTarget)];
        
        self.title = @"ASDK";
    }
    return self;
}

- (void)toggleBarButtonTarget
{
    if (self.dataSourceItems == self.fewItems) {
        self.numColumns = 2;
        self.dataSourceItems = self.manyItems;
    } else {
        self.numColumns = 1;
        self.dataSourceItems = self.fewItems;
    }
}

- (void)setDataSourceItems:(NSArray<NSString *> *)dataSourceItems
{
    Diff *diff = [Diff diffFromItems:_dataSourceItems toItems:dataSourceItems];
    _dataSourceItems = dataSourceItems;
   
    [self.collectionNode performBatchUpdates:^{
        if (diff.insertedIndexes.count > 0) {
            [self.collectionNode insertItemsAtIndexPaths:[self indexPathsWithItemIndexes:diff.insertedIndexes]];
        }
        if (diff.deletedIndexes.count > 0) {
            [self.collectionNode deleteItemsAtIndexPaths:[self indexPathsWithItemIndexes:diff.deletedIndexes]];
        }
        for (NSArray *move in diff.movedIndexes) {
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:[move[0] integerValue] inSection:0];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[move[1] integerValue] inSection:0];
            [self.collectionNode moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        }
    } completion:nil];
}

- (NSArray *)indexPathsWithItemIndexes:(NSArray *)indexes
{
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSNumber *index in indexes) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    }
    return indexPaths;
}

- (CGFloat)nodeWidthForNumColumns:(NSInteger)numColumns
{
    CGFloat availableWidth = self.collectionNode.bounds.size.width;
    availableWidth = availableWidth - (numColumns - 1) * _layout.minimumInteritemSpacing;
    return floorf(availableWidth / numColumns);
}

#pragma <ASCollectionDelegate>

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat nodeWidth = [self nodeWidthForNumColumns:self.numColumns];
    CGSize minSize = CGSizeMake(nodeWidth, 0.0);
    CGSize maxSize = CGSizeMake(nodeWidth, FLT_MAX);
    return ASSizeRangeMake(minSize, maxSize);
}

#pragma <ASCollectionDataSource>

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    NSAssert(section == 0, @"Unexpected section");
    return [self.dataSourceItems count];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"Unexpected section");
    NSString *item = self.dataSourceItems[indexPath.item];
    UIColor *color = self.cellColors[indexPath.item];
    
    return ^ASCellNode *() {
        return [[CellNode alloc] initWithText:item color:color];
    };
}

@end
