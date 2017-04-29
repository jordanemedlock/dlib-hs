{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_dlib_hs (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/jordanemedlock/Projects/dlib-hs/.cabal-sandbox/bin"
libdir     = "/Users/jordanemedlock/Projects/dlib-hs/.cabal-sandbox/lib/x86_64-osx-ghc-8.0.1/dlib-hs-0.1.0.0-86grQ9cruXN7xHYipuvNgG"
datadir    = "/Users/jordanemedlock/Projects/dlib-hs/.cabal-sandbox/share/x86_64-osx-ghc-8.0.1/dlib-hs-0.1.0.0"
libexecdir = "/Users/jordanemedlock/Projects/dlib-hs/.cabal-sandbox/libexec"
sysconfdir = "/Users/jordanemedlock/Projects/dlib-hs/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "dlib_hs_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "dlib_hs_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "dlib_hs_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "dlib_hs_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "dlib_hs_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
