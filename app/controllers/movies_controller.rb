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
    if params[:sort_criteria] == "title" || params[:sort_criteria] == "release_date"
      @movies = Movie.order(params[:sort_criteria])
      session[:sort_criteria] = params[:sort_criteria]
    elsif session.has_key?(:sort_criteria)
      params[:sort_criteria] = session[:sort_criteria]
      # @movies = Movie.order(params[:sort_criteria])
      redirect_to movies_path(:sort_criteria => params[:sort_criteria], :ratings =>params[:ratings])
    end


# populate the checkboxes
    @all_ratings = Movie.get_ratings
    if params[:ratings] != nil
      session[:ratings] = params[:ratings]
      @selected_ratings = params[:ratings]
      @movies = Movie.where("rating IN (?)", params[:ratings])
    else
      if session.has_key?(:ratings)
        params[:ratings] = session[:ratings]
        # redirect_to movies_path(:sort_criteria => params[:sort_criteria], :ratings =>params[:ratings])
      end
      @selected_ratings = @all_ratings
    end

    #  if redirect == 1

    #  end
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
