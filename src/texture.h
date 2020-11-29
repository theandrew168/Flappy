#ifndef FLAPPY_TEXTURE_H_INCLUDED
#define FLAPPY_TEXTURE_H_INCLUDED

enum texture_format {
    TEXTURE_FORMAT_UNDEFINED = 0,
    TEXTURE_FORMAT_RGB,
    TEXTURE_FORMAT_RGBA,
};

struct texture {
    int format;
    long width;
    long height;
    char* pixels;
};

#endif
