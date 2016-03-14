//
//  HBImageScroller.m
//  MyTest
//
//  Created by weqia on 13-7-31.
//  Copyright (c) 2013年 weqia. All rights reserved.
//

#import "HBImageScroller.h"
//#import "HBHttpRequestCache.h"
//#import "DialogUtil.h"
//#import "HBHttpImageDownloader.h"
@implementation HBImageScroller
@synthesize imageView=_imageView,controller;

#pragma -mark 覆盖父类的方法


#pragma -mark 事件响应方法
-(void)longPressAction:(UIGestureRecognizer*)sender
{
    if(sender.state==UIGestureRecognizerStateBegan){
        if(self.controller){
            UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",@"分享到", nil];
            [action showInView:[UIApplication sharedApplication].keyWindow];
        }else{
            UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
            [action showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

-(void)imagePinchAction:(UIPinchGestureRecognizer*)recognizer
{
    if(recognizer.state==UIGestureRecognizerStateBegan)
    {
        _beginSize=_imageView.frame.size;
    }
    else if(recognizer.state==UIGestureRecognizerStateChanged)
    {
        int width= _beginSize.width*recognizer.scale;
        int height=_imgScale*width;
        if(width<_scale*1.5*_beginImageSize.width&&width>0.5*_beginImageSize.width)
        {
            CGSize size=CGSizeMake(width, height);
            if (size.height<self.frame.size.height) {
                size.height=self.frame.size.height;
            }
            if (size.width<self.frame.size.width) {
                size.width=self.frame.size.width;
            }
            self.contentSize=size;
            float x=0,y=0;
            if (width<self.frame.size.width) {
                x=(self.frame.size.width-width)/2;
            }
            if (height<self.frame.size.height) {
                y=(self.frame.size.height-height)/2;
            }
             _imageView.frame=CGRectMake(x,y , width, height);

        }
    }
    else if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        if(_imageView.frame.size.width<_beginImageSize.width)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [self setImageFrameAndContentSize];
            self.contentSize=self.frame.size;
            [UIView commitAnimations];
            max=NO;
        }
        else if(_imageView.frame.size.width>_scale*_beginImageSize.width)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            CGSize size=self.contentSize;
            size.width=_beginImageSize.width*_scale;
            size.height=_imgScale*size.width;
            float x=0,y=0;
            if (size.height<self.frame.size.height) {
                size.height=self.frame.size.height;
            }
            if (size.width<self.frame.size.width) {
                size.width=self.frame.size.width;
            }
            self.contentSize=size;
            _imageView.frame= CGRectMake(x, y, size.width, size.height);
            [UIView commitAnimations];
            max=YES;
        }

    }
}

-(void)imageTapTwoAction:(UIGestureRecognizer*)recognizer
{
        if(max)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [self setImageFrameAndContentSize];
            self.contentSize=self.frame.size;
            [UIView commitAnimations];
            max=NO;
        }else{
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            CGSize size=self.contentSize;
            size.width=_beginImageSize.width*_scale;
            size.height=_imgScale*size.width;
            float x=0,y=0;
            if (size.height<self.frame.size.height) {
                y=(self.frame.size.height-size.height)/2;
                size.height=self.frame.size.height;
            }
            if (size.width<self.frame.size.width) {
                x=(self.frame.size.width-size.width)/2;
                size.width=self.frame.size.width;
            }
            self.contentSize=size;
            _imageView.frame= CGRectMake(x, y, size.width, size.height);

            LocationRegion region=[self getLocationRegion:[recognizer locationInView:self]];
            switch (region) {
                case RegionTopLeft:
                    break;
                case RegionBottomLeft:
                    [self scrollRectToVisible:CGRectMake(0, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:NO];
                    break;
                case RegionTopRight:
                    [self scrollRectToVisible:CGRectMake(self.contentSize.width-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
                    break;
                case RegionBottomRight:
                    [self scrollRectToVisible:CGRectMake(self.contentSize.width-self.frame.size.width, self.contentSize.height-self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:NO];
                    break;
                default:
                    break;
            }

            [UIView commitAnimations];
            max=YES;
            
        }
}

-(void)imageTapOnceAction:(UIGestureRecognizer*)recognizer
{
    if(_tapOnceAction&&_target&&[_target respondsToSelector:_tapOnceAction])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_tapOnceAction withObject:_imageView];

#pragma clang diagnostic pop

}

#pragma -mark 回调方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        UIImageWriteToSavedPhotosAlbum(_imageView.image, self,@selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else if(buttonIndex==1){
        
    }
}
-(void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo 
{
//    if(error){
//        [[DialogUtil sharedInstance] showDlg:self textOnly:@"图片保存失败"];
//    }else{
//        [[DialogUtil sharedInstance] showDlg:self textOnly:@"图片保存成功"];
//    }
}
#pragma -mark 私有方法
-(CGRect)getFrameForImageView
{
    CGSize  size=_imageView.image.size;
    CGRect rect=self.frame;
    CGRect frame;

    float imgScale=size.height/size.width;
    float viewScale=rect.size.height/rect.size.width;
    float width=size.width,height=size.height;
    if(imgScale<viewScale&&size.width>rect.size.width){
        width=rect.size.width;
        height=width*imgScale;
        _scale=rect.size.height/height;
    }else if(imgScale>=viewScale&&size.height>rect.size.height){
        height=rect.size.height;
        width=height/imgScale;
        _scale=rect.size.width/width;
    }else{
         _scale=rect.size.width/width;
    }
    float x=0,y=0;
    if (width<rect.size.width) {
        x=(rect.size.width-width)/2;
    }if(height<rect.size.height){
        y=(rect.size.height-height)/2;
    }
    frame=CGRectMake(x, y, width, height);
    
    return frame;
}

-(void)setImageFrameAndContentSize
{
    CGRect frame = [self getFrameForImageView];
    _imageView.frame = frame;
    _beginImageSize = _imageView.frame.size;
    _imgScale = _imageView.image.size.height/_imageView.image.size.width;
    self.contentSize = self.frame.size;
}


-(LocationRegion)getLocationRegion:(CGPoint)point
{
    float width=self.frame.size.width;
    float height=self.frame.size.height;
    if(point.x<width/2)
    {
        if(point.y<height/2)
            return RegionTopLeft;
        else
            return RegionBottomLeft;
    }
    else
    {
        if(point.y<height/2)
            return RegionTopRight;
        else
            return RegionBottomRight;
    }
}

#pragma -mark 接口方法
-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self)
    {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        UITapGestureRecognizer * tapOnce=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapOnceAction:)];
        tapOnce.numberOfTapsRequired=1;
        tapOnce.numberOfTouchesRequired=1;
        [self addGestureRecognizer:tapOnce];
        _imageView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer* tapTwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapTwoAction:)];
        tapTwo.numberOfTapsRequired=2;
        tapTwo.numberOfTouchesRequired=1;
        [tapOnce requireGestureRecognizerToFail:tapTwo];
        [_imageView addGestureRecognizer:tapTwo];
        
        
        UIPinchGestureRecognizer * pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imagePinchAction:)];
        [_imageView addGestureRecognizer:pinch];
        _imageView.contentMode=UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds=YES;
        max=NO;
        _tapOnceAction=nil;
        _target=nil;
        self.contentSize=self.frame.size;
    }
    return self;
}

-(id)initWithImage:(UIImage*)image andFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:image];
    }
    return self;
}


-(void)setImage:(UIImage*)image
{
    // Initialization code
    _imageView.image=image;
    [self setImageFrameAndContentSize];
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

-(void)setImageWithURL:(NSString *)url
{
    [self setImageWithURL:url andSmallImage:nil];
}

-(void)setImageWithURL:(NSString*)url  andSmallImage:(UIImage*)image
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _imageView.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
        [self setImageFrameAndContentSize];
    }];
}

-(void)addTarget:(id)target tapOnceAction:(SEL)action
{
    _target=target;
    _tapOnceAction=action;
}

-(void)reset
{
    [self setImageFrameAndContentSize];
}

@end
