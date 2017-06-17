//
//  MTMusicOperations.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/3.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTMusicOperations.h"

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MTMusicOperations ()

@end



@implementation MTMusicOperations

+ (NSArray *)MusicArray{
    
    NSMutableArray *musicArray = [[NSMutableArray alloc] init];
    
    MPMediaQuery *listQuery = [MPMediaQuery playlistsQuery];
    NSArray *playList = [listQuery collections];
    
    for (MPMediaPlaylist *list in playList) {
        NSArray *items = [list items];
        for (MPMediaItem *item in items) {
            
            [musicArray addObject:item];
        }
    }
    return musicArray;
}

@end