# Request POSIX Make behavior and disable any default suffix-based rules
.POSIX:
.SUFFIXES:


# Declare compiler tools and flags
CC      = cc
CFLAGS  = -std=c99
CFLAGS += -fPIC -g -Og
CFLAGS += -DGLFW_INCLUDE_NONE
CFLAGS += -Wall -Wextra -Wpedantic
CFLAGS += -Wno-unused-parameter -Wno-unused-result -Wno-unused-function
CFLAGS += -Ires/ -Isrc/ -Ivendor/include/
LDFLAGS =
LDLIBS  = -lGL -lglfw


# Declare which targets should be built by default
default: flappy


# Declare library sources
libflappy_sources =    \
  src/opengl.c         \
  src/shader.c
libflappy_objects = $(libflappy_sources:.c=.o)

# Express dependencies between object and source files
src/opengl.o: src/opengl.c src/opengl.h
src/shader.o: src/shader.c src/shader.h

# Build the static library
libflappy.a: $(libflappy_objects)
	@echo "STATIC  $@"
	@$(AR) rcs $@ $(libflappy_objects)

# Double suffix rule for compiling .c files to .o object files
.SUFFIXES: .c .o
.c.o:
	@echo "CC      $@"
	@$(CC) $(CFLAGS) -c -o $@ $<


# Declare required resource headers
resource_headers =         \
  res/models/square.h      \
  res/shaders/bg_frag.h    \
  res/shaders/bg_vert.h    \
  res/shaders/bird_frag.h  \
  res/shaders/bird_vert.h  \
  res/shaders/demo_frag.h  \
  res/shaders/demo_vert.h  \
  res/shaders/fade_frag.h  \
  res/shaders/fade_vert.h  \
  res/shaders/pipe_frag.h  \
  res/shaders/pipe_vert.h  \
  res/textures/bg.h        \
  res/textures/bird.h      \
  res/textures/pipe.h

# Express dependencies between header and resource files
res/models/square.h: res/models/square.obj venv
res/shaders/bg_frag.h: res/shaders/bg_frag.glsl venv
res/shaders/bg_vert.h: res/shaders/bg_vert.glsl venv
res/shaders/bird_frag.h: res/shaders/bird_frag.glsl venv
res/shaders/bird_vert.h: res/shaders/bird_vert.glsl venv
res/shaders/demo_frag.h: res/shaders/demo_frag.glsl venv
res/shaders/demo_vert.h: res/shaders/demo_vert.glsl venv
res/shaders/fade_frag.h: res/shaders/fade_frag.glsl venv
res/shaders/fade_vert.h: res/shaders/fade_vert.glsl venv
res/shaders/pipe_frag.h: res/shaders/pipe_frag.glsl venv
res/shaders/pipe_vert.h: res/shaders/pipe_vert.glsl venv
res/textures/bg.h: res/textures/bg.jpeg venv
res/textures/bird.h: res/textures/bird.png venv
res/textures/pipe.h: res/textures/pipe.png venv


# Compile and link the main executable
flappy: src/main.c libflappy.a $(resource_headers)
	@echo "EXE     $@"
	@$(CC) $(CFLAGS) $(LDFLAGS) -o $@ src/main.c libflappy.a $(LDLIBS)


# Create the virtualenv for pre/post build scripts
venv:
	@echo "VENV    venv/"
	@python3 -m venv venv/
	@./venv/bin/pip install -Uq wheel
	@echo "REQS    scripts/requirements.txt"
	@./venv/bin/pip install -Uq -r scripts/requirements.txt

# Double suffix rules for convertion resource files to header files
.SUFFIXES: .obj .h
.obj.h:
	@echo "MODEL   $@"
	@./venv/bin/python3 scripts/res2header.py $< $@

.SUFFIXES: .glsl .h
.glsl.h:
	@echo "SHADER  $@"
	@./venv/bin/python3 scripts/res2header.py $< $@

.SUFFIXES: .bmp .h
.bmp.h:
	@echo "TEXTURE $@"
	@./venv/bin/python3 scripts/res2header.py $< $@

.SUFFIXES: .jpeg .h
.jpeg.h:
	@echo "TEXTURE $@"
	@./venv/bin/python3 scripts/res2header.py $< $@

.SUFFIXES: .jpg .h
.jpg.h:
	@echo "TEXTURE $@"
	@./venv/bin/python3 scripts/res2header.py $< $@

.SUFFIXES: .png .h
.png.h:
	@echo "TEXTURE $@"
	@./venv/bin/python3 scripts/res2header.py $< $@

.SUFFIXES: .tga .h
.tga.h:
	@echo "TEXTURE $@"
	@./venv/bin/python3 scripts/res2header.py $< $@


# Helper target that cleans up build artifacts
.PHONY: clean
clean:
	rm -fr flappy *.exe *.a *.so *.dll src/*.o res/models/*.h res/shaders/*.h res/textures/*.h
