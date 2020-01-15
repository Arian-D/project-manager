module Pm.Config where

-- Project manager's directory
pmDir = ".pm" :: FilePath


-- A record to contain primtive properties of projects
-- It might become a lens, depending on the growing complexity
data ProjectConfig =
  ProjectConfig { name :: String
                , language :: Maybe Language
                , packageManager :: PackageManager
                } deriving Show


-- Some common languages to work with
data Language = Python | Haskell | Language String
  deriving Show

-- Common package managers
data PackageManager = Pip | Cabal | Stack | UnknownPackageManager
  deriving Show
