module Pm.Create where

import Pm.Config
import Data.Char (toLower)
import Pm.Init
import Pm.Interaction
import System.Directory


-- Go through the interactive process
create :: IO ()
create = do
  currentDir <- getCurrentDirectory
  contents <- listDirectory currentDir
  case contents of
    [] -> do
      dirName <- directoryName
      projectName <- askWithSuggestion "What would you like to call the project?" dirName
      language <- askSoftly "What language will the project will be written in?"
      projectPackageManager <- case language of
        Nothing -> askSoftly "What package manager will you be using?"
        -- TODO: Change this to be aware of the language specific 
        Just lang -> askSoftly "What package manager will you be using?"
      let projectLanguage = (flip fmap) language $
            \theLanguage ->
            case toLower <$> theLanguage of "python" -> Python
                                            "haskell" -> Haskell
                                            other -> Language other
      initialize $ ProjectConfig { name = projectName
                                 , language = projectLanguage
                                 -- TODO: cases for package manager
                                 , packageManager = UnknownPackageManager
                                 }
                             
    _ -> putStrLn "not ready..."

  
