{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE CPP #-}

module Vision.DLib.FaceDetection where

import qualified Data.ByteString.Char8 as BS
import qualified Language.C.Inline as C
import qualified Language.C.Types as C
import qualified Language.C.Inline.Context as C
import qualified Language.C.Inline.Cpp as C
import qualified Data.Vector.Storable as V
import qualified Data.Map as Map
import           Data.Monoid ((<>))
import           Vision.DLib.Types
import           Foreign.C.Types
import           Foreign.ForeignPtr
import           Foreign.Ptr
import           Foreign.Marshal.Array

C.context (C.cppCtx <> C.bsCtx <> C.vecCtx)

C.include "<iostream>"
C.include "<dlib/image_io.h>"
C.include "<dlib/image_processing/frontal_face_detector.h>"
C.include "<dlib/image_processing/render_face_detections.h>"
C.include "<dlib/image_processing.h>"
C.include "<dlib/gui_widgets.h>"

C.using "namespace dlib"


runFaceDetector :: FrontalFaceDetector -> Image -> IO [Rectangle]
runFaceDetector (FrontalFaceDetector detector) (Image p) = do
  let img = castPtr p
  (n, voidPtr) <- C.withPtrs_ $ \(intPtr, voidPtrPtr) -> [C.block| void {
    frontal_face_detector * detector = (frontal_face_detector *)$(void * detector);
    array2d<rgb_pixel> * img = (array2d<rgb_pixel> *)$(void * img);
    std::vector<rectangle> rects = (* detector)(* img);
    (*$(int * intPtr)) = rects.size();
    (*$(void ** voidPtrPtr)) = &rects[0];
  }|]
  peekArray (fromIntegral n) (castPtr voidPtr)



getFrontalFaceDetector :: IO FrontalFaceDetector
getFrontalFaceDetector = FrontalFaceDetector <$> [C.block| void * {
  return new frontal_face_detector(get_frontal_face_detector());
} |]

mkShapePredictor :: IO ShapePredictor
mkShapePredictor = ShapePredictor <$> [C.block| void * {
  return new shape_predictor();
} |]

deserializeIntoShapePredictor :: String -> ShapePredictor -> IO ()
deserializeIntoShapePredictor value (ShapePredictor sp) = let bs = BS.pack value
                                         in [C.block| void {
  deserialize($bs-ptr:bs) >> *((shape_predictor *)$(void * sp));
} |]

mkImageWindow :: IO ImageWindow
mkImageWindow = ImageWindow <$> [C.block| void * {
  return new image_window();
} |]

mkImage :: IO Image
mkImage = Image <$> castPtr <$> [C.block| void * {
  return new array2d<rgb_pixel>();
} |]

loadImage :: String -> Image -> IO ()
loadImage filename i@(Image img) = do
  let bs = BS.pack filename
  let vPtr = castPtr img
  [C.block| void {
    load_image(*(array2d<rgb_pixel> *)$(void * vPtr), std::string($bs-ptr:bs, $bs-len:bs));
  } |]

pyramidUp :: Image -> IO ()
pyramidUp (Image p) = do
  let img = castPtr p
  [C.block| void {
    pyramid_up(*(array2d<rgb_pixel> *)$(void * img));
  } |]

mkShape :: IO Shape
mkShape = Shape <$> [C.block| void * { return new full_object_detection(); } |]


runShapePredictor :: ShapePredictor -> Image -> Ptr Rectangle -> IO Shape
runShapePredictor shapePredictor image det = do
  let img = castPtr $ unImage image
  let sp = castPtr $ unShapePredictor shapePredictor
  let rect = castPtr $ det
  shape <- unShape <$> mkShape
  [C.block| void {
    array2d<rgb_pixel> * img      = (array2d<rgb_pixel> *)    $(void * img);
    shape_predictor * sp          = (shape_predictor *)       $(void * sp);
    rectangle * rect              = (rectangle *)             $(void * rect);
    full_object_detection * shape = (full_object_detection *) $(void * shape);

    *shape = (*sp)(*img, *rect);
  } |]
  return $ Shape shape

clearOverlay :: ImageWindow -> IO ()
clearOverlay (ImageWindow win) = do
  [C.block| void { ((image_window *)$(void * win))->clear_overlay(); }|]

setImage :: ImageWindow -> Image -> IO ()
setImage (ImageWindow win) (Image imgPtr) = do
  let img = castPtr imgPtr
  [C.block| void { (*(image_window *)$(void * win)).set_image((array2d<rgb_pixel>*)$(void * img));}|]

addDetectionOverlay :: ImageWindow -> Shape -> IO ()
addDetectionOverlay (ImageWindow win) (Shape shape) = do
  [C.block| void { (*(image_window *)$(void * win)).add_overlay(render_face_detections(*(full_object_detection*)$(void * shape)));}|]


sizeofImageWindow :: CInt
sizeofImageWindow = [C.pure| int { sizeof(image_window) } |]

sizeofImage :: CInt
sizeofImage = [C.pure| int { sizeof(array2d<rgb_pixel>) } |]

sizeofShape :: CInt
sizeofShape = [C.pure| int { sizeof(full_object_detection) } |]

fullObjectDetectionAlignment :: CInt
fullObjectDetectionAlignment = [C.pure| int { alignof(full_object_detection) } |]

sizeofRectangle :: CInt
sizeofRectangle = [C.pure| int { sizeof(rectangle) } |]

rectangleAlignment :: CInt
rectangleAlignment = [C.pure| int { alignof(rectangle) } |]

sizeofRGBPixel :: CInt
sizeofRGBPixel = [C.pure| int { sizeof(rgb_pixel) } |]

rgbPixelAlignment :: CInt
rgbPixelAlignment = [C.pure| int { alignof(rgb_pixel) } |]
