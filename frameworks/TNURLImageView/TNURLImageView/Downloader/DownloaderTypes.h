//
//  DownloaderTypes.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#ifndef DownloaderTypes_h
#define DownloaderTypes_h

typedef NS_ENUM(NSInteger, DownloaderPriority) {
    DownloaderPriorityDefault, //выполняется в первую очередь ***и кенселится, если подписчики все удалились***
    DownloaderPriorityLow, //выполняется только тогда, когда не выполняются ничего с приоритетом выше
};

#endif /* DownloaderTypes_h */
