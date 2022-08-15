require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def english_word(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_dictionary = URI.open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  # The method returns true if the block never returns false or nil
  def letter_in_grid(answer, letters)
    answer.chars.all? { |letter| letters.include?(letter.upcase) }
  end

  def score
    letter = params[:letters]
    @answer = params[:word]
    if !letter_in_grid(@answer, letter)
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{letter}."
    elsif !english_word(@answer)
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif letter_in_grid(@answer, letter) && !english_word(@answer)
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    elsif letter_in_grid(@answer, letter) && english_word(@answer)
      @result = "Congratulation! #{@answer.upcase} is a valid English word."
    end
  end
end
