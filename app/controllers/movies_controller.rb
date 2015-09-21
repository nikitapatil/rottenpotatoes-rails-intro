class MoviesController < ApplicationController
# test comment
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_criteria = params[:sort_criteria]
     if params[:ratings] != nil
       @movies = Movie.order(params[:sort_criteria]).where("rating IN (?)", params[:ratings])
     else
      @movies = Movie.order(params[:sort_criteria])
     end

    @all_ratings = Movie.get_ratings
    if params[:ratings] != nil
      @all_ratings = params[:ratings]
      @movies = Movie.where("rating IN (?)", params[:ratings])
    end
    session[:sort_criteria] = @sort_criteria
    session[:ratings] = @all_ratings

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
