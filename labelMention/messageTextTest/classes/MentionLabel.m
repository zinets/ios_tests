//
//  MentionLabel.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/19/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "MentionLabel.h"
#import <CoreText/CoreText.h>

@implementation MentionLabel

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _mentionColor = [UIColor whiteColor];
    _mentionCornerRadius = 5;
    _mentionPadding = 2;
    _mentionTextColor = [self.textColor copy];
}

- (void)drawRect:(CGRect)rect {
    [self draw3:rect];
    
    //    [super drawRect:rect];
}

- (void)draw3:(CGRect)rect {
    // как меня задрал этот код!! я ненавижу тексты
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    CGContextFillRect(context, rect);
    // просто для наглядности залью все жОлтым
    
    CGContextSetFillColorWithColor(context, self.mentionColor.CGColor);
    // а сноски будут фиолетовыми в крапинку
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // чернопроходцы все не могут решить, где ж зад, где перед - переворачиваем Y
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    // rect нам пришел готовый, label расперта констрантами и содержимым занимает идеально вот столько места - rect
    // и фреймсеттер будет ограничивать вывод текста этим path (чернопрохдцы могут тут даже ограничить текст кружальцем.. или цветным флагом)
    
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (__bridge CFStringRef)self.text);
    // тут для меня магия; целый день нихера не получалось, потому что передавал текст вот так (__bridge CFAttributedStringRef)self.attributedText - каким-то образом он воспринималься фреймсеттером в одну строку и я трахал моск не понимая, почему только первый @aaa подсвечивается; потом выяснилось, что не первый, а только в первой строке..
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    // а если так - то она обрезается.. странно
    //    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText); вот если оставить этот код, то получим одну строку, обрезанную "..."
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);

    // забавное: если рисовать фрейм здесь - то потом балунчики рисуются черного цвета, если в конце метожа - то правильного пурпленого.. никуа не понимаю :)
//    CTFrameDraw(frame, context);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    // вот сейчас в lines > 1 строки; правда тут нужно наверное применить атрибуты к тексту, взяв их у self - потому что кажется, что шрифт мельче, может другое начертание, переносы в других местах; но то потом
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    // типа обращаем внимание - вдруг юзер задал определенное кол-во строк; задрот..
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    // пиу-пиу - получили орижины строк; фреймсеттер разбил текст на lines, исходя из текущего шрифта и ограничивающего path
    // каждая строка состоит из runs (бл я хз как по кацапски) - наборов глифов, "..бегущих в одну сторону" :)
    
    NSString *obisyana = @"\\B\\@([\\w\\-]+)";
    NSRange r = [self.text rangeOfString:obisyana options:NSRegularExpressionSearch];
    // подход "ищем слово с обизянкой, пока слова находятся - ищем их в строках"
    // можжет надо "перебрать строки, в каждой искать обизянок", но пусть сначала заработает
    while (r.location != NSNotFound) {
        NSLog(@"%@", NSStringFromRange(r));
        
        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
            CGPoint lineOrigin = lineOrigins[lineIndex];
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            CFRange lineRange = CTLineGetStringRange(line);
            // взяли строку, ну не строку, но в общем строку; и получили область этой строки в исходном тексте - и смотрим, не в ней ли находится очередное найденное слово-обизянка
            if (r.location >= lineRange.location && r.location < lineRange.location + lineRange.length) {
                // чото ссыкотно, правильно ли я условие написал?..
                
                // тупо, хотя по идее сойдет, зачем усложнять что работает: это позиция слова-обизянки в строке (одной из, а не вообще в тексте)
                CFIndex index = r.location - lineRange.location;
                CFArrayRef glyphRuns = CTLineGetGlyphRuns(line);
                CFIndex glyphCount = CFArrayGetCount(glyphRuns);
                // тут я хз.. сейчас вроде возвращается все время count = 1, но __вроде__ раньше бывало 2 (хотя столько вариантов кода было, что я хз)
                // но проверку какую-то наверное надо; но не знаю какую и вообще пусть хоть чтото заработает
                for (CFIndex glyphIndex = 0; glyphIndex < glyphCount; glyphIndex++) {
                    CTRunRef run = CFArrayGetValueAtIndex(glyphRuns, glyphIndex);
                    // в общем берем все.. эти штуки, в которых глифы бегут в одну сторону; по какой тогда причине их - run - может быть > 1 в одной строке? типа "разорвало хитрым path в виде буквы M"?
                    // и у очередного - единственного пока что в моих тестах - run получаем параметры "шрифтовые" ширина глифов в указанном диапазоне, побочно получая высоту шрифта над базовой линией и под - она будет использоваться.. как высота :) а leading за компанию, но он не нужен
                    // может нужен для каких-то китайцев, я хз
                    CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
                    CGFloat w = CTRunGetTypographicBounds(run, CFRangeMake(index, r.length), &ascent, &descent, &leading);
                    // ширина допустим есть; с x работает каким то чудом: я спрашиваю отступ для символов в промежутке; но к примеру в 3й строке отступ для слова, которое начинается с 8й позиции - надо спрашивать не с stringIndex = 8 - а позицию 3й строки + 8 - чука ну вообще не очевидно было
                    CGFloat xMin = CTLineGetOffsetForStringIndex(line, lineRange.location + index, NULL);
                    // так чтоб прям уперется справа в край контрола это вряд ли, а слева может обрезаться край
                    CGFloat dx = xMin > 0 ? self.mentionPadding : 0;
                    CGFloat yMin = lineOrigin.y - descent;
                    CGFloat dy = yMin > 0 ? self.mentionPadding : 0;
                    // ну и наконец вроде все ж готиво; но ascent + descent вроде и высота текста, а визуально х зна что получается, ровно от базовой линии и вверх
                    CGRect frm = (CGRect){xMin - dx, yMin - dy, dx + w + self.mentionPadding, dy + (ascent + descent) + self.mentionPadding};

                    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frm cornerRadius:self.mentionCornerRadius];
                    CGContextAddPath(context, path.CGPath);
                    CGContextFillPath(context);
                    // тадам! нарисовал балунчик чотко под словом-обизянкой
                }
            }
        }
        
        NSInteger nextLocation = r.location + r.length;
        NSInteger remainingLength = [self.text length] - nextLocation;
        r = [self.text rangeOfString:obisyana options:NSRegularExpressionSearch range:(NSRange){nextLocation, remainingLength}];
    }
    
    // finnaly - кончились слова, надо освободить память и наросовать текст
    CFRelease(framesetter);
    CFRelease(path);
    
    CTFrameDraw(frame, context);
    CFRelease(frame);
    
    // хз, может что потерял - найдется в фабрике когда падать начнет
    // но выглядит результат совсем не так, как если бы вызвать drawRect суперовский и ничего больше не делать
    
    
}

-(void)setMentionColor:(UIColor *)mentionColor {
    _mentionColor = mentionColor;
    [self setNeedsDisplay];
}

@end

