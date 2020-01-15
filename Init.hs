module Init where

import Config
import System.Directory
import System.FilePath (splitExtension, (</>), takeDirectory, makeRelative)
 
 {-# SCC "" #-} 
-- 

-- This is where the magic happens
initialize :: ProjectConfig -> IO ()
initialize poperties = do
  dir <- getCurrentDirectory
  return ()
  -- TODO: Add it to the symlinked list

-- Check to see whether a certain extension exists in a directory
hasFile :: FilePath -> String -> IO Bool
hasFile directory extension = do
  files <- listDirectory directory
  return . null . (filter (\(_,ext) -> ext == extension)) . (map splitExtension) $ files

-- Add a project to the projects
addToProjects :: FilePath -> IO ()
addToProjects dir = do
  current <- getCurrentDirectory
  homeDir <- getHomeDirectory
  let projectsDir = homeDir </> pmDir </> "projects"
  createDirectoryIfMissing True projectsDir
  projectName <- directoryName
  createFileLink current $ projectsDir </> projectName
-- Add a project folder to a symlinked group
addToGroup :: String -> FilePath -> IO ()
addToGroup group dir = do
  current <- getCurrentDirectory
  homeDir <- getHomeDirectory
  let projectsDir = homeDir </> pmDir </> group
  createDirectoryIfMissing True projectsDir
  projectName <- directoryName
  createFileLink current $ projectsDir </> projectName

-- Get name of the current directory
-- There must an easier way
directoryName :: IO FilePath
directoryName = do
  currentDir <- getCurrentDirectory
  let parent = takeDirectory currentDir
  return $ makeRelative parent currentDir
