//
//  ForumVC+Delegate.m
//  SocialContact
//
//  Created by EDZ on 2019/1/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ForumVC+Delegate.h"

@implementation ForumVC (Delegate)

/** @brief 点击了 Cell */
- (void)cellDidClick:(NewDynamicsTableViewCell *)cell{
    
    if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
        
    }else{
        [self gotoDetail:cell.layout.model];
    }
}

/**
 点击了 Label 的链接
 */
- (void)cell:(NewDynamicsTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange{
    
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
    
    if (info[@"kLikeUserId"]) {
        NSInteger userId = [info[@"kLikeUserId"] integerValue];
        [self goUserHomePageVC:userId];
        return;
    }
}

/**
 点击了话题链接
 */
- (void)cellDidClickTopic:(TopicModel *)topicModel cell:(NewDynamicsTableViewCell *)cell{
   
    if ([topicModel isEqual:self.topicModel]) {
        return;
    }
    
    ForumVC *vc = [ForumVC new];
    vc.title = topicModel.name;
    vc.forumVCType = ForumVCTypeMoment;
    vc.momentUIType = MomentUITypeList;
    vc.momentRequestType = MomentRequestTypeTopicList;
    
    vc.topicModel = topicModel;
    if (self.fatherVC) {
        [self.fatherVC.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/**
 点击了赞
 */
- (void)cellDidClickLike:(NewDynamicsTableViewCell *)cell{
    
    if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
        if (cell.layout.model.isZan) {
            [self zan:YES momentModel:cell.layout.model cell:cell];
        }else{
            [self zan:NO momentModel:cell.layout.model cell:cell];
        }
    }else{
        [self gotoDetail:cell.layout.model];
    }
}


/**
 点击了评论按钮
 */
- (void)cellDidClickComment:(NewDynamicsTableViewCell *)cell{
    
    if (self.momentRequestType == MomentRequestTypeUserMomentDetail || self.momentRequestType == MomentRequestTypeMyMomentDetail) {
        
        [self comment:cell.layout.model.iD isReply:NO isAdd:YES momentModel:cell.layout.model commentModel:nil];
        
    }else{
        [self gotoDetail:cell.layout.model];
    }
}

/**
 点击了回复内容
 */
- (void)cellDidClickReply:(NewDynamicsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    CommentLayout *layout = cell.layout.commentLayoutArr[indexPath.row];
    
    [self comment:layout.model.iD isReply:YES isAdd:NO momentModel:nil commentModel:layout.model];
    
}

/**
 点击了评论用户头像
 */
- (void)cellDidClickCommenterPortait:(NewDynamicsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
 
    CommentLayout *layout = cell.layout.commentLayoutArr[indexPath.row];
    [self goUserHomePageVC:layout.model.from_customer.userId];
}

/**
 长按了评论用户头像
 */
- (void)cellDidLongPressCommenterPortait:(NewDynamicsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    CommentLayout *layout = cell.layout.commentLayoutArr[indexPath.row];
    [self goUserHomePageVC:layout.model.from_customer.userId];
}


/**
 点击了用户,进入用户主页
 */
- (void)cell:(NewDynamicsTableViewCell *)cell didClickUser:(SCUserInfo *)user{
    
    [self goUserHomePageVC:user.iD];
}

- (void)goUserHomePageVC:(NSInteger)userId{
    UserHomepageVC *vc = [UserHomepageVC new];
    vc.userId = userId;
    if (self.fatherVC) {
        if (self.navigationController) {
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.fatherVC.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 进入帖子详情

 @param momentModel <#momentModel description#>
 */
- (void)gotoDetail:(MomentModel *)momentModel{
    
    ForumVC *vc = [ForumVC new];
    vc.title = @"动态详情";
    vc.forumVCType = ForumVCTypeMoment;
    vc.momentUIType = MomentUITypeDetail;
    vc.momentRequestType = MomentRequestTypeUserMomentDetail;
    
    vc.momentModel = momentModel;
    
    if (self.fatherVC) {
        [self.fatherVC.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


/**
 评论

 @param iD <#iD description#>
 @param isReply 添加评论
 @param isAdd 回复评论
 */
- (void)comment:(NSInteger)iD isReply:(BOOL)isReply isAdd:(BOOL)isAdd momentModel:(MomentModel *)momentModel commentModel:(CommentModel *)commentModel{
    
    // /moments/<int:pk>/comment/
    NSString *url;
    NSString *placeholder;
    if (isReply) {
        url = [NSString stringWithFormat:@"/moments/comment/%ld/",iD];
        placeholder = [NSString stringWithFormat:@"评论%@：",commentModel.from_customer.name];
    }
    if (isAdd) {
        url = [NSString stringWithFormat:@"/moments/%ld/comment/",iD];
        placeholder = @"请输入评论文字...";
    }
    WEAKSELF;
    //支持InputViewStyleDefault 与 InputViewStyleLarge 两种样式
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        //        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = placeholder;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {
        
        
        if(text.length){
            NSLog(@"输入为信息为:%@",text);
            
            NSDictionary *para = @{@"pk":[NSNumber numberWithInteger:iD],
                                   @"text":text};
            POSTRequest *request = [POSTRequest requestWithPath:url parameters:para completionHandler:^(InsRequest *request) {
               
                if (request.error) {
                    [weakSelf.view makeToast:request.error.localizedDescription];
                }else{
                    [weakSelf fetchData:YES];
                    [weakSelf.view makeToast:request.responseObject[@"msg"]];
                }
                
            }];
            [InsNetwork addRequest:request];
            
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-你输入的内容为空");
            [weakSelf.view makeToast:@"内容不能为空"];
            return NO;//return NO,不收键盘
        }
    }];
    
}


- (void)zan:(BOOL)zan momentModel:(MomentModel *)momentModel cell:(NewDynamicsTableViewCell *)cell{
    
//
    NSDictionary *para = @{@"pk":[NSNumber numberWithInteger:momentModel.iD]
                           };
    
    WEAKSELF;
    
    if (!zan) {
        // 点赞
        POSTRequest *request = [POSTRequest requestWithPath:[NSString stringWithFormat:@"/moments/%ld/likes/",momentModel.iD] parameters:para completionHandler:^(InsRequest *request) {
            
            if (request.error) {
                [weakSelf.view makeToast:request.error.localizedDescription];
            }else{
                [weakSelf fetchLikeUserData];
                [weakSelf.view makeToast:request.responseObject[@"msg"]];
                [cell.zanBtn setImage:[UIImage imageNamed:@"find_dianzhan_selected"] forState:UIControlStateNormal];
            }
            
        }];
        [InsNetwork addRequest:request];
    }else{
        // 取消点赞
        DELETERequest *request = [DELETERequest requestWithPath:[NSString stringWithFormat:@"/moments/%ld/likes/",momentModel.iD] parameters:para completionHandler:^(InsRequest *request) {
            
            if (request.error) {
                [weakSelf.view makeToast:request.error.localizedDescription];
            }else{
                [weakSelf fetchLikeUserData];
                [weakSelf.view makeToast:request.responseObject[@"msg"]];
                [cell.zanBtn setImage:[UIImage imageNamed:@"find_dianzhan"] forState:UIControlStateNormal];
            }
            
        }];
        [InsNetwork addRequest:request];
        
    }
    
}


@end
