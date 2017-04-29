
#include <iostream>

#include <dlib/image_io.h>

#include <dlib/image_processing/frontal_face_detector.h>

#include <dlib/image_processing/render_face_detections.h>

#include <dlib/image_processing.h>

#include <dlib/gui_widgets.h>

using namespace dlib;

extern "C" {
void inline_c_Vision_DLib_FaceDetection_0_484bdfac94c6bf91d2be26982d0d32225f53245e(void * detector_inline_c_0, void * img_inline_c_1, int * intPtr_inline_c_2, void ** voidPtrPtr_inline_c_3) {

    frontal_face_detector * detector = (frontal_face_detector *)detector_inline_c_0;
    array2d<rgb_pixel> * img = (array2d<rgb_pixel> *)img_inline_c_1;
    std::vector<rectangle> rects = (* detector)(* img);
    (*intPtr_inline_c_2) = rects.size();
    (*voidPtrPtr_inline_c_3) = &rects[0];
  
}

}

extern "C" {
void * inline_c_Vision_DLib_FaceDetection_1_77b241a1280b0976adead6e1dd9b059752474a3c() {

  return new frontal_face_detector(get_frontal_face_detector());

}

}

extern "C" {
void * inline_c_Vision_DLib_FaceDetection_2_51890c99ccf9bfc52a3010abbc51bbe3e723f141() {

  return new shape_predictor();

}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_3_6e1d7c52ac209b26b4693fbf809c97cac86888a0(char * bs_inline_c_0, void * sp_inline_c_1) {

  deserialize(bs_inline_c_0) >> *((shape_predictor *)sp_inline_c_1);

}

}

extern "C" {
void * inline_c_Vision_DLib_FaceDetection_4_afdea7b22fed403b6fb086c4c88df20632553df6() {

  return new image_window();

}

}

extern "C" {
void * inline_c_Vision_DLib_FaceDetection_5_c05435ef078a01ef066ada7d40cbd57547e69955() {

  return new array2d<rgb_pixel>();

}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_6_567b6e6ea606b547e5362466501990261bf7f9d0(void * vPtr_inline_c_0, char * bs_inline_c_1, long bs_inline_c_2) {

    load_image(*(array2d<rgb_pixel> *)vPtr_inline_c_0, std::string(bs_inline_c_1, bs_inline_c_2));
  
}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_7_6f36c79344ee486a67035255f1a8eacc79ee1d42(void * img_inline_c_0) {

    pyramid_up(*(array2d<rgb_pixel> *)img_inline_c_0);
  
}

}

extern "C" {
void * inline_c_Vision_DLib_FaceDetection_8_85e3d089c86111ee7405a3b569ec155611d56b25() {
 return new full_object_detection(); 
}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_9_8707eb9a2ea16e08bc60dbf98d340b01b85b3b70(void * img_inline_c_0, void * sp_inline_c_1, void * rect_inline_c_2, void * shape_inline_c_3) {

    array2d<rgb_pixel> * img      = (array2d<rgb_pixel> *)    img_inline_c_0;
    shape_predictor * sp          = (shape_predictor *)       sp_inline_c_1;
    rectangle * rect              = (rectangle *)             rect_inline_c_2;
    full_object_detection * shape = (full_object_detection *) shape_inline_c_3;

    *shape = (*sp)(*img, *rect);
  
}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_10_36294a0fc4a6a5bcfa90cc2892f3519a83d49bd9(void * win_inline_c_0) {
 ((image_window *)win_inline_c_0)->clear_overlay(); 
}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_11_be2b4d935ac8c55dedb0d7dcdc9e2abf8970bb1c(void * win_inline_c_0, void * img_inline_c_1) {
 (*(image_window *)win_inline_c_0).set_image((array2d<rgb_pixel>*)img_inline_c_1);
}

}

extern "C" {
void inline_c_Vision_DLib_FaceDetection_12_b557bfdc1f756b7b712fbb0e667b55f57a8df2c8(void * win_inline_c_0, void * shape_inline_c_1) {
 (*(image_window *)win_inline_c_0).add_overlay(render_face_detections(*(full_object_detection*)shape_inline_c_1));
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_13_f77c3c93c2de4bf4d4b3b1af521a3543d1ad48a0() {
return ( sizeof(image_window) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_14_0d888696eab98c571f9b438b4409c0c90ae99774() {
return ( sizeof(array2d<rgb_pixel>) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_15_8cc000cc037e3b948548966e518aba74a4dc4c5a() {
return ( sizeof(full_object_detection) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_16_c1c388baa6692df8a68f0e217011dc1fa1079c89() {
return ( alignof(full_object_detection) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_17_4852b7d24ed0004697e33e30626c01d0388033fc() {
return ( sizeof(rectangle) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_18_fef4f49f629e58a8bf596cec33ce4b853222c9eb() {
return ( alignof(rectangle) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_19_caf22f7d218febeaeebaef180afc83fd9102dc7a() {
return ( sizeof(rgb_pixel) );
}

}

extern "C" {
int inline_c_Vision_DLib_FaceDetection_20_dd7245d1fec4f83bc1163051129e6a0e0a4ae7d2() {
return ( alignof(rgb_pixel) );
}

}
