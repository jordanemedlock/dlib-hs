module Main where

import Foreign.Storable
import Vision.DLib
import System.Environment
import Control.Monad
import Foreign.Marshal.Array
import Foreign.Ptr

main = do
  -- print $ fullObjectDetectionAlignment
  -- print $ sizeofFullObjectDetection
  detector <- getFrontalFaceDetector
  shapePredictor <- mkShapePredictor

  deserializeIntoShapePredictor "reference/shape_predictor_68_face_landmarks.dat" shapePredictor

  win <- mkImageWindow
  winFaces <- mkImageWindow

  files <- getArgs
  forM_ files $ \file -> do
    putStrLn $ "processing image " ++ file

    img <- mkImage
    loadImage file img
    pyramidUp img

    dets <- runFaceDetector detector img

    print $ length dets
    print dets

    shapes <- withArray dets $ \arrPtr -> do
      forM [0..length dets-1] $ \i -> do
        let rect = arrPtr `plusPtr` i
        runShapePredictor shapePredictor img rect

    print shapes

    return ()
