class GamesController < ApplicationController

  def index
    redirect_to game_url(3)
  end

  def show

    @game = Game.find(params[:id])
    @entries = @game.entries

    @lastEntry = @entries.last
  end

  def new

    @game = Game.new()
  end

  def create

    @game = Game.new(game_params)

    if @game.save

      redirect_to game_url(@game.id)
    else

      render 'new'
    end
  end

  def update

    @game = Game.find(params[:id])
    logger.info
    if game_params[:entry][:content] != ""
      if @game.entries.last != nil
        if @game.entries.last.id != cookies[:lastPostId].to_i
          if @game.entries.last.vote_number >= 0
          @entry = @game.entries.build(game_params[:entry])
          @entry.vote_number = 0;
          @entry.save
          cookies[:lastPostId] = @entry.id
        else
          @game.entries.last.destroy
          @entry = @game.entries.build(game_params[:entry])
          @entry.vote_number = 0;
          @entry.save
          cookies[:lastPostId] = @entry.id
        end
        end
      else
          @entry = @game.entries.build(game_params[:entry])
          @entry.vote_number = 0;
          @entry.save
          cookies[:lastPostId] = @entry.id
      end
    elsif game_params[:vote] != nil && cookies[:lastPostId].to_i != @game.entries.last.id
          @entry = @game.entries.find(game_params[:vote][:entry_id])
          if cookies[:lastVoted].to_i == @entry.id
            if game_params[:vote][:direction] == "up" && cookies[:lastVotedDirection] != "up"
            @entry.vote_number = @entry.vote_number + 1
            cookies[:lastVotedDirection] = "up"

            elsif game_params[:vote][:direction] == "down" && cookies[:lastVotedDirection] != "down"

            @entry.vote_number = @entry.vote_number - 1
            cookies[:lastVotedDirection] = "down"

            end
          else
            if game_params[:vote][:direction] == "up"

              @entry.vote_number = @entry.vote_number + 1
              cookies[:lastVotedDirection] = "up"

            elsif game_params[:vote][:direction] == "down"

              @entry.vote_number = @entry.vote_number - 1
              cookies[:lastVotedDirection] = "down"

            end
          end
          @entry.save
          cookies[:lastVoted] = @entry.id
    end

    redirect_to game_url(@game.id)

  end

  private

  def game_params

    params.require(:game).permit( :name, :rules, entry: [:content, :user_name, :vote_number], vote: [:direction, :entry_id] )
  end

end
