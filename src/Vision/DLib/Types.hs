module Vision.DLib.Types (
  FrontalFaceDetector(..),
  ShapePredictor(..),
  ImageWindow(..),
  Image(..),
  Array2D(..),
  RGBPixel(..),
  Rectangle(..),
  Shape(..),
  zeroRect
) where

import           Foreign.C.Types
import           Foreign.Ptr
import           Foreign.Storable
import           Vision.DLib.Internal.Types

newtype FrontalFaceDetector = FrontalFaceDetector (Ptr ()) deriving (Show)
newtype ShapePredictor = ShapePredictor { unShapePredictor :: (Ptr ()) } deriving (Show)
newtype ImageWindow = ImageWindow (Ptr ()) deriving (Show)
newtype Image = Image { unImage :: (Ptr (Array2D RGBPixel)) } deriving (Show)
newtype Shape = Shape { unShape :: Ptr () } deriving (Show)


data Rectangle = Rectangle
  { rectLeft :: CLong
  , rectTop :: CLong
  , rectRight :: CLong
  , rectBottom :: CLong
  } deriving (Show)

data Array2D a = Array2D
  { arrData :: Ptr a
  , arrNC :: CLong
  , arrNR :: CLong
  , arrCur :: Ptr a
  , arrLast :: Ptr a
  , arrAtStart :: Ptr a
  }

instance Storable (Array2D a) where
  sizeOf _ = 64
  alignment _ = 8
  peek ptr = do
    d <- peekByteOff ptr 0
    c <- peekByteOff ptr 8
    r <- peekByteOff ptr 16
    cur <- peekByteOff ptr 24
    l <- peekByteOff ptr 32
    a <- peekByteOff ptr 40
    return $ Array2D d c r cur l a
  poke ptr (Array2D d c r cur l a) = do
    pokeByteOff ptr 0 d
    pokeByteOff ptr 8 c
    pokeByteOff ptr 16 r
    pokeByteOff ptr 24 cur
    pokeByteOff ptr 32 l
    pokeByteOff ptr 40 a


data RGBPixel = RGBPixel
  { rgbRed :: CChar
  , rgbGreen :: CChar
  , rgbBlue :: CChar
  } deriving (Show)

instance Storable RGBPixel where
  sizeOf _ = 3
  alignment = sizeOf
  peek ptr = do
    let charPtr = castPtr ptr
    red <- peekElemOff charPtr 0
    green <- peekElemOff charPtr 0
    blue <- peekElemOff charPtr 0
    return $ RGBPixel red green blue
  poke ptr (RGBPixel r g b) = do
    let charPtr = castPtr ptr
    pokeElemOff charPtr 0 r
    pokeElemOff charPtr 1 g
    pokeElemOff charPtr 2 b

zeroRect = Rectangle 0 0 0 0

instance Storable Rectangle where
  sizeOf _ = (sizeOf (0 :: CLong)) * 4
  alignment _ = 1
  peek ptr = do
    let longPtr = castPtr ptr :: Ptr CLong
    l <- peekElemOff longPtr 0
    t <- peekElemOff longPtr 1
    r <- peekElemOff longPtr 2
    b <- peekElemOff longPtr 3
    return $ Rectangle l r t b

  poke ptr (Rectangle l t r b) = do
    let longPtr = castPtr ptr :: Ptr CLong
    pokeElemOff longPtr 0 l
    pokeElemOff longPtr 1 t
    pokeElemOff longPtr 2 r
    pokeElemOff longPtr 3 b
