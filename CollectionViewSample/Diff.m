//
//  Diff.m
//  CollectionViewSample
//
//

#import "Diff.h"

@implementation Diff

- (instancetype)initWithInsertedIndexes:(NSArray *)insertedIndexes deletedIndexes:(NSArray *)deletedIndexes movedIndexes:(NSArray *)movedIndexes
{
    self = [super init];
    if (self) {
        _insertedIndexes = [insertedIndexes copy];
        _deletedIndexes = [deletedIndexes copy];
        _movedIndexes = [movedIndexes copy];
    }
    return self;
}

+ (Diff *)diffFromItems:(NSArray<NSString *> *)fromItems toItems:(NSArray<NSString *> *)toItems
{
    NSDictionary *fromIndexes = [self indexesForItems:fromItems];
    NSDictionary *toIndexes = [self indexesForItems:toItems];
    
    NSMutableArray *insertedIndexes = [NSMutableArray new];
    NSMutableArray *deletedIndexes = [NSMutableArray new];
    NSMutableArray *movedIndexes = [NSMutableArray new];
    
    // find deleted and moved members
    NSInteger fromIndex = 0;
    for (NSString *item in fromItems) {
        NSNumber *toIndex = toIndexes[item];
        if (!toIndex) {
            // no destination index, member has been deleted
            [deletedIndexes addObject:@(fromIndex)];
        } else {
            if ([toIndex integerValue] != fromIndex) {
                // destination index is different to start index, member has moved
                [movedIndexes addObject:@[@(fromIndex), toIndex]];
            }
        }
        fromIndex++;
    }
    
    // find inserted members
    NSInteger toIndex = 0;
    for (NSString *item in toItems) {
        if (!fromIndexes[item]) {
            // no start index, member has been inserted
            [insertedIndexes addObject:@(toIndex)];
        }
        toIndex++;
    }
    
    return [[Diff alloc] initWithInsertedIndexes:insertedIndexes deletedIndexes:deletedIndexes movedIndexes:movedIndexes];
}

+ (NSDictionary *)indexesForItems:(NSArray<NSString *> *)items
{
    NSMutableDictionary *indexes = [NSMutableDictionary new];
    for (NSInteger i = 0; i < [items count]; i++) {
        indexes[items[i]] = @(i);
    }
    return indexes;
}

@end
