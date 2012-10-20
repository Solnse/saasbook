class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    results = Movie.where(params[:ratings].present? ? {:rating => (params[:ratings].keys)} : {})
    sort = params[:sort] || session[:sort]
    if sort == 'title'
      @movies = results.sort_by { |l| l.title }
      @current = 'title'
    elsif sort == 'release_date'
      @movies = results.sort_by { |l| l.release_date }
      @current = 'release_date'
    else
      @movies = results
    end

    @all_ratings = ['G','PG','PG-13','R']
    @checked = params[:ratings].present? ? params[:ratings].keys : @all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
