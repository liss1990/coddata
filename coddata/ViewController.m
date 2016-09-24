//
//  ViewController.m
//  coddata
//
//  Created by 李丝思 on 16/6/5.
//  Copyright © 2016年 思. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "User.h"
#import "UserTableViewCell.h"
#import "EditViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSManagedObjectContext *objectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Addbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;
@property(nonatomic,strong)NSMutableArray *dataarray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化上下文
    self.dataarray=[NSMutableArray array];
    self.objectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    //初始化model
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    //	通过存储助理 把数据库写到本地
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *sqlitePath = [path stringByAppendingString:@"user.sqlite"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    self.objectContext.persistentStoreCoordinator=coordinator;
    [self.tableVeiw registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell" forIndexPath:indexPath];
    User *user=self.dataarray[indexPath.row];
    cell.userName.text=user.name;
    cell.age.text=[NSString stringWithFormat:@"%@", user.age];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditViewController *vc=[[EditViewController alloc]init];
    User *use=self.dataarray[indexPath.row];
    vc.user=use; 
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"%ld",indexPath.row);
        User *user=self.dataarray[indexPath.row];
        NSFetchRequest *reques = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        reques.predicate  = [NSPredicate predicateWithFormat:@"name = %@",user.name];
        NSArray *array = [self.objectContext executeFetchRequest:reques error:nil];
        for (User *u in array) {
            [self.objectContext deleteObject:u];
            [self.dataarray removeObjectAtIndex:indexPath.row];
        }
        [self.objectContext save:nil ];
        [self.tableVeiw reloadData];
    }

}


- (IBAction)add:(id)sender {
    EditViewController *vc=[[EditViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
 

-(void)selectdata
{
    [self.dataarray removeAllObjects];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSArray *array = [self.objectContext executeFetchRequest:request error:nil];
    
    for (User *u in array) {
        [self.dataarray addObject:u];
    }
    [self.tableVeiw reloadData];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectdata];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
