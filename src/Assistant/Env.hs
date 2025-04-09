{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Assistant.Env (BotEnv (..), loadBotEnv) where

import Control.Monad.IO.Class (MonadIO)
import Data.Kind (Type)
import Telegram.Bot.API (Token (..))
import Toml (TomlCodec, (.=))
import Toml qualified

type BotEnv :: Type
newtype BotEnv
  = BotEnv
  { token :: Token
  -- ^ The bot token for the Telegram bot.
  }
  deriving stock (Show)

botEnvCodec :: TomlCodec BotEnv
botEnvCodec =
  BotEnv
    <$> Toml.diwrap (Toml.text "bot.token") .= token

loadBotEnv :: (MonadIO m) => FilePath -> m BotEnv
loadBotEnv = Toml.decodeFile botEnvCodec