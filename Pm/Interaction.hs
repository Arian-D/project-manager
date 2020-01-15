module Pm.Interaction where

import Data.Char (toLower)

-- Ask bool with a pre-chosen backup
yesOrNoLeaning :: Bool -> String -> IO Bool
yesOrNoLeaning tendency question = do
  mapM_ putStr [question, " [y/n]: "]
  response <- getChar
  return $ case toLower response of
    'y' -> True
    'n' -> False
    _ -> tendency

-- Force the user to choose y or n
yesOrNoStrict :: String -> IO Bool
yesOrNoStrict question = do
  mapM_ putStr [question, " [y/n] "]
  response <- getChar
  if toLower response == 'y'
    then return True
    else do putStrLn ""
            yesOrNoStrict question

askSoftly :: String -> IO (Maybe String)
askSoftly question = do
  putStr question
  response <- getLine
  if null response
    then return Nothing
    else return . Just $ response
-- Ask with suggestion
askWithSuggestion :: String -> String -> IO String
askWithSuggestion question suggestion = do
  mapM_ putStr [question, " [", suggestion, "]: "]
  response <- getLine
  if null response
    then return suggestion
    else return response
      
    


