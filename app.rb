require 'bundler'
require 'colorize'
require 'word_wrap/core_ext'
require 'json'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/game'
require 'app/board'
require 'app/player'
require 'app/boardcase'
require 'app/application'
require 'views/show'

app = Application.new
app.play_app
