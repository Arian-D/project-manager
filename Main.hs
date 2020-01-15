module Main where

import Config
import Control.Exception (try, IOException)
import Create
import Init
import Interaction
import System.Directory
import System.Environment (getArgs, getEnv)
import System.FilePath ( (</>) )

-- Parse args
main :: IO ()
main = do
  currentDir <- getCurrentDirectory
  args <- getArgs
  case args of
    [] -> help
    (command:subcommands) ->
     case command of
       "setup" -> setup
       "list" -> showAllProjects
       "add" -> add currentDir subcommands
       "create" -> create
       otherwise -> help

-- Show all the projects symlinked to $HOME/.pm/projects
showAllProjects = do
  homeDir <- getHomeDirectory
  let pmPath = homeDir </> pmDir
  pmProjects <- (try . listDirectory) $ pmPath </> "projects"
  case pmProjects :: Either IOException [FilePath] of
    Left error -> print error
    Right projects -> if null projects
      then putStrLn "No projects :("
      else putStrLn $ unlines projects
  return ()

-- A mere "installation" of pm
setup :: IO ()
setup = do
  homeDir <- getHomeDirectory
  let pmPath = homeDir </> pmDir
  itsAlreadyThere <- doesDirectoryExist pmPath
  if itsAlreadyThere
    then do
    yes <- yesOrNoLeaning False "You seem to already have pm; would you like to set it up again?"
    if yes
      then removeDirectoryRecursive pmPath
      else return ()
    else do
    createDirectoryIfMissing True pmPath
    putStrLn "Done"



-- Print help
-- TODO: Detect wrong usage, empty args (which might need to be handled), or wrong commands
help :: IO ()
help = mapM_ putStrLn [ "Project Manager"
                      , "usage:"
                      , "  pm setup\t Setup project manager"
                      , "  pm add\t add the current directory to the list of projects"
                      , "  pm list\t List the projects"
                      , "  pm create\t Create or initialize a project"
                      -- , "  pm edit\t Open a project in your editor"
                      -- , "  pm tag\t Tag a project with a keyword for grouping"
                      ]
