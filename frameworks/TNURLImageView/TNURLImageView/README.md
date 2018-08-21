#  TNURLImageView 

## USAGE:
    @import TNURLImageView;
    [self.imageView preloadImages:@[@"url string to image"]];
    [self.imageView loadImageFromUrl:@"url string to image" withType:ImageTypeGrayscale];

## public methods description

### TNImageTypes.h
    typedef NS_ENUM(NSUInteger, ImageType) {
        ImageTypeNormal, // normal image
        ImageTypeGrayscale, // grayscaled image
        ImageTypePixelated, // pixelization effect
        ImageTypeBlurred, // blurred with default radius (5)
    };

### TNImageView.h
    /// картинка загрузилась и готова "установиться" во вью
    @property (nonatomic, copy) UIImage * _Nullable (^ _Nullable onImageLoaded)(UIImage * _Nullable img);
    
    /// картинка "установилась" на место
    @property (nonatomic, copy) void(^ _Nullable onLoadCompleted)(CGSize imageSize);
    
    /// неведомая ошибка
    @property (nonatomic, copy) void(^ _Nullable onLoadError)(void);

------
    
    /// заглушка на время, пока image == nil; в сеттере заглушка получит фрейм контрола
    @property (nonatomic, strong) UIView * _Nullable placeholderView;
    
    /// заглушка на время загрузки урла; в сеттере заглушка поместится в центр контрола
    @property (nonatomic, strong) UIView * _Nullable loadingView;
    
    /// нахлопка, которая будет нахлоплена (если она существует) после загрузки
    @property (nonatomic, strong) UIView * _Nullable overlayView;

------
    /// разрешить добавить анимацию в момент собственно загрузки фото (YES by default)
    @property (nonatomic, assign) BOOL allowLoadingAnimation;
    
    /// время анимации (default = 0, хотя это не значит что анимации нет, така вот фигня)
    @property (nonatomic, assign) CGFloat loadingAnimationDuration;

------
    /// если передать ненулевой size, то, после загрузки оригинала, картинка будет отресайжена в бекграунде (методом fillInSize) и отображена через setImage:
    @property (nonatomic, assign) CGSize resizeImageToSize;

    /// очищать изображение перед загрузкой нового
    @property (nonatomic, assign) BOOL hasToClearImage;

    @property (nonatomic, readonly, nullable) NSString *currentImageURLString;

------
    /// загрузить картинку из урла; можно загрузить nil == "обнулить" картинку
    - (void)loadImageFromUrl:(NSString *_Nullable)url;
    
    /// загрузить картинку из урла; можно загрузить nil == "обнулить" картинку
    - (void)loadImageFromUrl:(NSString *_Nullable)url withType:(ImageType)type;

    /// загрузить картинку из урла, forceLoad - если нужна принудительная загрузка, даже если урлы одинаковые
    - (void)loadImageFromUrl:(NSString *_Nullable)url forceLoad:(BOOL)forceLoad;
    - (void)loadImageFromUrl:(NSString *_Nullable)url withType:(ImageType)type forceLoad:(BOOL)forceLoad;

    /// отменить загрузку
    - (void)cancelLoading;

    /// загрузить в кеш пачку урлов
    + (void)preloadImages:(NSArray <NSString *> *_Nullable)urlList;
    + (void)preloadImages:(NSArray <NSString *> *_Nullable)urlList withType:(ImageType)type;

    /// получить картинку по текущему урлу с указанным типом
    - (void)getImageWithType:(ImageType)type onImageLoaded:(void (^_Nullable)(UIImage *_Nullable))onImageLoaded;

-----

    /// анимировать изменение contentMode (по дефолту 0, никаких анимаций)
    @property (nonatomic) NSTimeInterval contentModeAnimationDuration;
