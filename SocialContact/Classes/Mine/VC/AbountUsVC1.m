//
//  AbountUsVC1.m
//  SocialContact
//
//  Created by EDZ on 2019/4/11.
//  Copyright © 2019 ha. All rights reserved.
//

#import "AbountUsVC1.h"

@interface AbountUsVC1 ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation AbountUsVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
    self.icon.layer.cornerRadius = 8.f;
    self.icon.layer.masksToBounds = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
