module Pm.Init where

import Pm.Config
import System.Directory
import System.FilePath (splitExtension, (</>), takeDirectory, makeRelative)
 
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

-- Add a project to a list of groups
add :: FilePath -> [String] -> IO ()
add dir groups = do
  if null groups
    then addToProjects dir
    else mapM_ (addToGroup dir) groups
    
-- Add a project to the projects
addToProjects :: FilePath -> IO ()
addToProjects dir = addToGroup dir "projects"

-- Add a project folder to a symlinked group
addToGroup :: FilePath -> String -> IO ()
addToGroup dir group = do
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
