//
//  ExchangeWeChatListCell.m
//  SocialContact
//
//  Created by EDZ on 2019/2/25.
//  Copyright © 2019 ha. All rights reserved.
//

#import "ExchangeWeChatListCell.h"

@implementation ExchangeWeChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img.layer.cornerRadius = 30.f;
    self.img.layer.masksToBounds = YES;
    
    
    self.refuseBtn.layer.cornerRadius = 5;
    self.agreeBtn.layer.cornerRadius = 5;
    self.refuseBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.masksToBounds = YES;
    
    [self.refuseBtn setBackgroundImage:[UIImage imageWithColor:ORANGE] forState:UIControlStateNormal];
    
    [self.agreeBtn setBackgroundImage:[UIImage imageWithColor:BLUE] forState:UIControlStateNormal];
    
    
    self.title.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.des.font =  [UIFont fontWithName:@"Heiti SC" size:14];
    self.shifouTongYi.font =  [UIFont fontWithName:@"Heiti SC" size:14];
    self.refuseBtn.titleLabel.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.agreeBtn.titleLabel.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    self.dateL.font =  [UIFont fontWithName:@"Heiti SC" size:15];
    
}

- (void)setModel:(ApplyModel *)model{
    
    _model = model;
    
    NSDate *date = [model.create_at sc_dateWithUTCString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"M-d HH:mm"];
    NSString* dateStr = [[NSString alloc]initWithString:[formatter stringFromDate:date]];
    self.dateL.text = dateStr;
    
    // 我发出去的
    if (_model.to_customer) {
        
        if (self.type == 1) {
            
            self.refuseBtn.hidden = YES;
            self.agreeBtn.hidden = YES;
            
            [_img sc_setImgWithUrl:_model.to_customer.avatar_url placeholderImg:@""];
            _title.text = _model.to_customer.name;
            
            if (_type == 0 || _type == 1) {
                _des.text = @"请求交换微信";
            }else if (_type == 2 || _type == 3) {
                _des.text = @"线上约（对方线上和您聊天）";
            }
//            else if (_type == 3) {
//                _des.text = @"线下约（客服第一时间联系你们）";
//            }
            
            if (_model.status == 0) {
                self.refuseBtn.hidden = NO;
                self.agreeBtn.hidden = NO;
                self.shifouTongYi.text = @"";
                
            }else if (_model.status == 1) {
                
                if (_type == 0 || _type == 1) {
                    self.shifouTongYi.text =[NSString stringWithFormat:@"已同意，对方微信：%@",_model.to_customer.wechat_id?:@""];
                }else if (_type == 2 || _type == 3) {
                    self.shifouTongYi.text = @"已同意";
                }
                
                
            }else if (_model.status == 2) {
                
                self.shifouTongYi.text = @"已拒绝";
            }
            
            
        }else{
            self.refuseBtn.hidden = YES;
            self.agreeBtn.hidden = YES;
            
            [_img sc_setImgWithUrl:_model.to_customer.avatar_url placeholderImg:@""];
            _title.text = _model.to_customer.name;
            if (_type == 0 || _type == 1) {
                _des.text = @"请求交换微信";
            }else if (_type == 2 || _type == 3) {
                _des.text = @"线上约（对方线上和您聊天）";
            }
//            else if (_type == 3) {
//                _des.text = @"线下约（客服第一时间联系你们）";
//            }
    
            if (_model.status == 0) {
                
                self.shifouTongYi.text = @"对方还未处理";
                
            }else if (_model.status == 1) {
            
                
                if (_type == 0 || _type == 1) {
                    self.shifouTongYi.text =[NSString stringWithFormat:@"已同意，对方微信：%@",_model.to_customer.wechat_id?:@""];
                }else if (_type == 2 || _type == 3) {
                    self.shifouTongYi.text = @"已同意";
                }
                
            }else if (_model.status == 2) {
                
                self.shifouTongYi.text = @"对方已拒绝";
            }
        }
        
    }
    
    // 我收到的
    if (_model.customer) {
        
        
        self.refuseBtn.hidden = YES;
        self.agreeBtn.hidden = YES;
        
        [_img sc_setImgWithUrl:_model.customer.avatar_url placeholderImg:@""];
        _title.text = _model.customer.name;
        if (_type == 0 || _type == 1) {
            _des.text = @"请求交换微信";
        }else if (_type == 2 || _type == 3) {
            _des.text = @"线上约（对方线上和您聊天）";
        }
//        else if (_type == 3) {
//            _des.text = @"线下约（客服第一时间联系你们）";
//        }

        if (_model.status == 0) {
            self.refuseBtn.hidden = NO;
            self.agreeBtn.hidden = NO;
            self.shifouTongYi.text = @"";
            
        }else if (_model.status == 1) {
            
            if (_type == 0 || _type == 1) {
                self.shifouTongYi.text =[NSString stringWithFormat:@"已同意，对方微信：%@",_model.customer.wechat_id?:@""];
            }else if (_type == 2 || _type == 3) {
                self.shifouTongYi.text = @"已同意";
            }
            
        }else if (_model.status == 2) {
            
            self.shifouTongYi.text = @"已拒绝";
        }
        
        
    }
}
- (IBAction)refuseBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(refuseBtnClicked:type:)]) {
        [_delegate refuseBtnClicked:_indexPath type:_type];
    }
}

- (IBAction)agreeBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(agreeBtnClicked:type:)]) {
        [_delegate agreeBtnClicked:_indexPath type:_type];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
