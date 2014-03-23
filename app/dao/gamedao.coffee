DataAccess = require '../dataaccess'

class GameDao

  @init: (@io) ->
    GameEngine = require('../hangman/gameengine').GameEngine

    gamedao = @
    @retrieveGames (err, games) ->
      throw err if err
      gamedao.commands = new Array()
      for game in games
        engine = new GameEngine io, game
        gamedao.commands[game.name] = new Array()
        gamedao.commands[game.name]['instance'] = engine
        gamedao.commands[game.name]['functions'] = ['join', 'leave', 'guess', 'report']
        engine.start()
      GameDao.logger().info "initialised games"

  @logger: () ->
    @io.log

  @retrieveGames: (callback) ->
    DataAccess.db.Game.findAll().complete (err, games) ->
      callback err, games

module.exports = GameDao