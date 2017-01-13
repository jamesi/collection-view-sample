//
//  CellUIKit.m
//  CollectionViewSample
//
//

#import "CellUIKit.h"

@interface CellUIKit ()

@property (nonatomic, readonly) UILabel *label;

@end

@implementation CellUIKit

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        [_label setTextColor:[UIColor whiteColor]];
        [self addSubview:_label];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:6.0].active = YES;
        [_label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    if (![_text isEqualToString:text]) {
        _text = text;
        _label.text = text;
    }
}

@end
