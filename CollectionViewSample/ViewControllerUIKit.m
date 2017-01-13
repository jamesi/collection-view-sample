//
//  ViewControllerUIKit.m
//  CollectionViewSample
//
//

#import "ViewControllerUIKit.h"

#import "CellUIKit.h"
#import "Diff.h"

@interface ViewControllerUIKit () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, readonly) UICollectionViewFlowLayout *layout;
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, readwrite) NSInteger numColumns;
@property (nonatomic, readwrite) NSArray <NSString *> *dataSourceItems;

@property (nonatomic, readonly) NSArray <NSString *> *fewItems;
@property (nonatomic, readonly) NSArray <NSString *> *manyItems;
@property (nonatomic, readonly) NSArray <UIColor *> *cellColors;

@end

@implementation ViewControllerUIKit

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fewItems = @[@"One", @"Two", @"Three"];
        _manyItems = @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six"];
        _cellColors = @[[UIColor blueColor], [UIColor brownColor], [UIColor orangeColor], [UIColor lightGrayColor], [UIColor grayColor], [UIColor darkGrayColor]];
        
        _numColumns = 1;
        _dataSourceItems = _fewItems;

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle Data" style:UIBarButtonItemStylePlain target:self action:@selector(toggleBarButtonTarget)];
        
        self.title = @"UIKit";
    }
    return self;
}

- (void)loadView
{
    _layout = [UICollectionViewFlowLayout new];
    _layout.minimumLineSpacing = 1.0;
    _layout.minimumInteritemSpacing = 1.0;
    _layout.sectionInset = UIEdgeInsetsZero;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    _collectionView.contentInset = UIEdgeInsetsZero;
    [_collectionView registerClass:[CellUIKit class] forCellWithReuseIdentifier:NSStringFromClass([CellUIKit class])];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.view = self.collectionView;
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
    
    [self.collectionView performBatchUpdates:^{
        if (diff.insertedIndexes.count > 0) {
            [self.collectionView insertItemsAtIndexPaths:[self indexPathsWithItemIndexes:diff.insertedIndexes]];
        }
        if (diff.deletedIndexes.count > 0) {
            [self.collectionView deleteItemsAtIndexPaths:[self indexPathsWithItemIndexes:diff.deletedIndexes]];
        }
        for (NSArray *move in diff.movedIndexes) {
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:[move[0] integerValue] inSection:0];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[move[1] integerValue] inSection:0];
            [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
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

- (CGFloat)cellWidthForNumColumns:(NSInteger)numColumns
{
    CGFloat availableWidth = self.collectionView.bounds.size.width;
    availableWidth = availableWidth - (numColumns - 1) * _layout.minimumInteritemSpacing;
    return floorf(availableWidth / numColumns);
}

#pragma <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self cellWidthForNumColumns:self.numColumns], 44.0);
}

#pragma <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSAssert(section == 0, @"Unexpected section");
    return [self.dataSourceItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellUIKit *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CellUIKit class]) forIndexPath:indexPath];
    cell.text = self.dataSourceItems[indexPath.item];
    cell.backgroundColor = self.cellColors[indexPath.item];
    return cell;
}

@end
