#ifndef FLAPPY_MODEL_H_INCLUDED
#define FLAPPY_MODEL_H_INCLUDED

enum model_format {
    MODEL_FORMAT_UNDEFINED = 0,
    MODEL_FORMAT_V3F,
    MODEL_FORMAT_N3F_V3F,
    MODEL_FORMAT_T2F_N3F_V3F,
};

struct model {
    int format;
    long count;
    float* vertices;
};

#endif
