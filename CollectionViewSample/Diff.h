//
//  Diff.h
//  CollectionViewSample
//
//

#import <Foundation/Foundation.h>

@interface Diff : NSObject

@property (nonatomic, readonly) NSArray *insertedIndexes;
@property (nonatomic, readonly) NSArray *deletedIndexes;
@property (nonatomic, readonly) NSArray *movedIndexes;

- (instancetype)initWithInsertedIndexes:(NSArray *)insertedIndexes deletedIndexes:(NSArray *)deletedIndexes movedIndexes:(NSArray *)movedIndexes;

+ (Diff *)diffFromItems:(NSArray <NSString *>*)fromItems toItems:(NSArray <NSString *> *)toItems;

@end
