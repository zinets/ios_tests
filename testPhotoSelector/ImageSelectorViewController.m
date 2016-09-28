//
//  ImageSelectorViewController.m
//
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ImageSelectorViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "PhotoGalleryAssetsManager.h"
#import "TakePhotoController.h"
#import "PhotoCropController.h"

#import "ImageSelectorListCell.h"
#import "ImageSelectorLiveCell.h"

#import "UIImage+FixedOrientation.h"

#define SELECTOR_LIVE_CELL_ID @"lvclid"
#define SELECTOR_LIST_CELL_ID @"lstclid"

#define ImageSourceTypeCancel ImageSourceTypeCount

@interface SelectorItem : NSObject {}
@property (nonatomic) ImageSourceType itemType;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) UIImage *itemIco;
@property (nonatomic, readonly) NSString *itemCellReuseId;
@property (nonatomic, readonly) CGFloat itemCellHeight;
@end

@implementation SelectorItem

-(NSString *)itemCellReuseId {
    switch (_itemType) {
        case ImageSourceTypeLive:
            return SELECTOR_LIVE_CELL_ID;
        default:
            return SELECTOR_LIST_CELL_ID;
    }
}

-(CGFloat)itemCellHeight {
    switch (_itemType) {
        case ImageSourceTypeLive:
            return [ImageSelectorLiveCell cellHeight];
        default:
            return [ImageSelectorListCell cellHeight];
    }
}

@end

#pragma mark - controller

@interface ImageSelectorViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageSelectorLiveCellDelegate, TakePhotoControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray <SelectorItem *> *items;

@property (nonatomic, strong) UICollectionView *table;
@property (nonatomic, strong) TakePhotoController *takePhotoController;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation ImageSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - internal

-(NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:ImageSourceTypeCount];
    }
    return _items;
}

- (void)initUI {
    if (self.delegate) {
        [self.items removeAllObjects];
        CGFloat tableHeight = 0;
        for (ImageSourceType is = ImageSourceTypeLive; is < ImageSourceTypeCount; is++) {
            if ([self.delegate imageSelector:self supportsSourcetype:is]) {
                SelectorItem *newItem = [SelectorItem new];
                newItem.itemType = is;
                newItem.itemTitle = [self.delegate imageSelector:self titleForSourceType:is];
                NSAssert(newItem.itemTitle != nil, @"List item without title has no sense!");
                if ([self.delegate respondsToSelector:@selector(imageSelector:iconForSourceType:)]) {
                    newItem.itemIco = [self.delegate imageSelector:self iconForSourceType:is];
                }
                [self.items addObject:newItem];
                
                tableHeight += newItem.itemCellHeight;
            }
        }
        
        // отдельно пусть будет cancel
        SelectorItem *cancelItem = [SelectorItem new];
        // это не очень (очень не) правильно, зато просто? или надо дать возможность настроить кнопку cancel?
        cancelItem.itemType = ImageSourceTypeCancel;
#warning Localize me
        cancelItem.itemTitle = @"Cancel";
        [self.items addObject:cancelItem];
        tableHeight += cancelItem.itemCellHeight;

        CGRect tableFrame = (CGRect){{0, self.view.bounds.size.height - tableHeight}, {self.view.bounds.size.width, tableHeight}};
        
        UICollectionViewFlowLayout *tableLayout = [UICollectionViewFlowLayout new];
        tableLayout.minimumLineSpacing = 0;
        tableLayout.minimumInteritemSpacing = 0;
        tableLayout.sectionInset = UIEdgeInsetsZero;
        
        _table = [[UICollectionView alloc] initWithFrame:tableFrame collectionViewLayout:tableLayout];
        _table.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        _table.backgroundColor = [UIColor whiteColor];
        
        [_table registerClass:[ImageSelectorListCell class] forCellWithReuseIdentifier:SELECTOR_LIST_CELL_ID];
        [_table registerClass:[ImageSelectorLiveCell class] forCellWithReuseIdentifier:SELECTOR_LIVE_CELL_ID];
        
        _table.dataSource = self;
        _table.delegate = self;
        [self.view addSubview:_table];
        
        // теперь штука для заполнения свободного пространства и реакции на тап в нем (свободном пространстве)
        CGRect buttonFrame = tableFrame;
        buttonFrame.size.height = tableFrame.origin.y;
        buttonFrame.origin.y = 0;
        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        closeBtn.frame = buttonFrame;
        [closeBtn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:closeBtn];
        
        [self.table reloadData];
    }
}

