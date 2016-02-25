//
//  EditorListViewController.h
//  ZhihuDaily
//
//  Created by George She on 16/2/25.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "FDTableViewController.h"

@interface EditorListViewController : FDTableViewController
@property(nonatomic, strong) NSArray<EditorDataModel> *editors;
@end
