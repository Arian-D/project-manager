module Pm.Config where

import System.Directory
import System.FilePath


-- Project manager's directory
pmDir = ".pm" :: FilePath

-- Projects folder within which tags/groups are stored
tagsDir = pmDir </> "tags" :: FilePath

-- Tags path
tagsPath :: IO FilePath
tagsPath = (</> tagsDir) <$> pmPath

-- Project manager's path
pmPath :: IO FilePath
pmPath = (</> pmDir) <$> getHomeDirectory

-- Name of the database
dbName = "pm.db" :: FilePath

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