#pragma mark - actions

- (void)onTap:(id)sender {
    if (self.delegate) {
        [self.delegate imageSelector:self didFinishWithResult:nil];
    }
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.items[indexPath.row].itemType) {
        case ImageSourceTypeLive: {
            NSString *reuseId = self.items[indexPath.row].itemCellReuseId;
            ImageSelectorLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
            cell.delegate = self;
            return cell;  
        } break;
        default: {
            NSString *reuseId = self.items[indexPath.row].itemCellReuseId;
            ImageSelectorListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
            cell.textLabel.text = self.items[indexPath.row].itemTitle;
            cell.iconImage = self.items[indexPath.row].itemIco;
            return cell;
        } break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.items[indexPath.row].itemType) {
        case ImageSourceTypeCamera:
            [self showCameraInterface];
            break;
        case ImageSourceTypeAlbums:
            [self selectPhotoBySourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            break;
        case ImageSourceTypeLibrary:
            [self selectPhotoBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case ImageSourceTypeLive:
            // сюда мы по-правильному не попадем никогда
        default:
            if (self.delegate) {
                [self.delegate imageSelector:self didFinishWithResult:nil];
            }            
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){self.view.bounds.size.width, self.items[indexPath.row].itemCellHeight};
}

#pragma mark - live cell, camera etc

#define MAX_UPLOAD_PHOTO_SIZE 1024

// получили откуда-то картинку, обрезали и вернули, заодно и сигнализировали, что закончили выбор
- (void)cropImageAndFinish:(UIImage *)image {
    PhotoCropController *cropper = [PhotoCropController new];
    cropper.imageToCrop = image;
    __weak typeof(cropper) weak = cropper;
    cropper.completionBlock = ^ (UIImage * imageToUpload ) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *res = [image scaleAndRotateImage:MAX_UPLOAD_PHOTO_SIZE];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weak dismissViewControllerAnimated:YES completion:nil];
                        if (self.delegate) {
                            [self.delegate imageSelector:self didFinishWithResult:res];
                        }
                    });
                });
    };
//    UIViewController *presenter = self.presentedViewController ? self.presentedViewController : self;
    [self presentViewController:cropper animated:YES completion:nil];
}

// в 1-й (live - если включена) ячейке выбрали или фото из последних, или превью камеры
- (void)cell:(UICollectionViewCell *)sender didSelectImage:(UIImage *)image {
    if (image) {
        [self cropImageAndFinish:image];
    } else {
        [self showCameraInterface];
    }
}

// интерфейс камеры
- (TakePhotoController *)takePhotoController {
    if(!_takePhotoController) {
        _takePhotoController = [[TakePhotoController alloc] init];
        _takePhotoController.delegate = self;
    }
    
    return _takePhotoController;
}

- (void)showCameraInterface {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [PhotoGalleryAssetsManager checkCameraAuthorizationStatusWithCompletion:^(BOOL granted) {
            if (granted) {
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.takePhotoController];
                [self presentViewController:nav animated:YES completion:nil];
            } else {
#warning вывести сообщение?
            }
        }];
    }
}

// камера сделала фото и вернула изображение
- (void)takePhotoController:(TakePhotoController *)controller didFinishPickingImage:(UIImage *)image {
    [self cropImageAndFinish:image];
}

// юзер отменил фотографирование - просто говорим "ой все, закончили" (хотя можно возвращаться к списку может?)
- (void)takePhotoControllerDidCancel:(TakePhotoController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate imageSelector:self didFinishWithResult:nil];
        }
    }];
    self.takePhotoController = nil;
}

// интерфейс выбора фото
-(UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        _imagePicker.allowsEditing = NO;
    }
    return _imagePicker;
}

- (void)selectPhotoBySourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [PhotoGalleryAssetsManager checkAuthorizationStatusWithCompletion:^(BOOL granted) {
            if (granted) {
                self.imagePicker.sourceType = sourceType;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } else {
#warning вывести сообщение?
            }
        }];
    }
}

// выбор изображения из альбома/библиотеки отменено
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (self.delegate) {
        [self.delegate imageSelector:self didFinishWithResult:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self cropImageAndFinish:image];
}

@end
