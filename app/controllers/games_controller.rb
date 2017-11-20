require 'open-uri'

class GamesController < ApplicationController

  def game
    @grid = generate_grid(9).join(" ")
    @start_time = Time.now
  end

  def score
    # TODO: runs the game and return detailed hash of result
    @start_time = params[:start_time].to_time
    @grid = params[:grid].downcase.split(" ")
    @end_time = Time.now
    @attempt = params[:attempt].downcase
    @score = 0
    if word_verification(@attempt) == false
      @message = "not an english word"
    elsif letter_include?(@attempt, @grid) == false
      @message = "not in the grid"
    else
      @score = (@attempt.size * 10) - (@end_time - @start_time)
      @message = "Well done"
    end
    @time = (@end_time - @start_time)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters (nine)
    alphabet = ("a".."z").to_a
    (alphabet.sample(grid_size) + alphabet.sample(grid_size)).sample(grid_size)
  end

  def word_verification(attempt)
    url = "https://wagon-dictionary.herokuapp.com/"
    JSON.parse(open(url + attempt.downcase).read)["found"]
  end

  def letter_include?(attempt, grid)
    letters = @attempt.split("")
    truth = true
    letters.each do |letter|
      if letters.count(letter.upcase) <= grid.count(letter.upcase)
        truth = true
      else
        return false
      end
    end
  end
end
