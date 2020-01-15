module Pm where

import Control.Exception (try, IOException)
import Control.Exception (tryJust)
import Pm.Config
import Pm.Create
import Pm.Init
import Pm.Interaction
import System.Directory
import System.Environment (getArgs, getEnv)
import System.FilePath ( (</>) )
import System.Process

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
       "edit" -> edit $ head subcommands
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

-- Open the $EDITOR to edit
edit :: String -> IO ()
edit project = do
  eitherEditor <- try $ getEnv "EDITOR"
  case eitherEditor :: Either IOError String of
    -- TODO: Ask interactively
    Left _ -> putStrLn "You need to specify the $EDITOR environment variable"
    Right editor -> do
      path <- projectPath project
      callCommand $ unwords [editor, path]


projectPath :: String -> IO FilePath
projectPath project = do
  homeDir <- getHomeDirectory
  return $ homeDir </> pmDir </> "projects" </> project

-- Print help
-- TODO: Detect wrong usage, empty args (which might need to be handled), or wrong commands
help :: IO ()
help = mapM_ putStrLn [ "Project Manager"
                      , "usage:"
                      , "  pm setup\t Setup project manager"
                      , "  pm add\t add the current directory to the list of projects"
                      , "  pm list\t List the projects"
                      , "  pm create\t Create or initialize a project"
                      , "  pm edit\t Open a project in your editor"
                      ]
