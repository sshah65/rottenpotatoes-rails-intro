class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    @highlight = ""
    @all_ratings = Movie.ratings
    @selectedMovies = []
    
    if params[:reset] then
      session.clear
      redirect_to movies_path
    end
    
    reDir = false
    
    if session[:ratings] != nil and params[:ratings] == nil then
      params[:ratings] = session[:ratings]
      reDir = true
    end
    
    if session[:sort] != nil and params[:sort] == nil then
      params[:sort] = session[:sort]
      reDir = true
    end
    
    if reDir then
      redirect_to movies_path({:sort => params[:sort], :ratings => params[:ratings]})
    end
    
    if params[:ratings] != nil then
      session[:ratings] = params[:ratings]
      params[:ratings].each do |rating|
        @selectedMovies += rating
      end
    else
      @selectedMovies = @all_ratings
    end
    
    if params[:sort] == nil then
      @movies = Movie.where({rating: @selectedMovies})
    elsif params[:sort] == "title" or params[:sort] == "release_date" then
      @movies = Movie.order(params[:sort]).where({rating: @selectedMovies})
      session[:sort] = params[:sort]
      @highlight = params[:sort]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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