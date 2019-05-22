//
//  UserImagesCell.m
//  SocialContact
//
//  Created by EDZ on 2019/1/19.
//  Copyright © 2019 ha. All rights reserved.
//

#import "UserImagesCell.h"

@implementation UserImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.font = [UIFont systemFontOfSize:16];
    
    self.img1.hidden = YES;
    self.img2.hidden = YES;
    self.img3.hidden = YES;
    
    WEAKSELF;
    self.img1.userInteractionEnabled = YES;
    self.img2.userInteractionEnabled = YES;
    self.img3.userInteractionEnabled = YES;
    
    self.img1.layer.masksToBounds = YES;
    self.img2.layer.masksToBounds = YES;
    self.img3.layer.masksToBounds = YES;
    
    self.img1.clipsToBounds = YES;
    self.img2.clipsToBounds = YES;
    self.img3.clipsToBounds = YES;
    
    self.img1.layer.cornerRadius = 3;
    self.img2.layer.cornerRadius = 3;
    self.img3.layer.cornerRadius = 3;
    
    [self.img1 jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf showImagesWithImg:0];
    }];
    [self.img2 jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf showImagesWithImg:1];
    }];
    [self.img3 jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf showImagesWithImg:2];
    }];
    
}

- (void)showImagesWithImg:(NSInteger)idx{
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (int i = 0; i < self.userInfo.images.count; i++) {
        // Get the large image url
        NSString *url = self.userInfo.images[i];
        if (![url containsString:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,url];
        }
        UIImageView *fromView = self.img1;
        if (i==idx) {
            if (i==0) {
                fromView = self.img1;
            }else if (i==1) {
                fromView = self.img2;
            }else if (i==2) {
                fromView = self.img3;
            }
        }else if(i>2){
            fromView = self.img3;
        }
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:fromView imageUrl:[NSURL URLWithString:url]];
        [items addObject:item];
    }
    
    if (items.count > 0) {
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:idx];
        browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
        [browser showFromViewController:[AppDelegate sharedDelegate].window.rootViewController];
    }
}

- (void)setUserInfo:(SCUserInfo *)userInfo{
    _userInfo = userInfo;
    if (userInfo) {
        
        if (self.userInfo.images.count == 0) {
            self.title.text = [NSString stringWithFormat:@"相册：暂无图片"];
        }else{
            self.title.text = [NSString stringWithFormat:@"相册（共%ld张）",self.userInfo.images.count];
        }
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i=0; i<self.userInfo.images.count; i++) {
            NSString *tempUrl = self.userInfo.images[i];
            if (![tempUrl containsString:@"http"]) {
                tempUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,tempUrl];
                [images addObject:tempUrl];
            }else{
                [images addObject:tempUrl];
            }
        }

        if (images.count >= 3) {

            NSString *avatarUrl = images[2];
            if (![avatarUrl containsString:@"http"]) {
                avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
            }
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
            self.img3.hidden = NO;
        }
        if (images.count >= 2) {

            NSString *avatarUrl = images[1];
            if (![avatarUrl containsString:@"http"]) {
                avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
            }
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
            self.img2.hidden = NO;

        }
        if (images.count >= 1) {

            NSString *avatarUrl = images[0];
            if (![avatarUrl containsString:@"http"]) {
                avatarUrl = [NSString stringWithFormat:@"%@%@",kQINIU_HOSTKey,avatarUrl];
            }
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
            self.img1.hidden = NO;

        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
