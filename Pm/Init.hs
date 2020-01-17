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

-- This section might go in another file


-- Add a project to a group(s)
-- TODO: Make this more intelligent
add :: FilePath -> [String] -> IO ()
add dir groups = do
  if null groups
    then addToProjects dir
    else mapM_ (addToGroup dir) groups
    
-- Add a project to the projects
addToProjects :: FilePath -> IO ()
addToProjects = addToGroup tagsDir

-- Add a project folder to a symlinked group
addToGroup :: FilePath -> String -> IO ()
addToGroup group dir = do
  current <- getCurrentDirectory
  groupsDir <- (</> group) <$> tagsPath
  createDirectoryIfMissing True groupsDir
  projectName <- directoryName
  itExists <- isAlreadyInGroup group projectName
  if itExists
    then putStrLn . concat $ [ "Warning: The project "
                             , projectName
                             , " already exists in "
                             , group
                             ]
    else createFileLink current $ groupsDir </> projectName


-- TODO: Add a function that removes a function
-- It needs to go through each folder and remove the symlink

-- Remove project's tag
removeProjectFromGroup :: String -> FilePath -> IO ()
removeProjectFromGroup projectName group = do
  projectInGroupPath <- (</> group </> projectName) <$> tagsPath
  itExists <- isAlreadyInGroup group projectName
  if itExists
    then removeFile projectInGroupPath
    else putStrLn . concat $ [ "It seems that the project "
                             , projectName
                             , " is not in "
                             , group]

-- Check to see if a project exists
isAProject :: String -> IO Bool
isAProject = isAlreadyInGroup "projects"

-- Check to see if project exists within a group
isAlreadyInGroup :: String -> FilePath -> IO Bool
isAlreadyInGroup group projectName = do
  homeDir <- getHomeDirectory
  doesDirectoryExist $ foldl1 (</>) [homeDir, pmDir, group, projectName]
  
-- Get name of the current directory
-- There must be an easier way
directoryName :: IO FilePath
directoryName = do
  currentDir <- getCurrentDirectory
  let parent = takeDirectory currentDir
  return $ makeRelative parent currentDir
