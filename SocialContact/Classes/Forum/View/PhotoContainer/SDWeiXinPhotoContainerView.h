#import <UIKit/UIKit.h>
#import "NewDynamicsLayout.h"
@interface SDWeiXinPhotoContainerView : UIView

@property (nonatomic, strong) NSArray *picsArray;

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;

@property (nonatomic, assign) NSInteger perRowItemCount;

+ (CGSize)getContainerSize:(NSArray *)picsArray width:(CGFloat)width;

+ (CGFloat)itemWidth:(NSArray *)array width:(CGFloat)width;

+ (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array;

@end
