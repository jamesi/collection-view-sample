//
//  CellNode.m
//  CollectionViewSample
//
//

#import "CellNode.h"

@interface CellNode ()

@property (nonatomic, readonly) ASTextNode *textNode;


@end

@implementation CellNode

- (instancetype)initWithText:(NSString *)text color:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        _textNode = [ASTextNode new];
        _textNode.attributedText = [[NSAttributedString alloc] initWithString:text attributes:nil];
        self.backgroundColor = color;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0) child:self.textNode];
}

@end
