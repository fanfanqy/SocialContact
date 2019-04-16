//
//  HorizontalScrollCell.h
//  ShiQi
//
//  Created by fqy on 2017/12/4.
//  Copyright © 2017年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollCellDeleagte.h"

@interface HorizontalScrollCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic ,strong)UICollectionView *collectionView;

@property(nonatomic ,strong)UILabel *labelT;// 我的相册

@property (weak, nonatomic) id <HorizontalScrollCellDeleagte> delegate;

///**
// Store the table-view index path where each HorizonScrollTableViewCell object is attached to.
// */
@property (strong, nonatomic) NSIndexPath *tableViewIndexPath;

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)reloadData;
@end
