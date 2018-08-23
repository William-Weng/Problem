//
//  OpenCVMethods.mm
//  UseOpenCVInSwiftDemo
//
//  Created by yangyang on 17/10/2017.
//  Copyright © 2017 yangguang. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCV-Bridging-Header.h"

@implementation OpenCVMethods: NSObject

using namespace cv;

+ (BOOL)testColorWithR:(int)R G:(int)G B:(int)B {
    bool e1 = (R>95) && (G>40) && (B>20) && ((max(R,max(G,B)) - min(R, min(G,B)))>15) && (abs(R-G)>15) && (R>G) && (R>B);
    bool e2 = (R>220) && (G>210) && (B>170) && (abs(R-G)<=15) && (R>B) && (G>B);
    return (e1||e2);
}

+ (BOOL)testColorWithY:(int)Y Cr:(int)Cr Cb:(int)Cb {
    bool e3 = Cr <= 1.5862*Cb+20;
    bool e4 = Cr >= 0.3448*Cb+76.2069;
    bool e5 = Cr >= -4.5652*Cb+234.5652;
    bool e6 = Cr <= -1.15*Cb+301.75;
    bool e7 = Cr <= -2.2857*Cb+432.85;
    return e3 && e4 && e5 && e6 && e7;
}

+ (BOOL)testColorWithH:(int)H S:(int)S V:(int)V {
    return (H < 25) || (H > 230);
}

+ (UIImage *)searchFaceImage:(UIImage *)image {
    
    Mat src;
    UIImageToMat(image, src);
    Mat dst = src.clone();

    Vec3b cwhite = Vec3b::all(255);
    Vec3b cblack = Vec3b::all(0);
    
    Mat src_ycrcb, src_hsv;
    cvtColor(src, src_ycrcb, CV_BGR2YCrCb);
    src.convertTo(src_hsv, CV_32FC3);
    cvtColor(src_hsv, src_hsv, CV_BGR2HSV);
    
    normalize(src_hsv, src_hsv, 0.0, 255.0, NORM_MINMAX, CV_32FC3);
    
    for(int i = 0; i < src.rows; i++) {
        
        for(int j = 0; j < src.cols; j++) {
            
            Vec3b pix_bgr = src.ptr<Vec3b>(i)[j];
            int B = pix_bgr.val[0];
            int G = pix_bgr.val[1];
            int R = pix_bgr.val[2];
            
            Vec3b pix_ycrcb = src_ycrcb.ptr<Vec3b>(i)[j];
            int Y = pix_ycrcb.val[0];
            int Cr = pix_ycrcb.val[1];
            int Cb = pix_ycrcb.val[2];
            
            Vec3f pix_hsv = src_hsv.ptr<Vec3f>(i)[j];
            float H = pix_hsv.val[0];
            float S = pix_hsv.val[1];
            float V = pix_hsv.val[2];
            
            bool rgb = [self testColorWithR:R G:G B:B];
            bool yCrCb = [self testColorWithY:Y Cr:Cr Cb:Cb];
            bool hsv = [self testColorWithH:H S:S V:V];
            
            if(!(rgb && yCrCb && hsv)) {
                dst.ptr<Vec3b>(i)[j] = cblack;
            }
        }
    }
    
    return MatToUIImage(dst);
}

@end

