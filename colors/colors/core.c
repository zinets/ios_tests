//
//  core.c
//  colors
//
//  Created by Zinets Victor on 10/21/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#include "core.h"

#define NUM_LEDS 30

static HSBColor leds[NUM_LEDS];
static int index = 0;
static int step = 1;
static int hue = 0;

HSBColor * init_leds() {
    for (int x = 0; x < NUM_LEDS; x++) {
        leds[x].hue = x * 10;
        leds[x].brightness = leds[x].saturation = 255;
    }
    return &leds[0];
}

// бегаем по радуге
void func1() {
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        
        if (x == index) {
            clr->brightness = 255;
        } else if (x == index - 1 || x == index + 1) {
            clr->brightness = 160;
        } else if (x == index - 2 || x == index + 2) {
            clr->brightness = 70;
        } else {
            clr->brightness = 0;
        }
    }

    index += step;
    if (index == NUM_LEDS || index == 0) {
        step = -step;
    }
}


void func2() {
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        
        if (x == index) {
            clr->brightness = 255;
        } else if (x == index - 1 || x == index + 1) {
            clr->brightness = 160;
        } else if (x == index - 2 || x == index + 2) {
            clr->brightness = 70;
        } else {
            clr->brightness = 0;
        }
        clr->hue = hue++;
    }
    
    index += step;
    if (index == NUM_LEDS || index == 0) {
        step = -step;
    }
    
    if (hue > 360) {
        hue = 0;
    }
}

void func3() {
    static int index1 = 0;
    static int index2 = NUM_LEDS - 1;
    static int step1 = 1;
    static int step2 = -1;
    
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        
        if (x == index1 || x == index2) {
            clr->brightness = 255;
        } else if (x == index1 - 1 || x == index1 + 1 ||
                   x == index2 - 1 || x == index2 + 1) {
            clr->brightness = 160;
        } else if (x == index1 - 2 || x == index1 + 2 ||
                   x == index2 - 2 || x == index2 + 2) {
            clr->brightness = 70;
        } else {
            clr->brightness = 0;
        }
    }
    
    index1 += step1;
    if (index1 == NUM_LEDS || index1 == 0) {
        step1 = -step1;
    }
    
    index2 += step2;
    if (index2 == NUM_LEDS || index2 == 0) {
        step2 = -step2;
    }
}

// сайлоны
void func4() {
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        
        if (x == index) {
            clr->brightness = 255;
        } else if (x == index - 1 || x == index + 1) {
            clr->brightness = 160;
        } else if (x == index - 2 || x == index + 2) {
            clr->brightness = 70;
        } else {
            clr->brightness = 0;
        }
        clr->hue = 0;
    }
    
    index += step;
    if (index == NUM_LEDS || index == 0) {
        step = -step;
    }
}

void func5() {
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        
        if (x == index) {
            clr->brightness = 255;
        } else if ((x == index - 1 && step > 0) || (x == index + 1 && step < 0)) {
            clr->brightness = 160;
        } else if ((x == index - 2 && step > 0) || (x == index + 2 && step < 0)) {
            clr->brightness = 70;
        } else {
            clr->brightness = 0;
        }
    }
    
    index += step;
    if (index == NUM_LEDS || index == 0) {
        step = -step;
    }
}

// перемещение "темного" участка
void func6() {
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        if (step > 0) { // идем вперед
            if (x == index) {
                clr->brightness = 64;
            } else if (x == index - 1) {
                clr->brightness = 128;
            } else {
                clr->brightness = 255;
            }
        } else {
            if (x == index) {
                clr->brightness = 64;
            } else if (x == index + 1) {
                clr->brightness = 128;
            } else {
                clr->brightness = 255;
            }
        }
    }
    
    index += step;
    if (index == NUM_LEDS || index == 0) {
        step = -step;
    }
}

// перемещение "темного" участка + морф цвета
void func7() {
    for (int x = 0; x < NUM_LEDS; x++) {
        HSBColor *clr = &leds[x];
        if (step > 0) { // идем вперед
            if (x == index) {
                clr->brightness = 64;
            } else if (x == index - 1) {
                clr->brightness = 128;
            } else {
                clr->brightness = 255;
            }
        } else {
            if (x == index) {
                clr->brightness = 64;
            } else if (x == index + 1) {
                clr->brightness = 128;
            } else {
                clr->brightness = 255;
            }
        }
        clr->hue = (clr->hue + 1) % 255;
    }
    
    index += step;
    if (index == NUM_LEDS || index == 0) {
        step = -step;
    }
}

// от центра заполнение цветом
void func8 () {
#define tail 5
#define b_step 20
    int count = 15;
    static int index1 = 15;
    static int index2 = 14;
    
    for (int x = 15; x < NUM_LEDS; x++) {
        HSBColor *clr1 = &leds[x];
        if (index1 == x) {
            clr1->brightness = 255;
        } else if (x >= 15 && x == index1 - 1) {
            clr1->brightness = 200;
        } else if (x >= 15 && x == index1 - 2) {
            clr1->brightness = 160;
        } else if (x >= 15 && x == index1 - 3) {
            clr1->brightness = 130;
        } else if (x >= 15 && x == index1 - 4) {
            clr1->brightness = 100;
        } else if (x >= 15 && x == index1 - 5) {
            clr1->brightness = 60;
        }




        
        HSBColor *clr2 = &leds[count - x - 1];
        
        
    }
    
    if (++index1 == NUM_LEDS) {
        index1 = 15;
    }
    if (--index2 == 0) {
        index2 = 14;
    }
}
