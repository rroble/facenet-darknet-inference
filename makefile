CC = gcc
CPC = g++
OPENCV_HEADER_DIR = /usr/local/include
OPENCV_LIBRARY_DIR = /usr/local/lib
DLIB_HEADER_DIR = ./vendor/dlib
DLIB_LIBRARY_DIR = ./vendor/dlib/build/dlib
NNPACK_HEADER_DIR = ./vendor/NNPACK-darknet/include
NNPACK_LIBRARY_DIR = ./vendor/NNPACK-darknet/lib


INCLUDES += -I $(OPENCV_HEADER_DIR)
INCLUDES += -I $(DLIB_HEADER_DIR)
INCLUDES += -I $(NNPACK_HEADER_DIR)
INCLUDES += -I ./vendor/NNPACK-darknet/deps/pthreadpool/include

DEFINES += -D OPENCV -D NNPACK

LDFLAGS += -L $(OPENCV_LIBRARY_DIR) -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_objdetect -lopencv_calib3d
LDFLAGS += -L $(DLIB_LIBRARY_DIR) -ldlib
LDFLAGS += -L $(NNPACK_LIBRARY_DIR) -lnnpack -lpthreadpool -lpthread -lopencv_imgcodecs -lopencv_videoio

APP_NAME += facenet-darknet-inference

all: test.o run_darknet.o face_io.o activation_layer.o activations.o avgpool_layer.o batchnorm_layer.o blas.o connected_layer.o convolutional_layer.o gemm.o im2col.o image.o layer.o list.o maxpool_layer.o network.o normalization_layer.o option_list.o parser.o route_layer.o shortcut_layer.o utils.o
	$(CPC) -o $(APP_NAME) test.o run_darknet.o face_io.o activation_layer.o activations.o avgpool_layer.o batchnorm_layer.o blas.o connected_layer.o convolutional_layer.o gemm.o im2col.o image.o layer.o list.o maxpool_layer.o network.o normalization_layer.o option_list.o parser.o route_layer.o shortcut_layer.o utils.o $(LDFLAGS)

test.o:
	$(CPC) -c -pipe -std=c++11 -O2 $(DEFINES) $(INCLUDES) test.cpp

run_darknet.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) run_darknet.c

face_io.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) face_io.c

activation_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) activation_layer.c

activations.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) activations.c

avgpool_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) avgpool_layer.c

batchnorm_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) batchnorm_layer.c

blas.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) blas.c

connected_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) connected_layer.c

convolutional_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) convolutional_layer.c

gemm.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) gemm.c

im2col.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) im2col.c

image.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) image.c

layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) layer.c

list.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) list.c

maxpool_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) maxpool_layer.c

network.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) network.c

normalization_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) normalization_layer.c

option_list.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) option_list.c

parser.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) parser.c

route_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) route_layer.c

shortcut_layer.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) shortcut_layer.c

utils.o:
	$(CC) -c -pipe -O2 $(DEFINES) $(INCLUDES) utils.c

clean:
	rm -f test.o run_darknet.o face_io.o activation_layer.o activations.o avgpool_layer.o batchnorm_layer.o blas.o connected_layer.o convolutional_layer.o gemm.o im2col.o image.o layer.o list.o maxpool_layer.o network.o normalization_layer.o option_list.o parser.o route_layer.o shortcut_layer.o utils.o

DIR := $(shell pwd)
VENDOR := $(DIR)/vendor
setup:
	[ ! -f "$(DIR)/facenet-darknet-inference" ]

	[ ! -d "$(VENDOR)" ] && mkdir "$(VENDOR)" || true

	[ ! -d "$(VENDOR)/dlib" ] && cd $(VENDOR) && git clone https://github.com/davisking/dlib.git || true
	[ ! -d "$(VENDOR)/dlib/build" ] && cd "$(VENDOR)/dlib" && mkdir build && cd build && cmake .. && cmake --build . || true

	[ ! -d "$(VENDOR)/NNPACK-darknet" ] && cd $(VENDOR) && git clone https://github.com/digitalbrain79/NNPACK-darknet.git || true
	[ ! -d "$(VENDOR)/NNPACK-darknet/lib" ] && pip install --upgrade git+https://github.com/Maratyszcza/PeachPy || true
	[ ! -d "$(VENDOR)/NNPACK-darknet/lib" ] && pip install --upgrade git+https://github.com/Maratyszcza/confu || true
	[ ! -d "$(VENDOR)/NNPACK-darknet/lib" ] && cd "$(VENDOR)/NNPACK-darknet" && confu setup && python ./configure.py && ninja || true

	[ ! -d "$(DIR)/weights" -a ! -f "$(DIR)/weights.tar.gz.aa" ] && \
	axel "https://github.com/rroble/facenet-darknet-inference/raw/weights/weights.tar.gz.aa" || true
	[ ! -d "$(DIR)/weights" -a ! -f "$(DIR)/weights.tar.gz.ab" ] && \
	axel "https://github.com/rroble/facenet-darknet-inference/raw/weights/weights.tar.gz.ab" || true
	[ ! -d "$(DIR)/weights" -a ! -f "$(DIR)/weights.tar.gz.ac" ] && \
	axel "https://github.com/rroble/facenet-darknet-inference/raw/weights/weights.tar.gz.ac" || true
	[ ! -f "$(DIR)/weights.tar.gz" ] && cat weights.tar.gz.* > "$(DIR)/weights.tar.gz" || true
	[ ! -d "$(DIR)/weights" ] && tar -xf "$(DIR)/weights.tar.gz" || true
